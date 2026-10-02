"""RED-2: durable Supabase receipt boundary. No implementation yet.

Server receipt write must be owned by Supabase (trace_ai_receipts),
not RAM. Service-role isolated server-only, owner-scoped RLS.
No network, secret, or provider call here: DB client is injected.
"""
import unittest

from supabase_backend import (
    RECEIPT_TABLE,
    SupabaseReceiptStore,
    to_receipt_row,
)


COMPLETED = {
    'requestId': 'a' * 32,
    'status': 'completed',
    'operation': 'op-1',
    'capability': 'page_vision_extract',
    'model': 'user-route',
    'reasoning_effort': 'high',
    'usage': {'input_tokens': 10, 'output_tokens': 20},
    'elapsed_seconds': 1.0,
    'provider_request_id': 'req_123',
}


class FakeTable:
    def __init__(self):
        self.rows = {}
        self.inserts = 0

    def lookup(self, owner, key):
        return self.rows.get((owner, key))

    def insert(self, row):
        self.inserts += 1
        slot = (row['owner'], row['idempotency_key'])
        if slot in self.rows:
            raise ConflictError(dict(self.rows[slot]))
        self.rows[slot] = dict(row)
        return dict(row)


class ConflictError(Exception):
    def __init__(self, existing):
        super().__init__('conflict')
        self.existing = existing


class ReceiptBackendTests(unittest.TestCase):
    def make(self):
        table = FakeTable()
        store = SupabaseReceiptStore(
            insert=table.insert,
            lookup=table.lookup,
            conflict_error=ConflictError,
        )
        return store, table

    def test_table_name_pins_receipts(self):
        self.assertEqual(RECEIPT_TABLE, 'trace_ai_receipts')

    def test_row_carries_safe_fields_only(self):
        row = to_receipt_row(
            owner='owner-1',
            idempotency_key='key-1',
            receipt=dict(COMPLETED),
            source_hash='a' * 64,
            pixel_hash='b' * 64,
        )
        self.assertEqual(row['owner'], 'owner-1')
        self.assertEqual(row['idempotency_key'], 'key-1')
        self.assertEqual(row['status'], 'completed')
        self.assertEqual(row['request_id'], 'a' * 32)
        banned_keys = {'page_png', 'prompt', 'secret', 'service_role',
                       'token', 'service_role_key', 'api_key'}
        self.assertFalse(banned_keys & set(row))

    def test_write_then_replay_returns_same_request(self):
        store, table = self.make()
        first = store.save_completed(
            owner='owner-1', idempotency_key='key-1',
            receipt=dict(COMPLETED),
            source_hash='a' * 64, pixel_hash='b' * 64,
        )
        second = store.save_completed(
            owner='owner-1', idempotency_key='key-1',
            receipt=dict(COMPLETED),
            source_hash='a' * 64, pixel_hash='b' * 64,
        )
        self.assertEqual(first['request_id'], second['request_id'])
        self.assertEqual(table.inserts, 2)  # second insert conflicts, replay served

    def test_conflicting_reuse_fails_closed(self):
        from on_demand_run import OnDemandFailure
        store, _ = self.make()
        store.save_completed(
            owner='owner-1', idempotency_key='key-1',
            receipt=dict(COMPLETED),
            source_hash='a' * 64, pixel_hash='b' * 64,
        )
        altered = dict(COMPLETED)
        altered['operation'] = 'op-2'
        with self.assertRaises(OnDemandFailure) as caught:
            store.save_completed(
                owner='owner-1', idempotency_key='key-1',
                receipt=altered,
                source_hash='a' * 64, pixel_hash='b' * 64,
            )
        self.assertEqual(caught.exception.code, 'AI_RUN_CONFLICT')

    def test_owner_isolation_same_key(self):
        store, _ = self.make()
        first = store.save_completed(
            owner='owner-a', idempotency_key='key-1',
            receipt=dict(COMPLETED),
            source_hash='a' * 64, pixel_hash='b' * 64,
        )
        second_receipt = dict(COMPLETED)
        second = store.save_completed(
            owner='owner-b', idempotency_key='key-1',
            receipt=second_receipt,
            source_hash='a' * 64, pixel_hash='b' * 64,
        )
        self.assertEqual(first['request_id'], 'a' * 32)
        self.assertEqual(second['request_id'], 'a' * 32)
        self.assertEqual(first['owner'], 'owner-a')
        self.assertEqual(second['owner'], 'owner-b')

    def test_failed_receipt_persists_code_only(self):
        store, _ = self.make()
        row = store.save_failed(
            owner='owner-1', idempotency_key='key-9',
            operation='op-9', error_code='AI_INCOMPLETE_RESPONSE',
            source_hash='a' * 64, pixel_hash='b' * 64,
        )
        self.assertEqual(row['status'], 'failed')
        self.assertEqual(row['error_code'], 'AI_INCOMPLETE_RESPONSE')
        banned_keys = {'page_png', 'prompt', 'secret', 'service_role',
                       'token', 'service_role_key', 'api_key'}
        self.assertFalse(banned_keys & set(row))


if __name__ == '__main__':
    unittest.main()
