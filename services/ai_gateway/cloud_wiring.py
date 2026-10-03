"""Server-only cloud composition for POST /api/trace-ai-run. No logic of its own.

Builds the injected callables the pure ``handle_request`` seam needs, from
server env only:

- ``verify_owner``: Supabase Auth JWT -> owner UUID via ``GET /auth/v1/user``.
- ``run_vision``: one VisionAdapter call over the fixed 9Router route. The key
  comes from ``NINEROUTER_API_KEY`` inside the existing transport; this module
  adds no key handling, retry, or fallback.
- ``receipt_insert`` / ``receipt_lookup``: Supabase REST with the service-role
  key. Safe metadata rows only; never prompt, image, or raw response.

Missing env or bad auth fails closed with the existing stable codes. Nothing
here is importable from Flutter, logs, or receipts.
"""
from __future__ import annotations

import json
import os
import urllib.error
import urllib.request
from collections.abc import Mapping
from typing import Any
from urllib.parse import quote

from on_demand_run import OnDemandFailure

ENV_URL = 'TRACE_SUPABASE_URL'
ENV_ANON = 'TRACE_SUPABASE_ANON_KEY'
ENV_SERVICE = 'TRACE_SUPABASE_SERVICE_ROLE_KEY'
ENV_UPSTREAM = 'NINEROUTER_API_KEY'


class ReceiptConflict(Exception):
    def __init__(self, existing=None):
        super().__init__('receipt conflict')
        self.existing = existing


def _env(name: str) -> str | None:
    value = os.environ.get(name)
    if isinstance(value, str) and value.strip():
        return value
    return None


def supabase_url() -> str | None:
    base = _env(ENV_URL)
    if not base:
        return None
    return base.rstrip('/')


def verify_owner(authorization: object) -> str:
    """Supabase JWT -> owner UUID. Fail closed, never spends upstream."""
    base = supabase_url()
    anon = _env(ENV_ANON)
    if not base or not anon:
        raise OnDemandFailure('AI_GATEWAY_NOT_CONFIGURED')
    if (not isinstance(authorization, str)
            or not authorization.startswith('Bearer ')):
        raise OnDemandFailure('AI_UNAUTHORIZED')
    token = authorization[len('Bearer '):]
    if not token or len(token) > 8192:
        raise OnDemandFailure('AI_UNAUTHORIZED')
    req = urllib.request.Request(
        base + '/auth/v1/user',
        headers={'apikey': anon, 'Authorization': authorization},
        method='GET',
    )
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            if resp.status != 200:
                raise OnDemandFailure('AI_UNAUTHORIZED')
            data = json.loads(resp.read().decode('utf-8'))
    except OnDemandFailure:
        raise
    except Exception:
        raise OnDemandFailure('AI_UNAUTHORIZED') from None
    owner = data.get('id') if isinstance(data, Mapping) else None
    if not isinstance(owner, str) or not owner or len(owner) > 256:
        raise OnDemandFailure('AI_UNAUTHORIZED')
    return owner


def build_run_vision():
    """One VisionAdapter call over the fixed route. Fail closed without key."""

    def run_vision(adapter_request: dict[str, Any]) -> dict[str, Any]:
        from nine_router_transport import responses_transport
        from page_vision import VisionAdapter, VisionFailure

        if not _env(ENV_UPSTREAM):
            raise OnDemandFailure('AI_GATEWAY_NOT_CONFIGURED')
        # The trusted caller (OnDemandGateway.handle) already verified owner
        # and shape; no separate page registry exists in the frozen contract,
        # so the adapter scope is derived from this same authorized request.
        # VisionAdapter still re-checks hash binding before any spend.
        operation = adapter_request.get('operation', '')
        pages = {operation: {
            'page_ref': adapter_request.get('page_ref', ''),
            'source_hash': adapter_request.get('source_hash', ''),
            'pixel_hash': adapter_request.get('pixel_hash', ''),
            'render_profile': adapter_request.get('render_profile', ''),
        }}
        adapter = VisionAdapter(
            transport=responses_transport, authorized_pages=pages)
        try:
            result = adapter.extract(adapter_request)
        except VisionFailure as error:
            raise OnDemandFailure(error.code) from None
        return {
            'model': result.model,
            'reasoning_effort': result.reasoning_effort,
            'usage': dict(result.usage),
            'elapsed_seconds': result.elapsed_seconds,
            'provider_request_id': result.provider_request_id,
        }

    return run_vision


def _rest(path: str, *, method: str, body: Mapping[str, Any] | None = None,
           params: str = '') -> Any:
    base = supabase_url()
    key = _env(ENV_SERVICE)
    if not base or not key:
        raise OnDemandFailure('AI_GATEWAY_NOT_CONFIGURED')
    data = json.dumps(dict(body)).encode() if body is not None else None
    req = urllib.request.Request(
        base + path + params, data=data, method=method,
        headers={'apikey': key, 'Authorization': 'Bearer ' + key,
                 'Content-Type': 'application/json',
                 'Prefer': 'return=representation'},
    )
    with urllib.request.urlopen(req, timeout=20) as resp:
        payload = resp.read().decode('utf-8')
        return json.loads(payload) if payload else None


def receipt_insert(row: Mapping[str, Any]) -> dict[str, Any]:
    """Service-role row write. 409 replays via conflict with existing row."""
    try:
        created = _rest('/rest/v1/trace_ai_receipts', method='POST', body=row)
    except ReceiptConflict:
        raise
    except OnDemandFailure:
        raise
    except urllib.error.HTTPError as error:
        if getattr(error, 'code', None) == 409:
            existing = receipt_lookup(str(row.get('owner')),
                                      str(row.get('idempotency_key')))
            raise ReceiptConflict(existing) from None
        raise OnDemandFailure('AI_PROVIDER_FAILURE') from None
    except Exception:
        raise OnDemandFailure('AI_PROVIDER_FAILURE') from None
    if isinstance(created, list) and created and isinstance(created[0], dict):
        return dict(created[0])
    if isinstance(created, dict):
        return dict(created)
    return dict(row)


def receipt_lookup(owner: str, key: str) -> dict[str, Any] | None:
    try:
        rows = _rest('/rest/v1/trace_ai_receipts', method='GET',
                     params=('?owner=eq.' + quote(owner, safe='')
                             + '&idempotency_key=eq.' + quote(key, safe='')
                             + '&limit=1'))
    except Exception:
        return None
    if isinstance(rows, list) and rows and isinstance(rows[0], dict):
        return dict(rows[0])
    return None


def build_wiring() -> dict[str, Any]:
    """All injectables for ``handle_request``. Env is read per request."""
    return {
        'verify_owner': verify_owner,
        'run_vision': build_run_vision(),
        'receipt_insert': receipt_insert,
        'receipt_lookup': receipt_lookup,
        'receipt_conflict': ReceiptConflict,
    }
