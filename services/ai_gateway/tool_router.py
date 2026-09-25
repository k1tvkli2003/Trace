"""Offline typed tool-call router. Validates one proposal, returns an inert receipt.

No network access, database writes, model calls, or key handling.
A receipt never executes the tool; validation, authorization, and durable
mutation belong outside this module. Duplicate idempotency keys replay the
stored receipt; a reused key with a different call is rejected.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections.abc import Mapping

_ROUTER_VERSION = 'tool-router-v1'

_READ_ONLY = frozenset({
    'get_current_slice',
    'get_source_citations',
    'search_cached_source',
    'get_due_reviews',
    'get_highlights',
    'get_notes',
    'get_learning_state',
})

_MUTATIONS = frozenset({
    'mark_lesson_state',
    'schedule_review',
    'create_note',
    'update_note',
    'create_highlight',
    'delete_highlight',
    'jump_to_node',
    'request_next_slice',
    'set_preference',
    'retry_failed_job',
})

_STATES = frozenset({'studied', 'not_learned', 'later', 'mastered', 'skipped'})
_PREF_KEYS = frozenset({'tone', 'depth', 'emoji', 'examples', 'questions'})

_UNSAFE = re.compile(r'<\s*/?\s*[a-z!][^>]*>|\b(?:javascript|data)\s*:', re.I)
_SQL = re.compile(r'\b(drop\s+table|delete\s+from|insert\s+into)\b', re.I)
_KEY = re.compile(r'^[A-Za-z0-9_.\-]{1,128}$')
_SHA = re.compile(r'^[0-9a-f]{64}$')

_MAX_ID = 256
_MAX_TEXT = 2000
_MAX_QUERY = 200
_MAX_LIST = 50


class ToolRouterFailure(Exception):
    """Stable rejection code; never carries payload bytes or private data."""

    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


def _check_unsafe(value: object) -> None:
    if isinstance(value, str):
        if _UNSAFE.search(value) or _SQL.search(value):
            raise ToolRouterFailure('UNSAFE_PAYLOAD')
    elif isinstance(value, list):
        for item in value:
            _check_unsafe(item)
    elif isinstance(value, Mapping):
        for item in value.values():
            _check_unsafe(item)


def _text(value: object, *, maximum: int) -> str:
    if not isinstance(value, str) or not value.strip() or len(value) > maximum:
        raise ToolRouterFailure('INVALID_ARGS')
    return value


def _optional_text(args: Mapping, key: str, *, maximum: int) -> None:
    if args.get(key) is None:
        return
    _text(args.get(key), maximum=maximum)


def _utc(value: object) -> None:
    from datetime import datetime

    if not isinstance(value, str) or not value.endswith('Z'):
        raise ToolRouterFailure('INVALID_ARGS')
    try:
        parsed = datetime.fromisoformat(value.replace('Z', '+00:00'))
    except ValueError:
        raise ToolRouterFailure('INVALID_ARGS') from None
    if parsed.tzinfo is None:
        raise ToolRouterFailure('INVALID_ARGS')


def _id_list(value: object) -> None:
    if not isinstance(value, list) or not value or len(value) > _MAX_LIST:
        raise ToolRouterFailure('INVALID_ARGS')
    for item in value:
        _text(item, maximum=_MAX_ID)


def _check_args(tool_name: str, args: Mapping) -> None:
    required = {
        'get_current_slice': ('libraryId',),
        'get_source_citations': (),
        'search_cached_source': ('query',),
        'get_due_reviews': ('libraryId',),
        'get_highlights': ('libraryId',),
        'get_notes': ('libraryId',),
        'get_learning_state': ('libraryId',),
        'mark_lesson_state': ('sliceId', 'state'),
        'schedule_review': ('targetId', 'dueAt'),
        'create_note': ('libraryId', 'body'),
        'update_note': ('noteId', 'body'),
        'create_highlight': ('libraryId', 'quote'),
        'delete_highlight': ('highlightId',),
        'jump_to_node': ('nodeId',),
        'request_next_slice': ('nodeId',),
        'set_preference': ('key', 'value'),
        'retry_failed_job': ('jobId',),
    }[tool_name]
    allowed = {
        'get_current_slice': {'libraryId'},
        'get_source_citations': {'citationIds'},
        'search_cached_source': {'query', 'libraryId', 'limit'},
        'get_due_reviews': {'libraryId'},
        'get_highlights': {'libraryId', 'sliceId'},
        'get_notes': {'libraryId', 'sliceId'},
        'get_learning_state': {'libraryId', 'sliceId'},
        'mark_lesson_state': {'sliceId', 'state'},
        'schedule_review': {'targetId', 'dueAt'},
        'create_note': {'libraryId', 'body', 'sliceId', 'anchorId'},
        'update_note': {'noteId', 'body'},
        'create_highlight': {'libraryId', 'quote', 'sourceBlockId'},
        'delete_highlight': {'highlightId'},
        'jump_to_node': {'nodeId'},
        'request_next_slice': {'nodeId', 'currentSliceId'},
        'set_preference': {'key', 'value'},
        'retry_failed_job': {'jobId'},
    }[tool_name]
    unknown = set(args) - allowed
    if unknown:
        raise ToolRouterFailure('UNKNOWN_ARG_FIELD')
    for key in required:
        if args.get(key) is None:
            raise ToolRouterFailure('INVALID_ARGS')
    for key in (
        'libraryId', 'sliceId', 'nodeId', 'targetId', 'noteId', 'anchorId',
        'highlightId', 'jobId', 'currentSliceId', 'sourceBlockId',
    ):
        _optional_text(args, key, maximum=_MAX_ID)
    for key in ('body', 'quote', 'value'):
        _optional_text(args, key, maximum=_MAX_TEXT)
    if tool_name == 'get_source_citations':
        if args.get('citationIds') is None:
            raise ToolRouterFailure('INVALID_ARGS')
        _id_list(args.get('citationIds'))
    if tool_name == 'search_cached_source':
        _text(args.get('query'), maximum=_MAX_QUERY)
        limit = args.get('limit')
        if limit is not None and (not isinstance(limit, int) or not 1 <= limit <= _MAX_LIST):
            raise ToolRouterFailure('INVALID_ARGS')
    if tool_name == 'mark_lesson_state':
        _text(args.get('sliceId'), maximum=_MAX_ID)
        if args.get('state') not in _STATES:
            raise ToolRouterFailure('INVALID_ARGS')
    if tool_name == 'schedule_review':
        _text(args.get('targetId'), maximum=_MAX_ID)
        _utc(args.get('dueAt'))
    if tool_name == 'set_preference':
        if args.get('key') not in _PREF_KEYS:
            raise ToolRouterFailure('INVALID_ARGS')
        _text(args.get('value'), maximum=64)


class ToolRouter:
    """Single-instance offline router; idempotency memory lives in RAM only."""

    def __init__(self) -> None:
        self._receipts: dict[str, dict] = {}

    def propose(self, *, tool_name: object, args: object, idempotency_key: object) -> dict:
        if not isinstance(idempotency_key, str) or not _KEY.fullmatch(idempotency_key):
            raise ToolRouterFailure('INVALID_IDEMPOTENCY_KEY')
        if tool_name not in _READ_ONLY and tool_name not in _MUTATIONS:
            raise ToolRouterFailure('AI_TOOL_NOT_ALLOWED')
        if not isinstance(args, Mapping):
            raise ToolRouterFailure('INVALID_ARGS')
        _check_unsafe(args)
        _check_args(tool_name, args)
        canonical = json.dumps(args, sort_keys=True, ensure_ascii=False, separators=(',', ':'))
        fingerprint = hashlib.sha256(
            f'{tool_name}\x00{canonical}\x00{idempotency_key}'.encode('utf-8'),
        ).hexdigest()
        stored = self._receipts.get(idempotency_key)
        if stored is not None:
            if stored['fingerprint'] != fingerprint:
                raise ToolRouterFailure('IDEMPOTENCY_CONFLICT')
            return {**stored['receipt'], 'replayed': True}
        receipt = {
            'receiptId': fingerprint,
            'toolName': tool_name,
            'kind': 'read-only' if tool_name in _READ_ONLY else 'mutation',
            'args': dict(args),
            'idempotencyKey': idempotency_key,
            'validation': {'ok': True, 'version': _ROUTER_VERSION},
            'replayed': False,
            'executed': False,
        }
        self._receipts[idempotency_key] = {'fingerprint': fingerprint, 'receipt': receipt}
        return dict(receipt)
