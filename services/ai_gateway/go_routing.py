"""Trace 9Router Muse Spark routing policy. Offline; no provider call."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable


_CAPABILITIES = frozenset({
    'structure_scan', 'page_vision_extract', 'slice_planner', 'teacher_fa',
    'coach', 'review_generator_optional',
})
_VISION_CAPABILITIES = frozenset({'structure_scan', 'page_vision_extract'})
_ALLOWED_MODELS = ('ocz/muse-spark-1.3-contributor-free',)
_ALLOWED_EFFORTS = ('high', 'xhigh')
_ENDPOINT = 'http://127.0.0.1:20128/v1/responses'


class RouteFailure(Exception):
    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


@dataclass(frozen=True)
class NineRouterRoute:
    provider: str
    model: str
    endpoint: str
    reasoning_effort: str
    accepts_images: bool
    accepts_pdf: bool


class NineRouterRouting:
    """Fail closed on model/provider overrides; 9Router rotates OpenCode proxies."""

    def __init__(self, *, models: Iterable[str] = _ALLOWED_MODELS,
                 endpoint_override: str | None = None,
                 reasoning_effort: str = 'high'):
        configured = tuple(models)
        if (endpoint_override is not None or configured != _ALLOWED_MODELS
                or reasoning_effort not in _ALLOWED_EFFORTS):
            raise RouteFailure('AI_ROUTE_NOT_ALLOWED')
        self.reasoning_effort = reasoning_effort

    def resolve(self, capability: str) -> NineRouterRoute:
        if capability not in _CAPABILITIES:
            raise RouteFailure('AI_CAPABILITY_NOT_ALLOWED')
        model = _ALLOWED_MODELS[0]
        return NineRouterRoute(
            provider='9router',
            model=model,
            endpoint=_ENDPOINT,
            reasoning_effort=self.reasoning_effort,
            accepts_images=capability in _VISION_CAPABILITIES,
            accepts_pdf=False,
        )


# Compatibility alias for callers that only need the generic route type.
Route = NineRouterRoute
