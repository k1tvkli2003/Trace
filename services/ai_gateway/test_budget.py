"""Fail-closed, no-network checks for Trace's future server AI boundary."""
import threading
import unittest

from budget import BudgetedRun, GatewayFailure, HttpFailure, RunLimits


class BudgetedRunTests(unittest.TestCase):
    def test_policy_cannot_disable_guard_with_unbounded_limits(self):
        for attempts, size, tokens, seconds in [
            (3, 16, 8, 5), (2, 4_194_305, 8, 5),
            (2, 16, 4_097, 5), (2, 16, 8, 121),
        ]:
            with self.assertRaises(ValueError):
                RunLimits(attempts, size, tokens, seconds)

    def setUp(self):
        self.clock_value = 100.0
        self.run = BudgetedRun(RunLimits(max_attempts=2, max_input_bytes=16,
                                          max_output_tokens=8, max_elapsed_seconds=5),
                               clock=lambda: self.clock_value)
        self.calls = []

    def provider(self, payload, output_tokens, timeout):
        self.calls.append((payload, output_tokens, timeout))
        return b'{"ok":true}'

    def test_valid_request_bounds_provider_and_duplicate_replays_without_new_call(self):
        self.assertEqual(self.run.call(b'abc', 8, self.provider), b'{"ok":true}')
        self.assertEqual(self.run.call(b'abc', 8, self.provider), b'{"ok":true}')
        self.assertEqual(self.calls, [(b'abc', 8, 5)])

    def test_preflight_rejects_input_and_output_before_spend(self):
        for payload, tokens in [(b'x' * 17, 1), (b'x', 9), (b'', 1)]:
            with self.assertRaises(GatewayFailure) as caught:
                self.run.call(payload, tokens, self.provider)
            self.assertEqual(caught.exception.code, 'AI_BUDGET_EXCEEDED')
        self.assertEqual(self.calls, [])

    def test_429_can_retry_once_only_after_retry_after_and_then_stops(self):
        def rate_limited(*_):
            self.calls.append('429')
            raise HttpFailure(429, retry_after_seconds=2)
        with self.assertRaises(GatewayFailure) as caught:
            self.run.call(b'x', 1, rate_limited)
        self.assertEqual(caught.exception.code, 'AI_RATE_LIMITED')
        self.assertTrue(caught.exception.retryable)
        with self.assertRaises(GatewayFailure) as caught:
            self.run.call(b'x', 1, rate_limited)
        self.assertEqual(caught.exception.code, 'AI_RETRY_NOT_READY')
        self.assertEqual(self.calls, ['429'])
        self.clock_value = 102.0
        with self.assertRaises(GatewayFailure) as caught:
            self.run.call(b'x', 1, rate_limited)
        self.assertEqual(caught.exception.code, 'AI_RATE_LIMITED')
        self.assertFalse(caught.exception.retryable)
        with self.assertRaises(GatewayFailure):
            self.run.call(b'x', 1, rate_limited)
        self.assertEqual(self.calls, ['429', '429'])

    def test_validation_auth_and_unknown_outcome_do_not_retry(self):
        for failure, expected in [(HttpFailure(400), 'AI_BAD_REQUEST'),
                                  (HttpFailure(401), 'AI_UNAUTHORIZED'),
                                  (HttpFailure(403), 'AI_FORBIDDEN'),
                                  (TimeoutError(), 'AI_OUTCOME_UNKNOWN')]:
            run = BudgetedRun(RunLimits(max_attempts=2, max_input_bytes=16,
                           max_output_tokens=8, max_elapsed_seconds=5), clock=lambda: 100.)
            def broken(*_):
                raise failure
            with self.assertRaises(GatewayFailure) as caught:
                run.call(b'x', 1, broken)
            self.assertEqual(caught.exception.code, expected)
            self.assertFalse(caught.exception.retryable)
            with self.assertRaises(GatewayFailure):
                run.call(b'x', 1, self.provider)

    def test_oversize_result_and_expired_deadline_fail_closed(self):
        with self.assertRaises(GatewayFailure) as caught:
            self.run.call(b'x', 1, lambda *_: b'x' * 65)
        self.assertEqual(caught.exception.code, 'AI_OUTPUT_TOO_LARGE')
        self.clock_value = 106.
        expired = BudgetedRun(RunLimits(max_attempts=2, max_input_bytes=16,
                               max_output_tokens=8, max_elapsed_seconds=5),
                              clock=lambda: self.clock_value - 6)
        expired.clock = lambda: self.clock_value
        with self.assertRaises(GatewayFailure) as caught:
            expired.call(b'x', 1, self.provider)
        self.assertEqual(caught.exception.code, 'AI_DEADLINE_EXCEEDED')
        self.assertEqual(self.calls, [])

    def test_reentrant_call_cannot_submit_same_job_twice(self):
        inner_codes = []
        def provider(payload, tokens, timeout):
            self.calls.append('outer')
            try:
                self.run.call(payload, tokens, self.provider)
            except GatewayFailure as error:
                inner_codes.append(error.code)
            return b'ok'
        self.assertEqual(self.run.call(b'x', 2, provider), b'ok')
        self.assertEqual(inner_codes, ['AI_RUN_IN_FLIGHT'])
        self.assertEqual(self.calls, ['outer'])
        self.assertEqual(self.run.attempts, 1)

    def test_concurrent_call_cannot_submit_same_job_twice(self):
        started = threading.Event()
        release = threading.Event()
        outcomes = []
        def slow_provider(*_):
            self.calls.append('submission')
            started.set()
            release.wait(timeout=1)
            return b'ok'
        def first():
            outcomes.append(self.run.call(b'x', 2, slow_provider))
        thread = threading.Thread(target=first)
        thread.start()
        self.assertTrue(started.wait(timeout=1))
        try:
            with self.assertRaises(GatewayFailure) as caught:
                self.run.call(b'x', 2, slow_provider)
            self.assertEqual(caught.exception.code, 'AI_RUN_IN_FLIGHT')
        finally:
            release.set()
            thread.join(timeout=1)
        self.assertFalse(thread.is_alive())
        self.assertEqual(outcomes, [b'ok'])
        self.assertEqual(self.calls, ['submission'])

    def test_changed_payload_cannot_reuse_successful_run(self):
        self.run.call(b'abc', 2, self.provider)
        with self.assertRaises(GatewayFailure) as caught:
            self.run.call(b'xyz', 2, self.provider)
        self.assertEqual(caught.exception.code, 'AI_RUN_CONFLICT')
        self.assertEqual(len(self.calls), 1)


if __name__ == '__main__':
    unittest.main()
