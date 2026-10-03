"""Focused tests for server-only cloud_wiring. No network, no secret.

Missing env fails closed; malformed auth never reaches the network; the
wiring shape matches the pure ``handle_request`` seam.
"""
import io
import os
import unittest
from unittest.mock import patch

from cloud_wiring import (
    ENV_ANON,
    ENV_SERVICE,
    ENV_UPSTREAM,
    ENV_URL,
    ReceiptConflict,
    build_run_vision,
    build_wiring,
    receipt_insert,
    receipt_lookup,
    verify_owner,
)
from on_demand_run import OnDemandFailure


class FakeResp:
    def __init__(self, status=200, payload=b'{}'):
        self.status = status
        self._payload = payload

    def read(self):
        return self._payload

    def __enter__(self):
        return self

    def __exit__(self, * _args):
        return False


def clear_env(*names):
    return patch.dict(os.environ, {name: '' for name in names}, clear=False)


class CloudWiringTests(unittest.TestCase):
    def test_missing_supabase_env_fails_configured(self):
        with clear_env(ENV_URL, ENV_ANON):
            with self.assertRaises(OnDemandFailure) as caught:
                verify_owner('Bearer anything')
            self.assertEqual(caught.exception.code,
                             'AI_GATEWAY_NOT_CONFIGURED')

    def test_malformed_authorization_rejected_before_network(self):
        with patch.dict(os.environ, {ENV_URL: 'https://x.example',
                                     ENV_ANON: 'anon-example'},
                        clear=False):
            with patch('urllib.request.urlopen') as opened:
                for bad in (None, '', 'nope', 'Bearer '):
                    with self.assertRaises(OnDemandFailure) as caught:
                        verify_owner(bad)
                    self.assertEqual(caught.exception.code, 'AI_UNAUTHORIZED')
                opened.assert_not_called()

    def test_verify_owner_maps_supabase_id(self):
        with patch.dict(os.environ, {ENV_URL: 'https://x.example',
                                     ENV_ANON: 'anon-example'},
                        clear=False):
            with patch('urllib.request.urlopen',
                       return_value=FakeResp(200, b'{"id": "owner-1"}')):
                self.assertEqual(verify_owner('Bearer good'), 'owner-1')

    def test_verify_owner_rejects_missing_id(self):
        with patch.dict(os.environ, {ENV_URL: 'https://x.example',
                                     ENV_ANON: 'anon-example'},
                        clear=False):
            with patch('urllib.request.urlopen',
                       return_value=FakeResp(200, b'{}')):
                with self.assertRaises(OnDemandFailure) as caught:
                    verify_owner('Bearer good')
                self.assertEqual(caught.exception.code, 'AI_UNAUTHORIZED')

    def test_run_vision_missing_key_fails_configured(self):
        with clear_env(ENV_UPSTREAM):
            run = build_run_vision()
            with self.assertRaises(OnDemandFailure) as caught:
                run({})
            self.assertEqual(caught.exception.code,
                             'AI_GATEWAY_NOT_CONFIGURED')

    def test_receipt_insert_missing_env_fails_configured(self):
        with clear_env(ENV_URL, ENV_SERVICE):
            with self.assertRaises(OnDemandFailure) as caught:
                receipt_insert({'owner': 'o', 'idempotency_key': 'k'})
            self.assertEqual(caught.exception.code,
                             'AI_GATEWAY_NOT_CONFIGURED')

    def test_receipt_lookup_returns_none_on_network_error(self):
        with patch.dict(os.environ, {ENV_URL: 'https://x.example',
                                     ENV_SERVICE: 'svc-example'},
                        clear=False):
            with patch('urllib.request.urlopen',
                       side_effect=OSError('down')):
                self.assertIsNone(receipt_lookup('o', 'k'))

    def test_conflict_carries_existing(self):
        existing = {'owner': 'o'}
        self.assertEqual(ReceiptConflict(existing).existing, existing)

    def test_build_wiring_shape(self):
        wiring = build_wiring()
        for name in ('verify_owner', 'run_vision', 'receipt_insert',
                     'receipt_lookup'):
            self.assertTrue(callable(wiring[name]), name)
        self.assertIs(wiring['receipt_conflict'], ReceiptConflict)


if __name__ == '__main__':
    unittest.main()
