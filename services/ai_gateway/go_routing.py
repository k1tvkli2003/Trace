"""Offline OpenCode Go-only route contract; not a network client.

Models below have endpoint mappings in the official Go documentation. Routing a
request is not authorization to send private books or to run non-coding traffic.
No key, SDK, fallback or user-set URL belongs in this module.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping


_GO_BASE = 'https://opencode.ai/zen/go/v1/'
# Intentionally small, documented subset. No implicit model selection.
_MODEL_ENDPOINTS: dict[str, tuple[str, bool]] = {
    'glm-5.3-flash': ('chat/completions', False),
    'deepseek-v4-flash-vision-exp': ('chat/completions', True),
    'gpt-5.6-luna': ('responses', False),  # Vision not verified for Go route.
}
_CAPABILITIES = frozenset({
    'structure_scan', 'page_vision_extract', 'slice_planner', 'teacher_fa',
    'coach', 'review_generator_optional',
})
_VISION_CAPABILITIES = frozenset({'structure_scan', 'page_vision_extract'})


class RouteFailure(Exception):
    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


@dataclass(frozen=True)
class GoRoute:
    provider: str
    model: str
    endpoint: str
    accepts_images: bool


class GoRouting:
    def __init__(self, configured: Mapping[str, str] | None = None,
                 *, endpoint_override: str | None = None):
        if endpoint_override is not None:
            raise RouteFailure('AI_ROUTE_NOT_ALLOWED')
        self._configured = dict(configured or {})
        if any(capability not in _CAPABILITIES for capability in self._configured):
            raise RouteFailure('AI_CAPABILITY_NOT_ALLOWED')

    def resolve(self, capability: str) -> GoRoute:
        if capability not in _CAPABILITIES:
            raise RouteFailure('AI_CAPABILITY_NOT_ALLOWED')
        selected = self._configured.get(capability)
        if selected is None:
            raise RouteFailure('GO_MODEL_NOT_CONFIGURED')
        if not isinstance(selected, str) or not selected.startswith('opencode-go/'):
            raise RouteFailure('AI_ROUTE_NOT_ALLOWED')
        model = selected.removeprefix('opencode-go/')
        spec = _MODEL_ENDPOINTS.get(model)
        if spec is None or (capability in _VISION_CAPABILITIES and not spec[1]):
            raise RouteFailure('AI_ROUTE_NOT_ALLOWED')
        return GoRoute('opencode-go', model, _GO_BASE + spec[0], spec[1])
