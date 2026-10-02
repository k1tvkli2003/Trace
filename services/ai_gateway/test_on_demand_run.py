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
            'extract': {'ok': True},
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
            valid_request(max_output_tokens=20000),
            valid_request(max_elapsed_seconds=0),
            valid_request(max_elapsed_seconds=400),
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


if __name__ == '__main__':
    unittest.main()
