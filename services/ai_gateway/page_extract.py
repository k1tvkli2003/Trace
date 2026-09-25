"""Fail-closed validator for page-extract-v1.

Raster Vision only: one hash-bound page, complete reading-order blocks,
figures tied to blocks, low-confidence content quarantined as unknown.
Never OCR, never PDF text layer.
"""
from __future__ import annotations

import re


class ContractFailure(ValueError):
    """A page extract cannot be trusted as source transcription."""


_SCHEMA_VERSION = 'page-extract-v1'
_ALLOWED_KINDS = frozenset({
    'heading', 'paragraph', 'list', 'table',
    'formula', 'caption', 'footnote', 'figure', 'unknown',
})
_DOC_KEYS = frozenset({
    'schemaVersion', 'sourceHash', 'pixelHash', 'renderProfile',
    'pageRef', 'extractionVersion', 'coverage', 'blocks', 'figures',
})
_BLOCK_KEYS = frozenset({'id', 'order', 'kind', 'text', 'bbox', 'confidence', 'uncertain'})
_FIGURE_KEYS = frozenset({'id', 'blockId', 'bbox', 'caption', 'confidence'})
_SHA256 = re.compile(r'^[0-9a-f]{64}$')
_UNSAFE = re.compile(r'<\s*/?\s*[a-z!][^>]*>|\b(?:javascript|data):', re.I)
_MAX_BLOCKS = 300
_MAX_FIGURES = 30
_MAX_TEXT = 8000
_MAX_CAPTION = 1000
_LOW_CONFIDENCE = 0.5


def _valid_hash(value: object) -> bool:
    return isinstance(value, str) and bool(_SHA256.fullmatch(value))


def _require_id(value: object, description: str) -> str:
    if not isinstance(value, str) or not value.strip() or len(value) > 512:
        raise ContractFailure(f'INVALID_{description}')
    return value


def _check_box(box: object) -> None:
    if not isinstance(box, dict) or set(box) != {'x', 'y', 'w', 'h'}:
        raise ContractFailure('INVALID_BBOX')
    point = {key: box[key] for key in ('x', 'y')}
    size = {key: box[key] for key in ('w', 'h')}
    for key, value in point.items():
        if not isinstance(value, (int, float)) or value != value or \
                not 0.0 <= float(value) <= 1.0:
            raise ContractFailure('INVALID_BBOX')
    for key, value in size.items():
        if not isinstance(value, (int, float)) or value != value or \
                not 0.0 < float(value) <= 1.0:
            raise ContractFailure('INVALID_BBOX')
    if float(box['x']) + float(box['w']) > 1.0 or \
            float(box['y']) + float(box['h']) > 1.0:
        raise ContractFailure('BBOX_OUT_OF_PAGE')


def validate_page_extract(
    document: object, *, source_hash: str, pixel_hash: str,
    render_profile: str, page_ref: str,
) -> dict:
    """Validate an untrusted page extract against the rendered page."""
    if not isinstance(document, dict):
        raise ContractFailure('INVALID_EXTRACT')
    if set(document) != set(_DOC_KEYS):
        raise ContractFailure('INVALID_EXTRACT_KEYS')
    if document['schemaVersion'] != _SCHEMA_VERSION:
        raise ContractFailure('INVALID_SCHEMA_VERSION')
    for claimant, expected in (
        (document['sourceHash'], source_hash),
        (document['pixelHash'], pixel_hash),
    ):
        if not _valid_hash(claimant) or claimant != expected:
            raise ContractFailure('PAGE_MISMATCH')
    if not _valid_hash(source_hash) or not _valid_hash(pixel_hash):
        raise ContractFailure('INVALID_PAGE_HASH')
    if not isinstance(document['renderProfile'], str) or \
            document['renderProfile'] != render_profile or not render_profile.strip():
        raise ContractFailure('RENDER_MISMATCH')
    if not isinstance(document['pageRef'], str) or document['pageRef'] != page_ref:
        raise ContractFailure('PAGE_MISMATCH')
    _require_id(page_ref, 'PAGE_REF')
    if document['extractionVersion'] != 'page-vision-extract-v1':
        raise ContractFailure('INVALID_EXTRACTION_VERSION')
    if document['coverage'] != 'complete':
        raise ContractFailure('PARTIAL_COVERAGE_REJECTED')

    blocks = document['blocks']
    if not isinstance(blocks, list) or not blocks or len(blocks) > _MAX_BLOCKS:
        raise ContractFailure('INVALID_BLOCKS')
    ids: set[str] = set()
    for index, block in enumerate(blocks):
        if not isinstance(block, dict) or set(block) != set(_BLOCK_KEYS):
            raise ContractFailure('INVALID_BLOCK_KEYS')
        block_id = _require_id(block.get('id'), 'BLOCK_ID')
        if block_id in ids:
            raise ContractFailure('DUPLICATE_BLOCK_ID')
        ids.add(block_id)
        if block.get('order') != index:
            raise ContractFailure('BLOCKS_NOT_ORDERED')
        kind = block.get('kind')
        if kind not in _ALLOWED_KINDS:
            raise ContractFailure('INVALID_BLOCK_KIND')
        text = block.get('text')
        if not isinstance(text, str) or len(text) > _MAX_TEXT or _UNSAFE.search(text):
            raise ContractFailure('INVALID_BLOCK_TEXT')
        confidence = block.get('confidence')
        if not isinstance(confidence, (int, float)) or confidence != confidence or \
                not 0.0 <= float(confidence) <= 1.0:
            raise ContractFailure('INVALID_CONFIDENCE')
        uncertain = block.get('uncertain')
        if not isinstance(uncertain, bool):
            raise ContractFailure('INVALID_UNCERTAINTY')
        if kind == 'unknown' and (text.strip() or not uncertain):
            raise ContractFailure('UNKNOWN_BLOCK_MUST_BE_QUARANTINED')
        if float(confidence) < _LOW_CONFIDENCE and not uncertain:
            raise ContractFailure('LOW_CONFIDENCE_REQUIRES_UNCERTAIN')
        if uncertain and kind != 'unknown' and not text.strip():
            raise ContractFailure('EMPTY_TRANSCRIPTION_REJECTED')
        _check_box(block.get('bbox'))

    figures = document['figures']
    if not isinstance(figures, list) or len(figures) > _MAX_FIGURES:
        raise ContractFailure('INVALID_FIGURES')
    figure_ids: set[str] = set()
    for figure in figures:
        if not isinstance(figure, dict) or set(figure) != set(_FIGURE_KEYS):
            raise ContractFailure('INVALID_FIGURE_KEYS')
        figure_id = _require_id(figure.get('id'), 'FIGURE_ID')
        if figure_id in figure_ids:
            raise ContractFailure('DUPLICATE_FIGURE_ID')
        figure_ids.add(figure_id)
        if figure.get('blockId') not in ids:
            raise ContractFailure('FOREIGN_FIGURE_BLOCK')
        caption = figure.get('caption')
        if not isinstance(caption, str) or not caption.strip() or \
                len(caption) > _MAX_CAPTION or _UNSAFE.search(caption):
            raise ContractFailure('INVALID_FIGURE_CAPTION')
        confidence = figure.get('confidence')
        if not isinstance(confidence, (int, float)) or confidence != confidence or \
                not 0.0 <= float(confidence) <= 1.0:
            raise ContractFailure('INVALID_FIGURE_CONFIDENCE')
        _check_box(figure.get('bbox'))

    figure_blocks = {b['id'] for b in blocks if isinstance(b, dict) and b.get('kind') == 'figure'}
    owned = {figure.get('blockId') for figure in figures if isinstance(figure, dict)}
    if not figure_blocks <= owned or not owned <= figure_blocks:
        raise ContractFailure('FIGURE_BLOCK_WITHOUT_FIGURE')

    return document
