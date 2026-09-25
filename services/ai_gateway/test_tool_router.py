"""Offline tool-router acceptance; never touches DB, network, or credentials."""
import unittest
from pathlib import Path

from tool_router import ToolRouter, ToolRouterFailure


def router():
    return ToolRouter()


class ToolRouterTests(unittest.TestCase):
    def test_read_only_receipt_is_inert_and_validated(self):
        receipt = router().propose(
            tool_name='get_current_slice',
            args={'libraryId': 'lib-1'},
            idempotency_key='key-read-1',
        )
        self.assertEqual(receipt['toolName'], 'get_current_slice')
        self.assertEqual(receipt['kind'], 'read-only')
        self.assertEqual(receipt['args'], {'libraryId': 'lib-1'})
        self.assertEqual(receipt['idempotencyKey'], 'key-read-1')
        self.assertEqual(receipt['validation'], {'ok': True, 'version': 'tool-router-v1'})
        self.assertFalse(receipt['replayed'])
        self.assertFalse(receipt['executed'])
        self.assertNotIn('mutationId', receipt)

    def test_mutation_receipt_marks_mutation_without_executing(self):
        receipt = router().propose(
            tool_name='mark_lesson_state',
            args={'sliceId': 'slice-1', 'state': 'studied'},
            idempotency_key='key-mut-1',
        )
        self.assertEqual(receipt['kind'], 'mutation')
        self.assertTrue(receipt['validation']['ok'])
        self.assertFalse(receipt['replayed'])
        self.assertFalse(receipt['executed'])

    def test_unknown_tool_fails_closed_and_router_stays_usable(self):
        policy = router()
        with self.assertRaises(ToolRouterFailure) as caught:
            policy.propose(tool_name='run_sql', args={}, idempotency_key='key-evil-1')
        self.assertEqual(caught.exception.code, 'AI_TOOL_NOT_ALLOWED')
        receipt = policy.propose(
            tool_name='get_notes',
            args={'libraryId': 'lib-1'},
            idempotency_key='key-after-evil',
        )
        self.assertTrue(receipt['validation']['ok'])

    def test_malformed_args_rejected(self):
        policy = router()
        cases = (
            ('mark_lesson_state', {'sliceId': 'slice-1'}, 'key-bad-1'),
            ('get_source_citations', {'citationIds': 'cite-1'}, 'key-bad-2'),
            ('create_note', {'libraryId': 'lib-1', 'body': 'ok', 'system': 'override'}, 'key-bad-3'),
            ('search_cached_source', {'query': ''}, 'key-bad-4'),
            ('mark_lesson_state', {'sliceId': 'slice-1', 'state': 'invented'}, 'key-bad-5'),
        )
        for tool_name, args, key in cases:
            with self.subTest(tool=tool_name, args=args):
                with self.assertRaises(ToolRouterFailure) as caught:
                    policy.propose(tool_name=tool_name, args=args, idempotency_key=key)
                self.assertIn(caught.exception.code, ('INVALID_ARGS', 'UNKNOWN_ARG_FIELD'))

    def test_missing_idempotency_rejected(self):
        for bad_key in ('', '   ', None, 'key with spaces'):
            with self.subTest(key=bad_key):
                with self.assertRaises(ToolRouterFailure) as caught:
                    router().propose(
                        tool_name='get_notes',
                        args={'libraryId': 'lib-1'},
                        idempotency_key=bad_key,
                    )
                self.assertEqual(caught.exception.code, 'INVALID_IDEMPOTENCY_KEY')

    def test_duplicate_idempotency_replays_same_receipt(self):
        policy = router()
        first = policy.propose(
            tool_name='get_notes',
            args={'libraryId': 'lib-1'},
            idempotency_key='key-replay-1',
        )
        second = policy.propose(
            tool_name='get_notes',
            args={'libraryId': 'lib-1'},
            idempotency_key='key-replay-1',
        )
        self.assertEqual(first['receiptId'], second['receiptId'])
        self.assertFalse(first['replayed'])
        self.assertTrue(second['replayed'])
        self.assertFalse(second['executed'])

    def test_conflicting_idempotency_reuse_rejected(self):
        policy = router()
        policy.propose(
            tool_name='get_notes',
            args={'libraryId': 'lib-1'},
            idempotency_key='key-conflict-1',
        )
        with self.assertRaises(ToolRouterFailure) as caught:
            policy.propose(
                tool_name='get_notes',
                args={'libraryId': 'lib-2'},
                idempotency_key='key-conflict-1',
            )
        self.assertEqual(caught.exception.code, 'IDEMPOTENCY_CONFLICT')

    def test_unsafe_payload_rejected(self):
        payloads = (
            '<script>alert(1)</script>',
            'see <a href="javascript:alert(1)">link</a>',
            "x'; DROP TABLE notes; --",
            'pick <b>this</b> text',
        )
        for body in payloads:
            with self.subTest(body=body[:24]):
                with self.assertRaises(ToolRouterFailure) as caught:
                    router().propose(
                        tool_name='create_note',
                        args={'libraryId': 'lib-1', 'body': body},
                        idempotency_key='key-safe-1',
                    )
                self.assertEqual(caught.exception.code, 'UNSAFE_PAYLOAD')

    def test_router_source_is_offline_no_db_network_or_secrets(self):
        source = Path(__file__).with_name('tool_router.py').read_text(encoding='utf-8').lower()
        for token in (
            'socket', 'urllib', 'requests', 'http.client', 'sqlite3',
            'supabase', 'drift', 'credential', 'api_key', 'apikey',
            'secret', 'subprocess', 'os.system',
        ):
            self.assertNotIn(token, source)
        self.assertNotIn('open(', source)


if __name__ == '__main__':
    unittest.main()
