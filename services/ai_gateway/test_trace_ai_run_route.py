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


if __name__ == '__main__':
    unittest.main()
