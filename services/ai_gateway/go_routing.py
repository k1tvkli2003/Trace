"""Trace 9Router MiMo-only routing policy. Offline; no provider call."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable


_CAPABILITIES = frozenset({
    'structure_scan', 'page_vision_extract', 'slice_planner', 'teacher_fa',
    'coach', 'review_generator_optional',
})
_VISION_CAPABILITIES = frozenset({'structure_scan', 'page_vision_extract'})
_ALLOWED_MODELS = ('oc/mimo-v2.6-flash-free', 'ocz/mimo-v2.6-flash-free')
_ENDPOINT = 'http://127.0.0.1:20128/v1/chat/completions'


class RouteFailure(Exception):
    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


@dataclass(frozen=True)
class NineRouterRoute:
    provider: str
    model: str
    endpoint: str
    accepts_images: bool
    accepts_pdf: bool


class NineRouterRouting:
    """Fail-closed local route with deterministic oc/ocz round-robin."""

    def __init__(self, *, models: Iterable[str] = _ALLOWED_MODELS,
                 endpoint_override: str | None = None):
        configured = tuple(models)
        if endpoint_override is not None or configured != _ALLOWED_MODELS:
            raise RouteFailure('AI_ROUTE_NOT_ALLOWED')
        self._next_index = 0

    def resolve(self, capability: str) -> NineRouterRoute:
        if capability not in _CAPABILITIES:
            raise RouteFailure('AI_CAPABILITY_NOT_ALLOWED')
        model = _ALLOWED_MODELS[self._next_index]
        self._next_index = (self._next_index + 1) % len(_ALLOWED_MODELS)
        return NineRouterRoute(
            provider='9router',
            model=model,
            endpoint=_ENDPOINT,
            accepts_images=capability in _VISION_CAPABILITIES,
            accepts_pdf=False,
        )


# Compatibility alias for callers that only need the generic route type.
Route = NineRouterRoute
