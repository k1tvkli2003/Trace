"""POST /api/trace-ai-run. Thin Vercel adapter, no logic of its own.

Delegates to existing validation/budget logic:
cloud_gateway.parse_wire_body + OnDemandGateway + SupabaseReceiptStore.
Fail-closed: bad auth/input/config never spends upstream.
No secret in response, log, or receipt. Missing wiring -> 503.
"""
from __future__ import annotations

import os
import sys
from http.server import BaseHTTPRequestHandler

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'services', 'ai_gateway'))

from cloud_gateway import MAX_WIRE_BYTES, parse_wire_body
from on_demand_run import OnDemandFailure, OnDemandGateway
from supabase_backend import SupabaseReceiptStore

ALLOWED_METHOD = 'POST'


class _ReceiptConflict(Exception):
    def __init__(self, existing=None):
        super().__init__('receipt conflict')
        self.existing = existing


def _status_for(code: str) -> int:
    if code == 'AI_UNAUTHORIZED':
        return 401
    if code in ('AI_VISION_REQUEST_INVALID', 'AI_PAGE_IMAGE_INVALID',
                'AI_PAGE_IMAGE_MISMATCH', 'AI_REQUEST_TOO_LARGE'):
        return 400
    if code == 'AI_RUN_CONFLICT':
        return 409
    if code == 'AI_RUN_IN_FLIGHT':
        return 429
    if code == 'AI_RATE_LIMITED':
        return 429
    if code == 'AI_GATEWAY_NOT_CONFIGURED':
        return 503
    return 502


def _safe_message(code: str) -> str:
    return {
        'AI_UNAUTHORIZED': 'Unauthorized.',
        'AI_VISION_REQUEST_INVALID': 'Invalid request.',
        'AI_PAGE_IMAGE_INVALID': 'Invalid request image.',
        'AI_PAGE_IMAGE_MISMATCH': 'Image does not match declared hash.',
        'AI_REQUEST_TOO_LARGE': 'Request too large.',
        'AI_RUN_CONFLICT': 'Idempotency key already used with different payload.',
        'AI_RUN_IN_FLIGHT': 'Run already in flight. Retry later.',
        'AI_RATE_LIMITED': 'Provider is rate limited. Retry later.',
        'AI_GATEWAY_NOT_CONFIGURED': 'AI gateway not configured.',
    }.get(code, 'Upstream vision run failed.')


def _error(code: str, request_id=None) -> dict:
    return {'error': {'code': code, 'message': _safe_message(code),
                      'requestId': request_id}}


_NO_FAILED_STORE = frozenset({
    'AI_UNAUTHORIZED', 'AI_VISION_REQUEST_INVALID', 'AI_PAGE_IMAGE_INVALID',
    'AI_PAGE_IMAGE_MISMATCH', 'AI_REQUEST_TOO_LARGE', 'AI_RUN_CONFLICT',
    'AI_RUN_IN_FLIGHT', 'AI_GATEWAY_NOT_CONFIGURED',
    'AI_RATE_LIMITED', 'AI_PROVIDER_UNAVAILABLE', 'AI_PROVIDER_FAILURE',
    'AI_RETRY_NOT_READY',
})


def handle_request(raw: bytes, authorization, *, verify_owner=None,
                   run_vision=None, receipt_insert=None,
                   receipt_lookup=None, receipt_conflict=None):
    """Pure handler. Returns (status, body). No secrets in body."""
    if (not callable(verify_owner) or not callable(run_vision)
            or not callable(receipt_insert)):
        return 503, _error('AI_GATEWAY_NOT_CONFIGURED')
    lookup = receipt_lookup if callable(receipt_lookup) else lambda o, k: None
    conflict = receipt_conflict or _ReceiptConflict
    try:
        body = parse_wire_body(raw)
    except OnDemandFailure as error:
        return _status_for(error.code), _error(error.code)
    gateway = OnDemandGateway(verify_owner=verify_owner, run_vision=run_vision)
    try:
        receipt = gateway.handle(body, authorization=authorization)
    except OnDemandFailure as error:
        try:
            owner = verify_owner(authorization)
        except Exception:
            owner = None
        if (isinstance(owner, str) and owner
                and error.code not in _NO_FAILED_STORE):
            try:
                store = SupabaseReceiptStore(
                    insert=receipt_insert, lookup=lookup,
                    conflict_error=conflict)
                store.save_failed(
                    owner=owner,
                    idempotency_key=body.get('idempotency_key', ''),
                    operation=body.get('operation', ''),
                    error_code=error.code,
                    source_hash=body.get('source_hash', ''),
                    pixel_hash=body.get('pixel_hash', ''))
            except Exception:
                pass
        return _status_for(error.code), _error(error.code)
    store = SupabaseReceiptStore(
        insert=receipt_insert, lookup=lookup, conflict_error=conflict)
    try:
        store.save_completed(
            owner=verify_owner(authorization),
            idempotency_key=body['idempotency_key'],
            receipt=receipt,
            source_hash=body['source_hash'],
            pixel_hash=body['pixel_hash'])
    except OnDemandFailure as error:
        return _status_for(error.code), _error(
            error.code, receipt.get('requestId'))
    except Exception:
        return 502, _error('AI_PROVIDER_FAILURE', receipt.get('requestId'))
    return 200, {'receipt': receipt}


def _framing_length(headers) -> int | None:
    """Decimal Content-Length within the wire cap, else None.

    No provider, auth, or receipt side effect. Rejects absent/garbled/
    negative/over-cap values before the body is read.
    """
    declared = headers.get('Content-Length') if headers else None
    if declared is None:
        return None
    text = str(declared).strip()
    if not text.isascii() or not text.isdigit():
        return None
    try:
        length = int(text, 10)
    except (TypeError, ValueError):
        return None
    if 0 <= length <= MAX_WIRE_BYTES:
        return length
    return None


class handler(BaseHTTPRequestHandler):  # Vercel Python runtime: api/trace-ai-run.py -> POST /api/trace-ai-run
    """Vercel entrypoint. Wiring only; all checks live in handle_request."""

    def do_POST(self):  # pragma: no cover - runtime entrypoint
        import json
        length = _framing_length(self.headers)
        if length is None:
            payload = json.dumps(_error('AI_VISION_REQUEST_INVALID')).encode()
            self.send_response(400)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)
            return
        raw = self.rfile.read(length)
        try:
            from cloud_wiring import build_wiring
            wiring = build_wiring()
        except Exception:
            wiring = {}
        status, body = handle_request(
            raw, self.headers.get('Authorization'), **wiring)
        payload = json.dumps(body).encode()
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

    def do_GET(self):  # pragma: no cover - runtime entrypoint
        self.send_response(405)
        self.end_headers()
