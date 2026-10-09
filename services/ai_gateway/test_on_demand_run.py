"""RED for on-demand gateway boundary. No network, secret, or Supabase."""

import base64
import hashlib
import unittest

from on_demand_run import OnDemandFailure, OnDemandGateway


PNG = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
    'hKmMIQAAAABJRU5ErkJggg==')
PIXEL = hashlib.sha256(PNG).hexdigest()
SOURCE = 'a' * 64


def valid_request(**overrides):
    body = {
        'operation': 'op-1',
        'capability': 'page_vision_extract',
        'page_ref': 'page-1',
        'source_hash': SOURCE,
        'pixel_hash': PIXEL,
        'render_profile': 'test-v1',
        'page_png': PNG,
        'reasoning_effort': 'high',
        'max_output_tokens': 64,
        'max_elapsed_seconds': 5,
        'idempotency_key': 'key-1',
    }
    body.update(overrides)
    return body


def good_owner(authorization):
    if authorization == 'Bearer good':
        return 'owner-1'
    raise OnDemandFailure('AI_UNAUTHORIZED')


def completed_vision(calls):
    def run(adapter_request):
        calls.append(adapter_request)
        return {
            'model': 'user-route',
            'reasoning_effort': adapter_request['reasoning_effort'],
            'extract': {
                'schemaVersion': 'page-extract-v1',
                'sourceHash': SOURCE,
                'pixelHash': PIXEL,
                'renderProfile': 'test-v1',
                'pageRef': 'page-1',
                'extractionVersion': 'page-vision-extract-v1',
                'coverage': 'complete',
                'blocks': [
                    {'id': 'b1', 'order': 0, 'kind': 'paragraph',
                     'text': 'T.', 'bbox': {'x': 0.1, 'y': 0.2,
                                            'w': 0.5, 'h': 0.1},
                     'confidence': 0.9, 'uncertain': False},
                ],
                'figures': [],
            },
            'usage': {'input_tokens': 10, 'output_tokens': 20},
            'elapsed_seconds': 1.0,
            'provider_request_id': 'req_123',
        }
    return run


class OnDemandGatewayTests(unittest.TestCase):
    def make(self, run=None):
        calls = []
        gateway = OnDemandGateway(
            verify_owner=good_owner,
            run_vision=run if run is not None else completed_vision(calls),
        )
        return gateway, calls

    def test_happy_path_returns_receipt_and_replays_duplicate(self):
        gateway, calls = self.make()
        first = gateway.handle(valid_request(), authorization='Bearer good')
        self.assertEqual(first['status'], 'completed')
        self.assertEqual(len(first['requestId']), 32)
        self.assertNotIn('page_png', first)
        second = gateway.handle(valid_request(), authorization='Bearer good')
        self.assertEqual(second['requestId'], first['requestId'])
        self.assertEqual(len(calls), 1)

    def test_rejects_bad_auth_before_spend(self):
        gateway, calls = self.make()
        for bad in (None, '', 'Bearer bad'):
            with self.assertRaises(OnDemandFailure) as caught:
                gateway.handle(valid_request(), authorization=bad)
            self.assertEqual(caught.exception.code, 'AI_UNAUTHORIZED')
        self.assertEqual(calls, [])

    def test_rejects_malformed_request_before_spend(self):
        gateway, calls = self.make()
        bad_shape = valid_request()
        bad_shape['extra'] = 1
        cases = [
            bad_shape,
            valid_request(capability='teacher_fa'),
            valid_request(reasoning_effort='low'),
            valid_request(max_output_tokens=0),
            valid_request(max_elapsed_seconds=0),
            valid_request(max_elapsed_seconds=700),
            valid_request(page_png=b'not-a-png'),
            valid_request(pixel_hash='e' * 64),
            valid_request(idempotency_key=''),
        ]
        for bad in cases:
            with self.assertRaises(OnDemandFailure):
                gateway.handle(bad, authorization='Bearer good')
        self.assertEqual(calls, [])

    def test_conflicting_reuse_of_key_fails_closed(self):
        gateway, calls = self.make()
        gateway.handle(valid_request(), authorization='Bearer good')
        with self.assertRaises(OnDemandFailure) as caught:
            gateway.handle(valid_request(reasoning_effort='xhigh'),
                           authorization='Bearer good')
        self.assertEqual(caught.exception.code, 'AI_RUN_CONFLICT')
        self.assertEqual(len(calls), 1)

    def test_upstream_failure_stores_stable_error(self):
        def failing(_request):
            raise OnDemandFailure('AI_INCOMPLETE_RESPONSE')

        gateway, _ = self.make(run=failing)
        with self.assertRaises(OnDemandFailure) as caught:
            gateway.handle(valid_request(), authorization='Bearer good')
        self.assertEqual(caught.exception.code, 'AI_INCOMPLETE_RESPONSE')
        with self.assertRaises(OnDemandFailure) as caught:
            gateway.handle(valid_request(), authorization='Bearer good')
        self.assertEqual(caught.exception.code, 'AI_INCOMPLETE_RESPONSE')

    def test_retryable_upstream_failure_does_not_block_same_key(self):
        calls = []

        def flaky(_request):
            calls.append(1)
            if len(calls) == 1:
                raise OnDemandFailure('AI_RATE_LIMITED')
            return {
                'model': 'm', 'reasoning_effort': 'high',
                'extract': {
                    'schemaVersion': 'page-extract-v1',
                    'sourceHash': SOURCE,
                    'pixelHash': PIXEL,
                    'renderProfile': 'test-v1',
                    'pageRef': 'page-1',
                    'extractionVersion': 'page-vision-extract-v1',
                    'coverage': 'complete',
                    'blocks': [
                        {'id': 'b1', 'order': 0, 'kind': 'paragraph',
                         'text': 'T.', 'bbox': {'x': 0.1, 'y': 0.2,
                                                'w': 0.5, 'h': 0.1},
                         'confidence': 0.9, 'uncertain': False},
                    ],
                    'figures': [],
                },
                'usage': {}, 'elapsed_seconds': 1.0,
                'provider_request_id': None,
            }

        gateway, _ = self.make(run=flaky)
        with self.assertRaises(OnDemandFailure) as caught:
            gateway.handle(valid_request(), authorization='Bearer good')
        self.assertEqual(caught.exception.code, 'AI_RATE_LIMITED')
        receipt = gateway.handle(valid_request(), authorization='Bearer good')
        self.assertEqual(receipt['status'], 'completed')
        self.assertEqual(len(calls), 2)

    def test_retryable_gateway_set_matches_route_no_failed_store(self):
        import importlib.util
        from on_demand_run import _RETRYABLE_FAILURES
        path = 'C:/Users/K1/Desktop/Projects/Trace/api/trace-ai-run.py'
        spec = importlib.util.spec_from_loader('trace_ai_run_probe', loader=None)
        module = importlib.util.module_from_spec(spec)
        module.__file__ = path
        with open(path, encoding='utf-8') as handle:
            exec(compile(handle.read(), path, 'exec'), module.__dict__)
        for code in _RETRYABLE_FAILURES:
            self.assertIn(
                code, module._NO_FAILED_STORE,
                msg=f'{code} must not write a durable failed row')

    def test_owner_isolation_same_key(self):
        def owners(authorization):
            if authorization in ('Bearer a', 'Bearer b'):
                return 'owner-a' if authorization == 'Bearer a' else 'owner-b'
            raise OnDemandFailure('AI_UNAUTHORIZED')

        calls = []
        gateway = OnDemandGateway(
            verify_owner=owners,
            run_vision=completed_vision(calls),
        )
        first = gateway.handle(valid_request(), authorization='Bearer a')
        second = gateway.handle(valid_request(), authorization='Bearer b')
        self.assertNotEqual(first['requestId'], second['requestId'])
        self.assertEqual(len(calls), 2)

    def test_control_page_ref_rejected_before_vision(self):
        gateway, calls = self.make()
        for marker in ('\u202e', '\u2066'):
            with self.assertRaises(OnDemandFailure) as caught:
                gateway.handle(
                    valid_request(page_ref=f'page{marker}-1'),
                    authorization='Bearer good',
                )
            self.assertEqual(caught.exception.code, 'AI_VISION_REQUEST_INVALID')
        self.assertEqual(calls, [])

    def test_control_operation_rejected_before_vision(self):
        gateway, calls = self.make()
        with self.assertRaises(OnDemandFailure) as caught:
            gateway.handle(
                valid_request(operation='op\u202e-1'),
                authorization='Bearer good',
            )
        self.assertEqual(caught.exception.code, 'AI_VISION_REQUEST_INVALID')
        self.assertEqual(calls, [])

    def test_long_operation_rejected_before_composed_adapter(self):
        # Owner prefix adds len(owner)+1 at composition; composed identity
        # stays within the adapter 128 bound only when raw operation <= 91.
        gateway, calls = self.make()
        with self.assertRaises(OnDemandFailure) as caught:
            gateway.handle(
                valid_request(operation='o' * 92),
                authorization='Bearer good',
            )
        self.assertEqual(caught.exception.code, 'AI_VISION_REQUEST_INVALID')
        self.assertEqual(calls, [])
        receipt = gateway.handle(
            valid_request(operation='o' * 91),
            authorization='Bearer good',
        )
        self.assertEqual(receipt['status'], 'completed')
        self.assertEqual(len(calls), 1)


if __name__ == '__main__':
    unittest.main()

    def test_completed_receipt_carries_validated_extract(self):
        gateway, _ = self.make()
        receipt = gateway.handle(
            valid_request(), authorization='Bearer good')
        extract = receipt.get('extract')
        self.assertIsInstance(extract, dict)
        self.assertEqual(extract.get('schemaVersion'), 'page-extract-v1')
        self.assertEqual(extract.get('sourceHash'), SOURCE)
        self.assertEqual(extract.get('pixelHash'), PIXEL)
        self.assertEqual(extract.get('pageRef'), 'page-1')
        self.assertNotIn('page_png', receipt)
