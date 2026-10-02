"""Server-only wire/service boundary. Durable state belongs in Supabase, not RAM."""
from __future__ import annotations

import base64
import binascii
import json

from on_demand_run import OnDemandFailure, OnDemandGateway, _REQUEST_FIELDS
from page_vision import _no_duplicate_keys, _reject_nonfinite

MAX_IMAGE_BYTES = 3 * 1024 * 1024
MAX_WIRE_BYTES = 4 * 1024 * 1024 + 16384


def _bounded_json(raw: bytes) -> dict:
    # Scan nesting before allocating a recursive JSON object. Strings may contain braces.
    depth = 0
    quoted = escaped = False
    for char in raw:
        if quoted:
            if escaped:
                escaped = False
            elif char == 92:
                escaped = True
            elif char == 34:
                quoted = False
        elif char == 34:
            quoted = True
        elif char in (123, 91):
            depth += 1
            if depth > 8:
                raise ValueError('deep JSON')
        elif char in (125, 93):
            depth -= 1
    return json.loads(raw.decode('utf-8'), object_pairs_hook=_no_duplicate_keys,
                      parse_constant=_reject_nonfinite)


def parse_wire_body(raw: bytes) -> dict:
    """Strict eleven-field wire object; pure existing 4 MiB preflight stays unchanged."""
    if not isinstance(raw, bytes) or len(raw) > MAX_WIRE_BYTES:
        raise OnDemandFailure('AI_REQUEST_TOO_LARGE')
    try:
        body = _bounded_json(raw)
        if not isinstance(body, dict) or set(body) != _REQUEST_FIELDS:
            raise ValueError('request shape')
    except (ValueError, UnicodeError, RecursionError):
        raise OnDemandFailure('AI_VISION_REQUEST_INVALID') from None
    encoded = body['page_png']
    if not isinstance(encoded, str) or len(encoded) > 4 * ((MAX_IMAGE_BYTES + 2) // 3):
        raise OnDemandFailure('AI_PAGE_IMAGE_INVALID')
    try:
        image = base64.b64decode(encoded, validate=True)
        if len(image) > MAX_IMAGE_BYTES or base64.b64encode(image).decode('ascii') != encoded:
            raise ValueError('noncanonical base64')
    except (ValueError, binascii.Error):
        raise OnDemandFailure('AI_PAGE_IMAGE_INVALID') from None
    body['page_png'] = image
    # _check is pure: no auth, RAM replay, store, or provider side effect.
    OnDemandGateway._check(None, body)
    return body
