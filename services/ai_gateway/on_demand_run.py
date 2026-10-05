"""Server-side on-demand run boundary. No network, secret, or Supabase here.

Auth is injected: caller supplies owner verification. Vision is injected:
caller supplies the authorized single-attempt adapter call. This module owns
request shape, owner-scoped idempotency, failure mapping, and a secret-free
receipt only.
"""
from __future__ import annotations

import copy
import hashlib
import math
import re
import threading
import uuid
from collections.abc import Callable, Mapping
from dataclasses import dataclass, field
from typing import Any


_REQUEST_FIELDS = frozenset({
    'operation', 'capability', 'page_ref', 'source_hash', 'pixel_hash',
    'render_profile', 'page_png', 'reasoning_effort', 'max_output_tokens',
    'max_elapsed_seconds', 'idempotency_key',
})
_USAGES = frozenset({'input_tokens', 'output_tokens', 'total_tokens'})
_KEY_CHARS = frozenset(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.')
_RESERVED_IDS = frozenset({'__proto__', 'constructor', 'prototype'})
_UNSAFE = re.compile(r'<\s*/?\s*[a-z!][^>]*>|\b(?:javascript|data):', re.I)
_CONTROL_RANGES = (
    (0x00, 0x08), (0x0B, 0x0C), (0x0E, 0x1F), (0x7F, 0x9F),
    (0x202A, 0x202E), (0x2066, 0x2069),
)
_CONTROL_TEXT = re.compile(
    '[' + ''.join(
        chr(code) for start, end in _CONTROL_RANGES
        for code in range(start, end + 1)
    ) + ']'
)


def _require_identity(value: object, *, limit: int) -> str:
    """Literal identifier the extract schema can accept; no silent fix.

    Mirrors the page-extract identity rule that would otherwise reject
    the page only after provider work. Fail-closed before any spend or
    receipt: reserved tokens, surrounding whitespace, markup/URL schemes,
    and bidi/control characters are rejected here, never normalized.
    """
    if (not isinstance(value, str) or not value or len(value) > limit
            or value in _RESERVED_IDS or value != value.strip()
            or not value.isascii() or _UNSAFE.search(value)
            or _CONTROL_TEXT.search(value)):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
    return value


class OnDemandFailure(Exception):
    """Stable, safe code only; never carries prompt, image, or provider data."""

    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


@dataclass
class _Entry:
    fingerprint: tuple
    request_id: str
    receipt: dict[str, Any] | None = None
    failure: str | None = None
    lock: threading.Lock = field(default_factory=threading.Lock)
    active: int = 0


def _sha(value: object) -> bool:
    return (isinstance(value, str) and len(value) == 64
            and all(c in '0123456789abcdef' for c in value))


def _receipt_id() -> str:
    return uuid.uuid4().hex


def _usage(value: object) -> dict[str, int | float]:
    if not isinstance(value, Mapping):
        return {}
    return {key: number for key, number in value.items()
            if key in _USAGES and type(number) in (int, float)
            and math.isfinite(number) and number >= 0}


def _provider_id(value: object) -> str | None:
    if (isinstance(value, str) and 0 < len(value) <= 128
            and all(char.isascii() and (char.isalnum() or char in '_-.')
                    for char in value)):
        return value
    return None


class OnDemandGateway:
    """Owner-scoped idempotent boundary over one injected Vision run."""

    def __init__(self, *, verify_owner: Callable[[object], str],
                 run_vision: Callable[[dict[str, Any]], dict[str, Any]]) -> None:
        if not callable(verify_owner) or not callable(run_vision):
            raise OnDemandFailure('AI_GATEWAY_NOT_CONFIGURED')
        self._verify_owner = verify_owner
        self._run_vision = run_vision
        self._entries: dict[tuple[str, str], _Entry] = {}
        self._lock = threading.Lock()

    def _check(self, request: Mapping[str, Any]) -> tuple[bytes, int, float]:
        if not isinstance(request, Mapping) or set(request) != _REQUEST_FIELDS:
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        operation = _require_identity(request['operation'], limit=91)
        if request['capability'] != 'page_vision_extract':
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        if request['reasoning_effort'] not in ('high', 'xhigh'):
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        page_ref = request['page_ref']
        if (not isinstance(request['render_profile'], str)
                or not request['render_profile'].strip()
                or len(request['render_profile']) > 128):
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        _require_identity(page_ref, limit=256)
        if not _sha(request['source_hash']) or not _sha(request['pixel_hash']):
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        tokens = request['max_output_tokens']
        seconds = request['max_elapsed_seconds']
        if (type(tokens) is not int or not 1 <= tokens <= 16_384
                or type(seconds) not in (int, float)
                or not math.isfinite(seconds) or not 0 < seconds <= 300):
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        image = request['page_png']
        if (not isinstance(image, bytes) or not 16 <= len(image) <= 4_194_304
                or not image.startswith(b'\x89PNG\r\n\x1a\n')):
            raise OnDemandFailure('AI_PAGE_IMAGE_INVALID')
        if hashlib.sha256(image).hexdigest() != request['pixel_hash']:
            raise OnDemandFailure('AI_PAGE_IMAGE_MISMATCH')
        key = request['idempotency_key']
        if (not isinstance(key, str) or not key or len(key) > 128
                or any(char not in _KEY_CHARS for char in key)):
            raise OnDemandFailure('AI_VISION_REQUEST_INVALID')
        return image, tokens, seconds

    def handle(self, request: Mapping[str, Any], *,
               authorization: str | None) -> dict[str, Any]:
        try:
            owner = self._verify_owner(authorization)
        except OnDemandFailure:
            raise
        except Exception:
            raise OnDemandFailure('AI_UNAUTHORIZED') from None
        if not isinstance(owner, str) or not owner or len(owner) > 256:
            raise OnDemandFailure('AI_UNAUTHORIZED')
        image, tokens, seconds = self._check(request)
        fingerprint = (
            request['capability'], request['page_ref'],
            request['source_hash'], request['pixel_hash'],
            request['render_profile'], request['reasoning_effort'],
            tokens, seconds, hashlib.sha256(image).digest(),
        )
        slot = (owner, request['idempotency_key'])
        with self._lock:
            entry = self._entries.get(slot)
            if entry is None:
                entry = _Entry(fingerprint, _receipt_id())
                self._entries[slot] = entry
            elif fingerprint != entry.fingerprint:
                raise OnDemandFailure('AI_RUN_CONFLICT')
            entry.active += 1
        if not entry.lock.acquire(blocking=False):
            with self._lock:
                entry.active -= 1
            raise OnDemandFailure('AI_RUN_IN_FLIGHT')
        try:
            if entry.receipt is not None:
                return copy.deepcopy(entry.receipt)
            if entry.failure is not None:
                raise OnDemandFailure(entry.failure)
            adapter_request = {
                'operation': f'{owner}:{request["operation"]}',
                'capability': request['capability'],
                'page_ref': request['page_ref'],
                'source_hash': request['source_hash'],
                'pixel_hash': request['pixel_hash'],
                'render_profile': request['render_profile'],
                'page_png': image,
                'reasoning_effort': request['reasoning_effort'],
                'max_output_tokens': tokens,
                'max_elapsed_seconds': seconds,
            }
            try:
                result = self._run_vision(adapter_request)
            except OnDemandFailure as error:
                with self._lock:
                    entry.failure = error.code
                raise
            receipt = {
                'requestId': entry.request_id,
                'status': 'completed',
                'operation': request['operation'],
                'capability': request['capability'],
                'model': result.get('model'),
                'reasoning_effort': result.get('reasoning_effort'),
                'usage': _usage(result.get('usage')),
                'elapsed_seconds': result.get('elapsed_seconds'),
                'provider_request_id': _provider_id(
                    result.get('provider_request_id')),
            }
            if (not isinstance(receipt['model'], str) or not receipt['model']
                    or receipt['reasoning_effort']
                    not in ('high', 'xhigh')):
                raise OnDemandFailure('AI_SCHEMA_REJECTED')
            elapsed = receipt['elapsed_seconds']
            if (type(elapsed) not in (int, float)
                    or not math.isfinite(elapsed)
                    or not 0 <= elapsed <= seconds):
                raise OnDemandFailure('AI_SCHEMA_REJECTED')
            receipt['elapsed_seconds'] = float(elapsed)
            with self._lock:
                entry.receipt = copy.deepcopy(receipt)
            return copy.deepcopy(receipt)
        except OnDemandFailure as error:
            if error.code not in ('AI_RUN_IN_FLIGHT',):
                with self._lock:
                    if entry.receipt is None and entry.failure is None:
                        entry.failure = error.code
            raise
        finally:
            entry.lock.release()
            with self._lock:
                entry.active -= 1
