"""Fail-closed validator for structure-proposal-v1.

Metadata only: ordered candidate nodes with page ranges, confidence,
reason and needsReview. No transcription, no lesson text, no OCR.
"""
from __future__ import annotations

import re


class ContractFailure(ValueError):
    """A structure proposal cannot be used as a tree candidate."""


_SCHEMA_VERSION = 'structure-proposal-v1'
_ALLOWED_KINDS = frozenset({'part', 'chapter', 'section', 'concept'})
_DOC_KEYS = frozenset({'schemaVersion', 'sourceHash', 'pageRefs', 'nodes'})
_NODE_KEYS = frozenset({
    'id', 'parentId', 'order', 'kind', 'title',
    'sourceRange', 'confidence', 'reason', 'needsReview',
})
_SHA256 = re.compile(r'^[0-9a-f]{64}$')
_MAX_NODES = 100
_MAX_TITLE = 500
_MAX_REASON = 1000
_LOW_CONFIDENCE_THRESHOLD = 0.5


def _require_text(value: object, description: str, limit: int) -> str:
    if not isinstance(value, str) or not value.strip() or len(value) > limit:
        raise ContractFailure(f'INVALID_{description}')
    return value


def validate_structure_proposal(
    document: object, *, source_hash: str, page_refs: tuple[str, ...] | list[str],
    page_count: int,
) -> dict:
    """Validate an untrusted structure proposal against the scan scope."""
    if not isinstance(document, dict):
        raise ContractFailure('INVALID_PROPOSAL')
    if set(document) != set(_DOC_KEYS):
        raise ContractFailure('INVALID_PROPOSAL_KEYS')
    if document['schemaVersion'] != _SCHEMA_VERSION:
        raise ContractFailure('INVALID_SCHEMA_VERSION')
    raw_hash = document['sourceHash']
    if not isinstance(raw_hash, str) or not _SHA256.fullmatch(raw_hash):
        raise ContractFailure('INVALID_SOURCE_HASH')
    if raw_hash != source_hash:
        raise ContractFailure('SOURCE_MISMATCH')
    if not _SHA256.fullmatch(str(source_hash)):
        raise ContractFailure('INVALID_SOURCE_HASH')

    refs = document['pageRefs']
    if not isinstance(refs, list) or not refs or len(refs) > 24:
        raise ContractFailure('INVALID_PAGE_REFS')
    allowed = set(page_refs)
    for ref in refs:
        _require_text(ref, 'PAGE_REF', 512)
        if ref not in allowed:
            raise ContractFailure('FOREIGN_PAGE_REF')

    if not isinstance(page_count, int) or page_count < 1:
        raise ContractFailure('INVALID_PAGE_COUNT')

    nodes = document['nodes']
    if not isinstance(nodes, list) or not nodes or len(nodes) > _MAX_NODES:
        raise ContractFailure('INVALID_NODES')

    ids: set[str] = set()
    parsed_ranges: list[tuple[int, int]] = []
    for index, node in enumerate(nodes):
        if not isinstance(node, dict) or set(node) != set(_NODE_KEYS):
            raise ContractFailure('INVALID_NODE_KEYS')
        node_id = _require_text(node.get('id'), 'NODE_ID', 512)
        if node_id in ids:
            raise ContractFailure('DUPLICATE_NODE_ID')
        ids.add(node_id)
        if node.get('order') != index:
            raise ContractFailure('NODES_NOT_ORDERED')
        if node.get('kind') not in _ALLOWED_KINDS:
            raise ContractFailure('INVALID_NODE_KIND')
        _require_text(node.get('title'), 'NODE_TITLE', _MAX_TITLE)
        _require_text(node.get('reason'), 'NODE_REASON', _MAX_REASON)

        parent = node.get('parentId')
        if parent is not None:
            if not isinstance(parent, str) or not parent.strip() or len(parent) > 512:
                raise ContractFailure('INVALID_PARENT_ID')
            if parent == node_id:
                raise ContractFailure('SELF_PARENT')

        source_range = node.get('sourceRange')
        if not isinstance(source_range, dict) or set(source_range) != {'startPage', 'endPage'}:
            raise ContractFailure('INVALID_SOURCE_RANGE')
        start = source_range['startPage']
        end = source_range['endPage']
        if not isinstance(start, int) or not isinstance(end, int):
            raise ContractFailure('INVALID_SOURCE_RANGE')
        if start < 1 or end < start or end > page_count:
            raise ContractFailure('PAGE_RANGE_OUT_OF_SCOPE')
        parsed_ranges.append((start, end))

        confidence = node.get('confidence')
        if not isinstance(confidence, (int, float)) or not float(confidence) == float(confidence):
            raise ContractFailure('INVALID_CONFIDENCE')
        confidence_f = float(confidence)
        if not 0.0 <= confidence_f <= 1.0:
            raise ContractFailure('INVALID_CONFIDENCE')

        needs_review = node.get('needsReview')
        if not isinstance(needs_review, bool):
            raise ContractFailure('INVALID_NEEDS_REVIEW')
        if confidence_f < _LOW_CONFIDENCE_THRESHOLD and not needs_review:
            raise ContractFailure('LOW_CONFIDENCE_REQUIRES_REVIEW')

    by_id = {node['id']: node for node in nodes if isinstance(node, dict)}
    for node in nodes:
        parent = node['parentId']
        if parent is not None:
            if parent not in by_id:
                raise ContractFailure('UNKNOWN_PARENT')
            parent_range = by_id[parent]['sourceRange']
            child_range = node['sourceRange']
            if child_range['startPage'] < parent_range['startPage'] or \
                    child_range['endPage'] > parent_range['endPage']:
                raise ContractFailure('CHILD_RANGE_OUTSIDE_PARENT')

    groups: dict[str | None, list[tuple[int, int, str]]] = {}
    for node in nodes:
        key = node['parentId']
        groups.setdefault(key, []).append(
            (node['sourceRange']['startPage'], node['sourceRange']['endPage'], node['id']),
        )
    for spans in groups.values():
        spans.sort()
        for prev, current in zip(spans, spans[1:]):
            if current[0] <= prev[1]:
                raise ContractFailure('OVERLAPPING_SIBLING_RANGES')

    return document
