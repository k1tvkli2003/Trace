"""RED-3: thin Vercel route for POST /api/trace-ai-run. No implementation yet.

Delegates to existing validation/budget logic (cloud_gateway wire
preflight + OnDemandGateway), preserves fail-closed behavior.
No secret in response/log/receipt. Missing config fails closed.
"""
import base64
import hashlib
import importlib.util
import json
import unittest

PNG = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
    'hKmMIQAAAABJRU5ErkJggg==')
PIXEL = hashlib.sha256(PNG).hexdigest()
SOURCE = 'a' * 64
REPO = 'C:/Users/K1/Desktop/Projects/Trace'


def load_route():
    path = REPO + '/api/trace-ai-run.py'
    spec = importlib.util.spec_from_loader('trace_ai_run', loader=None)
    module = importlib.util.module_from_spec(spec)
    module.__file__ = path
    with open(path, encoding='utf-8') as handle:
        source = handle.read()
    code = compile(source, path, 'exec')
    exec(code, module.__dict__)
    return module


def wire(**overrides):
    body = {
        'operation': 'op-1',
        'capability': 'page_vision_extract',
        'page_ref': 'page-1',
        'source_hash': SOURCE,
        'pixel_hash': PIXEL,
        'render_profile': 'test-v1',
        'page_png': base64.b64encode(PNG).decode('ascii'),
        'reasoning_effort': 'high',
        'max_output_tokens': 64,
        'max_elapsed_seconds': 5,
        'idempotency_key': 'key-1',
    }
    body.update(overrides)
    return json.dumps(body).encode()


def completed_vision(result_holder):
    def run(adapter_request):
        result_holder.append(adapter_request)
        return {
            'model': 'user-route',
            'reasoning_effort': adapter_request['reasoning_effort'],
            'usage': {'input_tokens': 10, 'output_tokens': 20},
            'elapsed_seconds': 1.0,
            'provider_request_id': 'req_123',
        }
    return run


def good_owner(authorization):
    from on_demand_run import OnDemandFailure
    if authorization == 'Bearer good':
        return 'owner-1'
    raise OnDemandFailure('AI_UNAUTHORIZED')


class RouteTests(unittest.TestCase):
    def test_success_returns_200_receipt_without_secret(self):
        route = load_route()
        calls = []
        inserts = []

        def insert(row):
            inserts.append(row)
            return dict(row)

        status, body = route.handle_request(
            wire(), 'Bearer good',
            verify_owner=good_owner,
            run_vision=completed_vision(calls),
            receipt_insert=insert,
        )
        self.assertEqual(status, 200)
        self.assertEqual(body['receipt']['status'], 'completed')
        blob = json.dumps(body).lower()
        for banned in ('page_png', 'service_role', 'api_key', 'bearer good'):
            self.assertNotIn(banned, blob)
        self.assertEqual(len(calls), 1)
        self.assertEqual(len(inserts), 1)

    def test_transient_failure_maps_rate_limit_to_429(self):
        from on_demand_run import OnDemandFailure
        route = load_route()
        self.assertEqual(route._status_for('AI_RATE_LIMITED'), 429)
        self.assertEqual(route._status_for('AI_RUN_IN_FLIGHT'), 429)
        self.assertIn('rate limited',
                      route._safe_message('AI_RATE_LIMITED').lower())
        status, body = route.handle_request(
            wire(), 'Bearer good',
            verify_owner=good_owner,
            run_vision=lambda request: (_ for _ in ()).throw(
                OnDemandFailure('AI_RATE_LIMITED')),
            receipt_insert=lambda row: dict(row),
        )
        self.assertEqual(status, 429)
        self.assertEqual(body['error']['code'], 'AI_RATE_LIMITED')

    def test_transient_failure_can_complete_same_key_without_failed_receipt(self):
        from on_demand_run import OnDemandFailure

        class Conflict(Exception):
            def __init__(self, existing):
                self.existing = existing

        for code in ('AI_RATE_LIMITED', 'AI_PROVIDER_UNAVAILABLE',
                     'AI_RETRY_NOT_READY'):
            with self.subTest(code=code):
                route = load_route()
                rows = {}
                calls = []
                success = completed_vision(calls)

                def vision(request):
                    if not calls:
                        calls.append(request)
                        raise OnDemandFailure(code)
                    return success(request)

                def insert(row):
                    key = (row['owner'], row['idempotency_key'])
                    if key in rows:
                        raise Conflict(rows[key])
                    rows[key] = dict(row)
                    return dict(row)

                wiring = dict(
                    verify_owner=good_owner, run_vision=vision,
                    receipt_insert=insert,
                    receipt_lookup=lambda owner, key: rows.get((owner, key)),
                    receipt_conflict=Conflict,
                )
                first_status, first_body = route.handle_request(
                    wire(), 'Bearer good', **wiring)
                self.assertEqual(first_body['error']['code'], code)
                self.assertGreaterEqual(first_status, 400)
                self.assertEqual(rows, {}, 'transient failure poisoned durable key')
                status, body = route.handle_request(
                    wire(), 'Bearer good', **wiring)
                self.assertEqual(status, 200)
                self.assertEqual(body['receipt']['status'], 'completed')
                self.assertEqual(len(calls), 2)
                self.assertEqual(len(rows), 1)
                self.assertEqual(next(iter(rows.values()))['status'], 'completed')

    def test_bad_auth_fails_closed_without_spend(self):
        route = load_route()
        calls = []
        status, body = route.handle_request(
            wire(), 'Bearer bad',
            verify_owner=good_owner,
            run_vision=completed_vision(calls),
            receipt_insert=lambda row: dict(row),
        )
        self.assertEqual(status, 401)
        self.assertEqual(body['error']['code'], 'AI_UNAUTHORIZED')
        self.assertEqual(calls, [])

    def test_invalid_input_fails_closed_without_spend(self):
        route = load_route()
        calls = []
        bad = wire()
        obj = json.loads(bad)
        obj['reasoning_effort'] = 'low'
        status, body = route.handle_request(
            json.dumps(obj).encode(), 'Bearer good',
            verify_owner=good_owner,
            run_vision=completed_vision(calls),
            receipt_insert=lambda row: dict(row),
        )
        self.assertEqual(status, 400)
        self.assertEqual(body['error']['code'], 'AI_VISION_REQUEST_INVALID')
        self.assertEqual(calls, [])

    def test_missing_wiring_fails_closed(self):
        route = load_route()
        status, body = route.handle_request(
            wire(), 'Bearer good',
            verify_owner=None, run_vision=None, receipt_insert=None,
        )
        self.assertEqual(status, 503)
        self.assertEqual(body['error']['code'], 'AI_GATEWAY_NOT_CONFIGURED')

    def test_method_guard_rejects_non_post(self):
        route = load_route()
        self.assertEqual(route.ALLOWED_METHOD, 'POST')

    def test_framing_length_matrix_rejects_before_read(self):
        from cloud_gateway import MAX_WIRE_BYTES
        route = load_route()
        body = wire()
        valid = len(body)
        cases = {
            None: None,
            '': None,
            '0': 0,
            '00': 0,
            f' {valid} ': valid,
            str(valid): valid,
            'abc': None,
            '12.5': None,
            '+12': None,
            '-1': None,
            '  -1  ': None,
            str(MAX_WIRE_BYTES): MAX_WIRE_BYTES,
            str(MAX_WIRE_BYTES + 1): None,
            '9999999999999999': None,
        }
        for declared, expected in cases.items():
            headers = {} if declared is None else {'Content-Length': declared}
            self.assertEqual(
                route._framing_length(headers), expected,
                msg=f'header={declared!r}',
            )


if __name__ == '__main__':
    unittest.main()
