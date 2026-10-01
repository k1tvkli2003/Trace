"""RED for the typed server-side page Vision adapter.

No network, provider, fixture PDF, or page raster enters this test.
A minimal inline PNG stands in for rendered raster bytes.
"""
import base64
import hashlib
import json
import threading
import unittest

from budget import HttpFailure
from page_vision import VisionAdapter, VisionFailure


# 1x1 PNG; sha bound dynamically so image/mismatch paths stay honest.
PNG = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
    'hKmMIQAAAABJRU5ErkJggg==')
PIXEL = hashlib.sha256(PNG).hexdigest()
SOURCE = 'a' * 64


def valid_doc():
    return {
        'schemaVersion': 'page-extract-v1',
        'sourceHash': SOURCE,
        'pixelHash': PIXEL,
        'renderProfile': 'test-v1',
        'pageRef': 'page-1',
        'extractionVersion': 'page-vision-extract-v1',
        'coverage': 'complete',
        'blocks': [
            {'id': 'b1', 'order': 0, 'kind': 'heading',
             'text': 'A', 'bbox': {'x': 0.1, 'y': 0.05, 'w': 0.4, 'h': 0.04},
             'confidence': 0.92, 'uncertain': False},
            {'id': 'b2', 'order': 1, 'kind': 'paragraph',
             'text': 'B.', 'bbox': {'x': 0.1, 'y': 0.12, 'w': 0.7, 'h': 0.1},
             'confidence': 0.8, 'uncertain': False},
        ],
        'figures': [],
    }


def scope():
    return {'page_ref': 'page-1', 'source_hash': SOURCE,
            'pixel_hash': PIXEL, 'render_profile': 'test-v1'}


def request(**overrides):
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
    }
    body.update(overrides)
    return body


def completed_transport(calls, doc=None, usage=None, elapsed=1.0):
    def transport(*, request_id, route, envelope, image_png,
                  max_output_tokens, timeout_seconds):
        calls.append((request_id, route, envelope, image_png,
                      max_output_tokens, timeout_seconds))
        assert route.model == 'oc/muse-spark-1.3-contributor-free'
        assert route.endpoint == 'http://127.0.0.1:20128/v1/responses'
        assert image_png == PNG
        assert envelope['outputSchema'] == 'page-extract-v1'
        return {'status': 'completed', 'text': json.dumps(doc or valid_doc()),
                'usage': dict(usage or {'input_tokens': 10, 'output_tokens': 20}),
                'elapsed_seconds': elapsed,
                'provider_request_id': 'req_123'}
    return transport


class PageVisionAdapterTests(unittest.TestCase):
    def test_rejects_page_outside_authorized_scope_before_spend(self):
        def transport(**_kwargs):
            raise AssertionError('transport must not run before scope')

        adapter = VisionAdapter(transport=transport,
                                authorized_pages={'op-1': scope()})
        for bad in (request(page_ref='page-2'), request(source_hash='c' * 64),
                    request(pixel_hash='d' * 64),
                    request(render_profile='other')):
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(bad)
            self.assertEqual(caught.exception.code, 'AI_PAGE_NOT_AUTHORIZED')

    def test_rejects_malformed_request_before_spend(self):
        def transport(**_kwargs):
            raise AssertionError('transport must not run for bad shape')

        adapter = VisionAdapter(transport=transport,
                                authorized_pages={'op-1': scope()})
        bad = request()
        del bad['page_png']
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(bad)
        self.assertEqual(caught.exception.code, 'AI_VISION_REQUEST_INVALID')
        extra = request(extra_field=1)
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(extra)
        self.assertEqual(caught.exception.code, 'AI_VISION_REQUEST_INVALID')
        for override in ({'capability': 'teacher_fa'},
                         {'reasoning_effort': 'low'},
                         {'max_output_tokens': 0},
                         {'max_output_tokens': 20000},
                         {'max_elapsed_seconds': 0},
                         {'max_elapsed_seconds': 400}):
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(request(**override))
            self.assertEqual(caught.exception.code, 'AI_VISION_REQUEST_INVALID')

    def test_rejects_bad_image_and_hash_mismatch_before_spend(self):
        def transport(**_kwargs):
            raise AssertionError('transport must not run for bad image')

        adapter = VisionAdapter(transport=transport,
                                authorized_pages={'op-1': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request(page_png=b'not-a-png'))
        self.assertEqual(caught.exception.code, 'AI_PAGE_IMAGE_INVALID')
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request(pixel_hash='e' * 64))
        self.assertEqual(caught.exception.code, 'AI_PAGE_NOT_AUTHORIZED')

    def test_happy_path_returns_typed_result_and_replays_duplicate(self):
        calls = []
        adapter = VisionAdapter(
            transport=completed_transport(calls),
            authorized_pages={'op-1': scope()})
        first = adapter.extract(request())
        self.assertEqual(first.operation, 'op-1')
        self.assertEqual(first.model,
                         'oc/muse-spark-1.3-contributor-free')
        self.assertEqual(first.reasoning_effort, 'high')
        self.assertEqual(first.extract, valid_doc())
        self.assertEqual(first.usage, {'input_tokens': 10,
                                       'output_tokens': 20})
        self.assertEqual(len(first.request_id), 32)
        second = adapter.extract(request())
        self.assertEqual(second.request_id, first.request_id)
        self.assertEqual(len(calls), 1)

    def test_conflicting_reuse_of_operation_fails_closed(self):
        calls = []
        adapter = VisionAdapter(
            transport=completed_transport(calls),
            authorized_pages={'op-1': scope()})
        adapter.extract(request())
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request(reasoning_effort='xhigh'))
        self.assertEqual(caught.exception.code, 'AI_RUN_CONFLICT')

    def test_same_operation_in_flight_never_submits_twice(self):
        started, release = threading.Event(), threading.Event()
        submissions, outcomes = [], []

        def blocking(**_kwargs):
            submissions.append(1)
            started.set()
            if not release.wait(timeout=3):
                raise TimeoutError()
            return {'status': 'completed', 'text': json.dumps(valid_doc()),
                    'usage': {}, 'elapsed_seconds': 1,
                    'provider_request_id': None}

        adapter = VisionAdapter(transport=blocking,
                                authorized_pages={'op-1': scope()})

        def worker():
            try:
                outcomes.append(adapter.extract(request()))
            except VisionFailure as error:
                outcomes.append(error.code)

        thread = threading.Thread(target=worker)
        thread.start()
        try:
            self.assertTrue(started.wait(timeout=2))
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(request())
            self.assertEqual(caught.exception.code, 'AI_RUN_IN_FLIGHT')
            self.assertEqual(len(submissions), 1)
        finally:
            release.set()
            thread.join(timeout=3)
        self.assertFalse(thread.is_alive())
        self.assertEqual(len(outcomes), 1)
        self.assertEqual(outcomes[0].extract, valid_doc())
        self.assertEqual(adapter.extract(request()), outcomes[0])
        self.assertEqual(len(submissions), 1)

    def test_incomplete_stream_never_becomes_source(self):
        def transport(**_kwargs):
            return {'status': 'incomplete', 'text': '',
                    'usage': {}, 'elapsed_seconds': 1.0,
                    'provider_request_id': None}

        adapter = VisionAdapter(transport=transport,
                                authorized_pages={'op-1': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request())
        self.assertEqual(caught.exception.code, 'AI_INCOMPLETE_RESPONSE')

    def test_malformed_and_off_scope_text_rejected(self):
        calls = []

        def transport(**_kwargs):
            calls.append(1)
            return {'status': 'completed', 'text': '{not json',
                    'usage': {'input_tokens': 1}, 'elapsed_seconds': 1.0,
                    'provider_request_id': None}

        adapter = VisionAdapter(transport=transport,
                                authorized_pages={'op-1': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request())
        self.assertEqual(caught.exception.code, 'AI_SCHEMA_REJECTED')

        tampered = valid_doc()
        tampered['sourceHash'] = 'f' * 64
        adapter2 = VisionAdapter(
            transport=completed_transport([], doc=tampered),
            authorized_pages={'op-1': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter2.extract(request())
        self.assertEqual(caught.exception.code, 'AI_SCHEMA_REJECTED')

    def test_http_and_timeout_map_to_stable_codes(self):
        def rate_limited(**_kwargs):
            raise HttpFailure(429, retry_after_seconds=0)

        adapter = VisionAdapter(transport=rate_limited,
                                authorized_pages={'op-1': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request())
        self.assertEqual(caught.exception.code, 'AI_RATE_LIMITED')

        def unauthorized(**_kwargs):
            raise HttpFailure(401)

        adapter = VisionAdapter(transport=unauthorized,
                                authorized_pages={'op-2': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request(operation='op-2'))
        self.assertEqual(caught.exception.code, 'AI_UNAUTHORIZED')

        def slow(**_kwargs):
            raise TimeoutError()

        adapter = VisionAdapter(transport=slow,
                                authorized_pages={'op-3': scope()})
        with self.assertRaises(VisionFailure) as caught:
            adapter.extract(request(operation='op-3'))
        self.assertEqual(caught.exception.code, 'AI_OUTCOME_UNKNOWN')

    def test_replay_uses_value_copy_not_shared_reference(self):
        calls = []
        adapter = VisionAdapter(transport=completed_transport(calls),
                                authorized_pages={'op-1': scope()})
        first = adapter.extract(request())
        first.extract['sourceHash'] = 'f' * 64
        first.usage['input_tokens'] = 999
        replay = adapter.extract(request())
        self.assertEqual(replay.extract, valid_doc())
        self.assertEqual(replay.usage['input_tokens'], 10)
        self.assertEqual(len(calls), 1)

    def test_failed_operation_replays_same_safe_code(self):
        calls = []
        def failing(**_kwargs):
            calls.append(1)
            raise HttpFailure(429)
        adapter = VisionAdapter(transport=failing, authorized_pages={'op-1': scope()})
        for _ in range(2):
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(request())
            self.assertEqual(caught.exception.code, 'AI_RATE_LIMITED')
        self.assertEqual(len(calls), 1)

    def test_deeply_nested_json_maps_to_schema_rejected_and_replays(self):
        calls = []
        nested = '[' * 1100 + ']' * 1100

        def transport(**_kwargs):
            calls.append(1)
            return {'status': 'completed', 'text': nested,
                    'usage': {'input_tokens': 1}, 'elapsed_seconds': 1.0,
                    'provider_request_id': None}

        adapter = VisionAdapter(transport=transport,
                                authorized_pages={'op-1': scope()})
        for _ in range(2):
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(request())
            self.assertEqual(caught.exception.code, 'AI_SCHEMA_REJECTED')
        self.assertEqual(len(calls), 1)

    def test_transport_receives_complete_role_separated_prompt(self):
        calls = []
        adapter = VisionAdapter(transport=completed_transport(calls),
                                authorized_pages={'op-1': scope()})
        adapter.extract(request())
        envelope = calls[0][2]
        self.assertEqual([m['role'] for m in envelope['messages']], ['system', 'user'])
        self.assertIn('entire supplied raster page', envelope['messages'][0]['content'])
        self.assertEqual(envelope['messages'][1]['content']['task']['sourceHash'], SOURCE)

    def test_in_flight_transient_never_cached_as_terminal(self):
        started, release = threading.Event(), threading.Event()
        submissions = []

        def blocking(**_kwargs):
            submissions.append(1)
            started.set()
            if not release.wait(timeout=3):
                raise TimeoutError()
            return {'status': 'completed', 'text': json.dumps(valid_doc()),
                    'usage': {}, 'elapsed_seconds': 1,
                    'provider_request_id': None}

        adapter = VisionAdapter(transport=blocking,
                                authorized_pages={'op-1': scope()})
        outcomes = []

        def worker():
            try:
                outcomes.append(adapter.extract(request()))
            except VisionFailure as error:
                outcomes.append(error.code)

        thread = threading.Thread(target=worker)
        thread.start()
        try:
            self.assertTrue(started.wait(timeout=2))
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(request())
            self.assertEqual(caught.exception.code, 'AI_RUN_IN_FLIGHT')
        finally:
            release.set()
            thread.join(timeout=3)
        self.assertFalse(thread.is_alive())
        self.assertEqual(outcomes[0].extract, valid_doc())
        # Transient IN_FLIGHT must not linger: the post-completion replay
        # succeeds on the same single submission.
        replay = adapter.extract(request())
        self.assertEqual(replay.extract, valid_doc())
        self.assertEqual(len(submissions), 1)

    def test_retry_not_ready_never_cached_as_terminal(self):
        inner = []
        adapter = VisionAdapter(
            transport=completed_transport(inner),
            authorized_pages={'op-1': scope()},
            clock=lambda: 1000.0)
        # Simulate a BudgetedRun that already hit its attempts ceiling and is
        # now inside the retry window: NOT_READY must surface without caching.
        import budget as budget_module
        real_call = budget_module.BudgetedRun.call

        def not_ready(self, payload, max_output_tokens, provider):
            raise budget_module.GatewayFailure('AI_RETRY_NOT_READY')

        budget_module.BudgetedRun.call = not_ready
        try:
            with self.assertRaises(VisionFailure) as caught:
                adapter.extract(request())
        finally:
            budget_module.BudgetedRun.call = real_call
        self.assertEqual(caught.exception.code, 'AI_RETRY_NOT_READY')
        # No terminal failure cached: the real path still submits exactly once.
        result = adapter.extract(request())
        self.assertEqual(result.extract, valid_doc())
        self.assertEqual(len(inner), 1)

    def test_bounded_map_evicts_oldest_completed_for_new_operation(self):
        import page_vision as vision_module
        old_bound = vision_module._MAX_OPERATIONS
        vision_module._MAX_OPERATIONS = 2
        try:
            calls = []
            adapter = VisionAdapter(
                transport=completed_transport(calls),
                authorized_pages={'op-a': scope(), 'op-b': scope(),
                                  'op-c': scope()})
            first_a = adapter.extract(request(operation='op-a'))
            first_b = adapter.extract(request(operation='op-b'))
            self.assertEqual(len(calls), 2)
            third = adapter.extract(request(operation='op-c'))
            self.assertEqual(third.extract, valid_doc())
            self.assertEqual(len(calls), 3)
            # op-b retained: exact replay, no resubmit.
            replay_b = adapter.extract(request(operation='op-b'))
            self.assertEqual(replay_b.request_id, first_b.request_id)
            self.assertEqual(len(calls), 3)
            # Evicted entry resubmits with fresh request_id (RAM-only retention
            # loss documented in brief: FIFO terminal-first, no tombstone).
            replay_a = adapter.extract(request(operation='op-a'))
            self.assertEqual(replay_a.extract, valid_doc())
            self.assertNotEqual(replay_a.request_id, first_a.request_id)
            self.assertEqual(len(calls), 4)
        finally:
            vision_module._MAX_OPERATIONS = old_bound

    def test_in_flight_entry_never_evicted_at_bound(self):
        import page_vision as vision_module
        old_bound = vision_module._MAX_OPERATIONS
        vision_module._MAX_OPERATIONS = 1
        started, release = threading.Event(), threading.Event()
        submissions, outcomes = [], []
        try:
            def transport(**kwargs):
                submissions.append(kwargs['request_id'])
                if len(submissions) == 1:
                    started.set()
                    if not release.wait(timeout=3):
                        raise TimeoutError()
                return {'status': 'completed', 'text': json.dumps(valid_doc()),
                        'usage': {}, 'elapsed_seconds': 1,
                        'provider_request_id': None}

            adapter = VisionAdapter(
                transport=transport,
                authorized_pages={'op-a': scope(), 'op-c': scope()})

            def worker():
                try:
                    outcomes.append(adapter.extract(request(operation='op-a')))
                except VisionFailure as error:
                    outcomes.append(error.code)

            thread = threading.Thread(target=worker)
            thread.start()
            try:
                self.assertTrue(started.wait(timeout=2))
                with self.assertRaises(VisionFailure) as caught:
                    adapter.extract(request(operation='op-c'))
                self.assertEqual(caught.exception.code,
                                 'AI_OPERATION_LIMIT_EXCEEDED')
                with self.assertRaises(VisionFailure) as caught:
                    adapter.extract(request(operation='op-a'))
                self.assertEqual(caught.exception.code, 'AI_RUN_IN_FLIGHT')
                self.assertEqual(len(submissions), 1)
            finally:
                release.set()
                thread.join(timeout=3)
            self.assertFalse(thread.is_alive())
            self.assertEqual(outcomes[0].extract, valid_doc())
            replay_a = adapter.extract(request(operation='op-a'))
            self.assertEqual(replay_a.request_id, outcomes[0].request_id)
            self.assertEqual(len(submissions), 1)
            # Once terminal, entry may be evicted for a new operation.
            adapter.extract(request(operation='op-c'))
            self.assertEqual(len(submissions), 2)
            self.assertNotEqual(submissions[0], submissions[1])
        finally:
            release.set()
            vision_module._MAX_OPERATIONS = old_bound


if __name__ == '__main__':
    unittest.main()
