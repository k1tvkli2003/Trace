"""In-process one-page Vision adapter; trusted server caller supplies page scope.

This is not HTTP authorization or durable idempotency. Route, single-attempt budget,
and extract validation remain owned by their existing modules. No network, disk,
provider credentials, retry, or fallback live here.
"""
from __future__ import annotations

import copy
import hashlib
import json
import math
import threading
import uuid
from collections.abc import Callable, Mapping
from dataclasses import dataclass, field
from typing import Any

from budget import BudgetedRun, GatewayFailure, RunLimits
from go_routing import NineRouterRouting
from learning_contract import ContractFailure as PromptFailure, build_prompt
from page_extract import ContractFailure, validate_page_extract


_REQUEST_FIELDS = frozenset({
    'operation', 'capability', 'page_ref', 'source_hash', 'pixel_hash',
    'render_profile', 'page_png', 'reasoning_effort', 'max_output_tokens',
    'max_elapsed_seconds',
})
_POLICY_LIMITS = (1, 4_194_304, 16_384)
_USAGE_FIELDS = frozenset({'input_tokens', 'output_tokens', 'total_tokens'})
_MAX_OPERATIONS = 1_024
_TRANSIENT_FAILURES = frozenset({'AI_RUN_IN_FLIGHT', 'AI_RETRY_NOT_READY'})


class VisionFailure(Exception):
    """Stable, safe code only; no provider payload or book content."""

    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


@dataclass(frozen=True)
class PageScope:
    page_ref: str
    source_hash: str
    pixel_hash: str
    render_profile: str


@dataclass(frozen=True)
class VisionResult:
    operation: str
    request_id: str
    model: str
    reasoning_effort: str
    extract: dict[str, Any]
    usage: dict[str, int | float]
    elapsed_seconds: float
    provider_request_id: str | None = None


@dataclass
class _Operation:
    fingerprint: tuple
    run: BudgetedRun
    request_id: str
    result: VisionResult | None = None
    failure: str | None = None
    lock: threading.Lock = field(default_factory=threading.Lock)
    active: int = 0


def _is_sha256_hex(value: object) -> bool:
    return (isinstance(value, str) and len(value) == 64
            and all(c in '0123456789abcdef' for c in value))


def _safe_usage(value: object) -> dict[str, int | float]:
    if not isinstance(value, Mapping):
        return {}
    return {key: number for key, number in value.items()
            if key in _USAGE_FIELDS and type(number) in (int, float)
            and math.isfinite(number) and number >= 0}


def _safe_provider_id(value: object) -> str | None:
    if (isinstance(value, str) and 0 < len(value) <= 128
            and all(char.isascii() and (char.isalnum() or char in '_-.')
                    for char in value)):
        return value
    return None


def _no_duplicate_keys(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    obj = {}
    for key, value in pairs:
        if key in obj:
            raise ValueError('duplicate JSON key')
        obj[key] = value
    return obj


def _reject_nonfinite(_value: str) -> None:
    raise ValueError('nonfinite JSON value')


class VisionAdapter:
    """RAM-only operation replay, one submission per authorized page operation."""

    def __init__(self, *, transport: Callable[..., dict[str, Any]],
                 authorized_pages: Mapping[str, PageScope | Mapping[str, str]] | None = None,
                 clock=None) -> None:
        if not callable(transport):
            raise VisionFailure('AI_VISION_TRANSPORT_REQUIRED')
        self._transport = transport
        self._pages = dict(authorized_pages or {})
        self._clock = clock
        self._operations: dict[str, _Operation] = {}
        self._lock = threading.Lock()

    def _evict_oldest_terminal_locked(self) -> bool:
        for name, entry in self._operations.items():
            if (entry.result is not None or entry.failure is not None) \
                    and entry.active == 0 \
                    and not entry.lock.locked():
                del self._operations[name]
                return True
        return False

    def _scope(self, request: Mapping[str, Any]) -> PageScope:
        if not isinstance(request, Mapping) or set(request) != _REQUEST_FIELDS:
            raise VisionFailure('AI_VISION_REQUEST_INVALID')
        operation = request['operation']
        if not isinstance(operation, str) or not operation or len(operation) > 128:
            raise VisionFailure('AI_VISION_REQUEST_INVALID')
        authorized = self._pages.get(operation)
        if isinstance(authorized, Mapping):
            if set(authorized) != {'page_ref', 'source_hash', 'pixel_hash', 'render_profile'}:
                raise VisionFailure('AI_PAGE_NOT_AUTHORIZED')
            authorized = PageScope(**authorized)
        if not isinstance(authorized, PageScope):
            raise VisionFailure('AI_PAGE_NOT_AUTHORIZED')
        page = PageScope(*(request[name] for name in (
            'page_ref', 'source_hash', 'pixel_hash', 'render_profile')))
        if page != authorized or not _is_sha256_hex(page.source_hash) or not _is_sha256_hex(page.pixel_hash):
            raise VisionFailure('AI_PAGE_NOT_AUTHORIZED')
        return page

    def _preflight(self, request: Mapping[str, Any]) -> tuple[PageScope, bytes, int, float]:
        page = self._scope(request)
        if (request['capability'] != 'page_vision_extract'
                or request['reasoning_effort'] not in ('high', 'xhigh')):
            raise VisionFailure('AI_VISION_REQUEST_INVALID')
        tokens = request['max_output_tokens']
        seconds = request['max_elapsed_seconds']
        if (type(tokens) is not int or not 1 <= tokens <= 16_384
                or type(seconds) not in (int, float) or not math.isfinite(seconds)
                or not 0 < seconds <= 300):
            raise VisionFailure('AI_VISION_REQUEST_INVALID')
        image = request['page_png']
        if (not isinstance(image, bytes) or not 16 <= len(image) <= 4_194_304
                or not image.startswith(b'\x89PNG\r\n\x1a\n')):
            raise VisionFailure('AI_PAGE_IMAGE_INVALID')
        if hashlib.sha256(image).hexdigest() != page.pixel_hash:
            raise VisionFailure('AI_PAGE_IMAGE_MISMATCH')
        return page, image, tokens, seconds

    def extract(self, request: Mapping[str, Any]) -> VisionResult:
        page, image, tokens, seconds = self._preflight(request)
        operation = request['operation']
        effort = request['reasoning_effort']
        # Generated request IDs cannot change this identity. Hash is over actual bytes.
        fingerprint = (request['capability'], page, effort, tokens, seconds,
                       hashlib.sha256(image).digest())
        with self._lock:
            state = self._operations.get(operation)
            if state is None:
                if len(self._operations) >= _MAX_OPERATIONS:
                    if not self._evict_oldest_terminal_locked():
                        raise VisionFailure('AI_OPERATION_LIMIT_EXCEEDED')
                limits = RunLimits(_POLICY_LIMITS[0], _POLICY_LIMITS[1],
                                   _POLICY_LIMITS[2], seconds)
                run = (BudgetedRun(limits, clock=self._clock) if self._clock
                       else BudgetedRun(limits))
                state = _Operation(fingerprint, run, uuid.uuid4().hex)
                self._operations[operation] = state
            elif fingerprint != state.fingerprint:
                raise VisionFailure('AI_RUN_CONFLICT')
            state.active += 1
        if not state.lock.acquire(blocking=False):
            with self._lock:
                state.active -= 1
            raise VisionFailure('AI_RUN_IN_FLIGHT')
        try:
            if state.result is not None:
                return copy.deepcopy(state.result)
            if state.failure is not None:
                raise VisionFailure(state.failure)
            return self._perform(state, operation, page, image, effort, tokens, seconds)
        finally:
            state.lock.release()
            with self._lock:
                state.active -= 1

    def _fail(self, state, code: str) -> VisionFailure:
        with self._lock:
            state.failure = code
        return VisionFailure(code)

    def _perform(self, state, operation, page, image, effort, tokens, seconds):
        route = NineRouterRouting(reasoning_effort=effort).resolve('page_vision_extract')
        try:
            prompt = build_prompt(capability='page_vision_extract', task={
                'pageRef': page.page_ref, 'sourceHash': page.source_hash,
                'pixelHash': page.pixel_hash, 'renderProfile': page.render_profile,
                'pageImageHandle': 'asset_' + page.pixel_hash,
            }, source_context=[])
        except PromptFailure:
            raise self._fail(state, 'AI_VISION_REQUEST_INVALID') from None
        envelope = {
            **prompt,
            'page': {'sourceHash': page.source_hash, 'pixelHash': page.pixel_hash,
                     'renderProfile': page.render_profile, 'pageRef': page.page_ref},
        }
        response: dict[str, Any] = {}

        def send(_payload: bytes, cap: int, timeout: float) -> bytes:
            nonlocal response
            response = self._transport(
                request_id=state.request_id, route=route, envelope=envelope,
                image_png=image, max_output_tokens=cap, timeout_seconds=timeout)
            if not isinstance(response, dict):
                raise ValueError('invalid transport result')
            if response.get('status') != 'completed':
                return b'0'  # BudgetedRun requires bytes; no partial text is trusted.
            text = response.get('text')
            if not isinstance(text, str):
                raise ValueError('invalid transport text')
            return text.encode('utf-8')

        try:
            raw = state.run.call(image, tokens, send)
        except GatewayFailure as error:
            if error.code not in _TRANSIENT_FAILURES:
                with self._lock:
                    state.failure = error.code
            raise VisionFailure(error.code) from None
        if response.get('status') != 'completed':
            raise self._fail(state, 'AI_INCOMPLETE_RESPONSE')
        try:
            document = json.loads(raw.decode('utf-8'),
                                  object_pairs_hook=_no_duplicate_keys,
                                  parse_constant=_reject_nonfinite)
            document = validate_page_extract(
                document, source_hash=page.source_hash,
                pixel_hash=page.pixel_hash, render_profile=page.render_profile,
                page_ref=page.page_ref)
        except (ValueError, UnicodeError, ContractFailure, RecursionError):
            raise self._fail(state, 'AI_SCHEMA_REJECTED') from None
        elapsed = response.get('elapsed_seconds')
        if (type(elapsed) not in (int, float) or not math.isfinite(elapsed)
                or not 0 <= elapsed <= seconds):
            raise self._fail(state, 'AI_SCHEMA_REJECTED')
        result = VisionResult(
            operation=operation, request_id=state.request_id,
            model=route.model, reasoning_effort=effort, extract=document,
            usage=_safe_usage(response.get('usage')),
            elapsed_seconds=float(elapsed),
            provider_request_id=_safe_provider_id(response.get('provider_request_id')))
        with self._lock:
            state.result = result
        return copy.deepcopy(result)
