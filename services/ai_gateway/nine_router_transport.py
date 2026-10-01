"""Stdlib SSE transport for the fixed 9Router Responses route.

Server-only boundary. Credential comes from ``NINEROUTER_API_KEY`` env only;
never accept a key argument, never log it, never put it in the body or errors.
No model fallback, no retry, no OCR, no PDF text layer.
"""
from __future__ import annotations

import base64
import http.client
import json
import os
import time
from typing import Any
from urllib.parse import urlparse

from budget import HttpFailure

_FIXED_ENDPOINT = "http://127.0.0.1:20128/v1/responses"
_FIXED_PATH = "/v1/responses"
_FIXED_MODEL = "oc/muse-spark-1.3-contributor-free"
_FIXED_EFFORTS = ("high", "xhigh")
_MAX_STREAM_BYTES = 262_144
_KEY_CHARS = frozenset(
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~+/=")


def responses_transport(*, request_id: str, route, envelope: dict[str, Any],
                        image_png: bytes, max_output_tokens: int,
                        timeout_seconds: float) -> dict[str, Any]:
    """POST one Responses SSE call and return a typed result dict."""
    if (not isinstance(request_id, str) or len(request_id) != 32
            or not isinstance(envelope, dict) or not isinstance(image_png, bytes)
            or not image_png or not isinstance(max_output_tokens, int)
            or isinstance(max_output_tokens, bool)
            or not 0 < max_output_tokens <= 16384
            or not isinstance(timeout_seconds, (int, float))
            or isinstance(timeout_seconds, bool)
            or timeout_seconds != timeout_seconds
            or not 0 < float(timeout_seconds) <= 300):
        raise ValueError("AI_VISION_REQUEST_INVALID")
    if len(image_png) > 4_194_304:
        raise ValueError("AI_VISION_REQUEST_INVALID")
    if (getattr(route, "endpoint", None) != _FIXED_ENDPOINT
            or getattr(route, "model", None) != _FIXED_MODEL
            or getattr(route, "reasoning_effort", None) not in _FIXED_EFFORTS
            or not getattr(route, "accepts_images", False)
            or getattr(route, "accepts_pdf", True)):
        raise ValueError("AI_ROUTE_NOT_ALLOWED")
    parsed = urlparse(_FIXED_ENDPOINT)
    if parsed.scheme != "http" or parsed.path != _FIXED_PATH:
        raise ValueError("AI_ROUTE_NOT_ALLOWED")
    api_key = os.environ.get("NINEROUTER_API_KEY")
    if (not api_key or not 16 <= len(api_key) <= 256
            or any(char not in _KEY_CHARS for char in api_key)):
        raise RuntimeError("AI_TRANSPORT_NOT_CONFIGURED")
    uri = "data:image/png;base64," + base64.b64encode(image_png).decode("ascii")
    messages = envelope.get('messages')
    if (not isinstance(messages, list) or len(messages) != 2
            or [m.get('role') for m in messages if isinstance(m, dict)] != ['system', 'user']):
        raise ValueError('AI_VISION_REQUEST_INVALID')
    system = messages[0].get('content', '') if isinstance(messages[0], dict) else ''
    user_content = messages[1].get('content', {}) if isinstance(messages[1], dict) else {}
    task = user_content.get('task', {}) if isinstance(user_content, dict) else {}
    instruction = str(envelope.get('instructionVersion', ''))
    body = {
        "model": _FIXED_MODEL,
        "reasoning": {"effort": route.reasoning_effort},
        "max_output_tokens": max_output_tokens,
        "stream": True,
        "input": [{
            "role": "user",
            "content": [
                {"type": "input_text",
                 "text": (f"{system}\n{instruction}\n"
                          "This image is one raster page rendered from a real local PDF. "
                          "Do not use or assume a text layer or OCR. Transcribe only visible "
                          "content as strict page-extract-v1 JSON. "
                          f"Page task: {json.dumps(task, ensure_ascii=False)[:1200]}")},
                {"type": "input_image", "image_url": uri},
            ],
        }],
    }
    raw = json.dumps(body).encode("utf-8")
    connection = http.client.HTTPConnection(
        parsed.hostname or "127.0.0.1", parsed.port or 80,
        timeout=float(timeout_seconds))
    started = time.monotonic()
    try:
        connection.connect()
        _set_remaining_timeout(connection, started + float(timeout_seconds))
        connection.request(
            "POST", _FIXED_PATH, body=raw,
            headers={"Content-Type": "application/json",
                     "Authorization": "Bearer " + api_key})
        _set_remaining_timeout(connection, started + float(timeout_seconds))
        response = connection.getresponse()
        provider_request_id = response.getheader("x-request-id")
        if response.status != 200:
            raise HttpFailure(response.status)
        content_type = (response.getheader("Content-Type") or "")
        if "text/event-stream" not in content_type:
            raise ValueError("AI_RESPONSE_INVALID")
        deadline = started + float(timeout_seconds)
        text, status, usage = _read_sse(
            response, connection=connection, deadline=deadline,
            max_output_tokens=max_output_tokens)
    except HttpFailure:
        raise
    except TimeoutError:
        raise
    except (OSError, http.client.HTTPException) as exc:
        raise TimeoutError(str(type(exc).__name__)) from None
    finally:
        try:
            connection.close()
        except Exception:  # noqa: BLE001 - close must not mask result
            pass
    elapsed = time.monotonic() - started
    if not (elapsed == elapsed and 0 <= elapsed <= 300):
        raise ValueError("AI_VISION_REQUEST_INVALID")
    return {"status": status, "text": text, "usage": usage,
            "elapsed_seconds": elapsed,
            "provider_request_id": provider_request_id}


def _set_remaining_timeout(
    connection: http.client.HTTPConnection, deadline: float,
    response: Any = None,
) -> None:
    remaining = deadline - time.monotonic()
    if remaining <= 0:
        raise TimeoutError("AI_DEADLINE_EXCEEDED")
    sock = getattr(connection, 'sock', None)
    if sock is None and response is not None:
        inner = getattr(getattr(response, 'fp', None), 'raw', None)
        sock = getattr(inner, '_sock', None)
    setter = getattr(sock, 'settimeout', None)
    if callable(setter):
        setter(remaining)
    else:
        connection.timeout = remaining


def _read_sse(response, *, connection, deadline: float, max_output_tokens: int) -> tuple[str, str, dict[str, Any]]:
    text_parts: list[str] = []
    text_len = 0
    status = "incomplete"
    usage: dict[str, Any] = {}
    buffer = b""
    total_read = 0
    terminal_seen = False
    while True:
        if time.monotonic() >= deadline:
            raise TimeoutError("AI_DEADLINE_EXCEEDED")
        _set_remaining_timeout(connection, deadline, response=response)
        try:
            chunk = response.read1(65536)
        except (OSError, http.client.HTTPException):
            raise TimeoutError("AI_TRANSPORT_TIMEOUT") from None
        if time.monotonic() >= deadline:
            raise TimeoutError("AI_DEADLINE_EXCEEDED")
        if not chunk:
            break
        total_read += len(chunk)
        if total_read > _MAX_STREAM_BYTES:
            raise ValueError("AI_OUTPUT_TOO_LARGE")
        buffer += chunk
        if len(buffer) > _MAX_STREAM_BYTES:
            raise ValueError("AI_OUTPUT_TOO_LARGE")
        # Normalize CRLF/CR so split frames cannot evade the parser.
        buffer = buffer.replace(b"\r\n", b"\n").replace(b"\r", b"\n")
        while b"\n\n" in buffer:
            frame, buffer = buffer.split(b"\n\n", 1)
            for line in frame.split(b"\n"):
                line = line.strip()
                if line.startswith(b"data:"):
                    payload = line[5:].strip()
                elif line == b"data":
                    payload = b""
                else:
                    continue
                try:
                    event = json.loads(payload.decode("utf-8"))
                except (ValueError, UnicodeDecodeError):
                    continue
                if not isinstance(event, dict):
                    continue
                kind = event.get("type")
                if kind == "response.output_text.delta":
                    delta = event.get("delta", "")
                    if isinstance(delta, str) and delta:
                        text_parts.append(delta)
                        text_len += len(delta)
                        if text_len > max_output_tokens * 64:
                            raise ValueError("AI_OUTPUT_TOO_LARGE")
                elif kind in ("response.completed", "response.failed",
                              "response.incomplete"):
                    payload = event.get("response") or {}
                    if not isinstance(payload, dict):
                        raise ValueError("AI_RESPONSE_INVALID")
                    if isinstance(payload.get("usage"), dict):
                        usage = payload["usage"]
                    inner = str(payload.get("status") or "")
                    if kind == "response.completed" and inner == "completed":
                        status = "completed"
                    elif kind == "response.failed":
                        status = "failed"
                    else:
                        status = "incomplete"
                    terminal_seen = True
                    if kind != "response.completed":
                        return "".join(text_parts), status, usage
                    assembled = _output_text(payload.get("output"))
                    if assembled is not None:
                        if len(assembled) > max_output_tokens * 64:
                            raise ValueError("AI_OUTPUT_TOO_LARGE")
                        if text_parts and assembled != "".join(text_parts):
                            raise ValueError("AI_RESPONSE_INVALID")
                        text_parts = [assembled]
                        text_len = len(assembled)
                    elif not text_parts:
                        raise ValueError("AI_RESPONSE_INVALID")
                    return "".join(text_parts), status, usage
    if not terminal_seen:
        return "".join(text_parts), status, usage
    return "".join(text_parts), status, usage


def _output_text(output: object) -> str | None:
    if not isinstance(output, list):
        return None
    pieces: list[str] = []
    for item in output:
        if not isinstance(item, dict) or item.get("type") != "message":
            continue
        content = item.get("content")
        if not isinstance(content, list):
            continue
        for part in content:
            if isinstance(part, dict) and part.get("type") == "output_text":
                text = part.get("text")
                if not isinstance(text, str):
                    raise ValueError("AI_RESPONSE_INVALID")
                pieces.append(text)
    return "".join(pieces) or None
