"""Server-side durable receipt boundary. No network, secret, or provider here.

Supabase owns the receipt write (table trace_ai_receipts), not RAM.
DB access is injected: caller supplies insert/lookup over the
service-role client. Owner-scoped, append-only, fail-closed.
"""
from __future__ import annotations

import math
from collections.abc import Callable, Mapping
from typing import Any

from on_demand_run import OnDemandFailure

RECEIPT_TABLE = 'trace_ai_receipts'

_KEY_CHARS = frozenset(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.')
_USAGES = frozenset({'input_tokens', 'output_tokens', 'total_tokens'})
_EFFORTS = frozenset({'high', 'xhigh'})


def _sha(value: object) -> bool:
    return (isinstance(value, str) and len(value) == 64
            and all(c in '0123456789abcdef' for c in value))


def _check_owner(owner: object) -> str:
    if not isinstance(owner, str) or not owner or len(owner) > 256:
        raise OnDemandFailure('AI_UNAUTHORIZED')
    return owner


def _check_key(key: object) -> str:
    if (not isinstance(key, str) or not key or len(key) > 128
            or any(c not in _KEY_CHARS for c in key)):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    return key


def _usage(value: object) -> dict[str, int | float]:
    if not isinstance(value, Mapping):
        return {}
    return {k: n for k, n in value.items()
            if k in _USAGES and type(n) in (int, float)
            and math.isfinite(n) and n >= 0}


def _provider_id(value: object) -> str | None:
    if (isinstance(value, str) and 0 < len(value) <= 128
            and all(c.isascii() and (c.isalnum() or c in '_-.') for c in value)):
        return value
    return None


def _error_code(value: object) -> str:
    if (isinstance(value, str) and 1 <= len(value) <= 64
            and value.startswith('AI_')
            and all(c.isascii() and (c.isupper() or c.isdigit() or c == '_')
                    for c in value)):
        return value
    raise OnDemandFailure('AI_VISION_REQUEST_INVALID')


def to_receipt_row(*, owner: str, idempotency_key: str,
                   receipt: Mapping[str, Any],
                   source_hash: str, pixel_hash: str) -> dict[str, Any]:
    """Safe metadata row only: no prompt, image, secret, or raw response."""
    _check_owner(owner)
    _check_key(idempotency_key)
    if not _sha(source_hash) or not _sha(pixel_hash):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    if not isinstance(receipt, Mapping):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    request_id = receipt.get('requestId')
    if not (isinstance(request_id, str) and len(request_id) == 32
            and all(c in '0123456789abcdef' for c in request_id)):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    status = receipt.get('status')
    if status not in ('completed', 'failed'):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    operation = receipt.get('operation')
    capability = receipt.get('capability')
    if (not isinstance(operation, str) or not operation
            or len(operation) > 128
            or capability != 'page_vision_extract'):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    effort = receipt.get('reasoning_effort')
    if effort not in _EFFORTS:
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    elapsed = receipt.get('elapsed_seconds')
    if (type(elapsed) not in (int, float)
            or not math.isfinite(elapsed) or not 0 <= elapsed <= 600):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    model = receipt.get('model')
    if not isinstance(model, str) or not model or len(model) > 256:
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    error_code = receipt.get('error_code')
    row: dict[str, Any] = {
        'owner': owner,
        'idempotency_key': idempotency_key,
        'request_id': request_id,
        'status': status,
        'operation': operation,
        'capability': capability,
        'model': model,
        'reasoning_effort': effort,
        'usage': _usage(receipt.get('usage')),
        'elapsed_seconds': float(elapsed),
        'provider_request_id': _provider_id(receipt.get('provider_request_id')),
        'source_hash': source_hash,
        'pixel_hash': pixel_hash,
        'error_code': None if error_code is None else _error_code(error_code),
    }
    return row


def _same_payload(existing: Mapping[str, Any], new: Mapping[str, Any]) -> bool:
    keys = ('status', 'operation', 'capability', 'model',
            'reasoning_effort', 'source_hash', 'pixel_hash')
    return all(existing.get(k) == new.get(k) for k in keys)


class SupabaseReceiptStore:
    """Durable owner-scoped receipt writes over an injected DB client."""

    def __init__(self, *, insert: Callable[[dict], dict],
                 lookup: Callable[[str, str], dict | None],
                 conflict_error: type[BaseException]) -> None:
        if not callable(insert) or not callable(lookup):
            raise OnDemandFailure('AI_GATEWAY_NOT_CONFIGURED')
        self._insert = insert
        self._lookup = lookup
        self._conflict = conflict_error

    def save_completed(self, *, owner: str, idempotency_key: str,
                       receipt: Mapping[str, Any],
                       source_hash: str, pixel_hash: str) -> dict[str, Any]:
        row = to_receipt_row(
            owner=owner, idempotency_key=idempotency_key,
            receipt={**dict(receipt), 'status': 'completed',
                     'error_code': None},
            source_hash=source_hash, pixel_hash=pixel_hash)
        try:
            return self._insert(row)
        except self._conflict as error:
            existing = getattr(error, 'existing', None) or self._lookup(
                owner, idempotency_key)
            if isinstance(existing, Mapping) and _same_payload(existing, row):
                return dict(existing)
            raise OnDemandFailure('AI_RUN_CONFLICT') from None

    def save_failed(self, *, owner: str, idempotency_key: str,
                    operation: str, error_code: str,
                    source_hash: str, pixel_hash: str) -> dict[str, Any]:
        import uuid
        row = to_receipt_row(
            owner=owner, idempotency_key=idempotency_key,
            receipt={'requestId': uuid.uuid4().hex, 'status': 'failed',
                     'operation': operation,
                     'capability': 'page_vision_extract',
                     'model': 'none', 'reasoning_effort': 'high',
                     'usage': {}, 'elapsed_seconds': 0.0,
                     'provider_request_id': None,
                     'error_code': _error_code(error_code)},
            source_hash=source_hash, pixel_hash=pixel_hash)
        try:
            return self._insert(row)
        except self._conflict as error:
            existing = getattr(error, 'existing', None) or self._lookup(
                owner, idempotency_key)
            if isinstance(existing, Mapping) and _same_payload(existing, row):
                return dict(existing)
            raise OnDemandFailure('AI_RUN_CONFLICT') from None
