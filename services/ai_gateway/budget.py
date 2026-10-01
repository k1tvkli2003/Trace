"""Server-side, single-run spend guard. No provider/network binding here.

The adapter MUST honor the supplied timeout and max_output_tokens, return a full
result (never partial), and expose actual usage separately for reconciliation.
No credential or book bytes belong in exceptions, client bundles, or logs.
"""
from __future__ import annotations

import hashlib
import math
import threading
import time
from dataclasses import dataclass
from typing import Callable


@dataclass(frozen=True)
class RunLimits:
    max_attempts: int
    max_input_bytes: int
    max_output_tokens: int
    max_elapsed_seconds: float

    def __post_init__(self):
        if min(self.max_attempts, self.max_input_bytes, self.max_output_tokens) < 1:
            raise ValueError('Run limits must be positive')
        if not math.isfinite(self.max_elapsed_seconds) or self.max_elapsed_seconds <= 0:
            raise ValueError('Run deadline must be finite and positive')
        if (self.max_attempts > 2 or self.max_input_bytes > 4_194_304 or
                self.max_output_tokens > 16_384 or self.max_elapsed_seconds > 300):
            raise ValueError('Run policy exceeds hard safety ceiling')


class GatewayFailure(Exception):
    def __init__(self, code: str, *, retryable: bool = False):
        super().__init__(code)
        self.code = code
        self.retryable = retryable


class HttpFailure(Exception):
    def __init__(self, status: int, *, retry_after_seconds: float = 0):
        super().__init__(f'HTTP {status}')
        self.status = status
        self.retry_after_seconds = retry_after_seconds


class BudgetedRun:
    """One operation. Explicit calls only; no automatic retry or fallback model."""

    def __init__(self, limits: RunLimits, *, clock: Callable[[], float] = time.monotonic):
        self.limits = limits
        self.clock = clock
        self.deadline = clock() + limits.max_elapsed_seconds
        self.attempts = 0
        self.next_allowed_at = 0.0
        self.fingerprint: bytes | None = None
        self.result: bytes | None = None
        self.terminal_code: str | None = None
        self._lock = threading.Lock()

    def call(self, payload: bytes, max_output_tokens: int,
             provider: Callable[[bytes, int, float], bytes]) -> bytes:
        if not self._lock.acquire(blocking=False):
            raise GatewayFailure('AI_RUN_IN_FLIGHT')
        try:
            return self._call_locked(payload, max_output_tokens, provider)
        finally:
            self._lock.release()

    def _call_locked(self, payload: bytes, max_output_tokens: int,
                     provider: Callable[[bytes, int, float], bytes]) -> bytes:
        if not isinstance(payload, bytes) or not payload or len(payload) > self.limits.max_input_bytes:
            raise GatewayFailure('AI_BUDGET_EXCEEDED')
        if not isinstance(max_output_tokens, int) or not 0 < max_output_tokens <= self.limits.max_output_tokens:
            raise GatewayFailure('AI_BUDGET_EXCEEDED')
        fingerprint = hashlib.sha256(payload + b'\x00' + str(max_output_tokens).encode()).digest()
        if self.fingerprint is not None and fingerprint != self.fingerprint:
            raise GatewayFailure('AI_RUN_CONFLICT')
        if self.result is not None:
            return self.result
        if self.terminal_code is not None:
            raise GatewayFailure(self.terminal_code)
        now = self.clock()
        if now >= self.deadline:
            self.terminal_code = 'AI_DEADLINE_EXCEEDED'
            raise GatewayFailure(self.terminal_code)
        if now < self.next_allowed_at:
            raise GatewayFailure('AI_RETRY_NOT_READY')
        if self.attempts >= self.limits.max_attempts:
            self.terminal_code = 'AI_ATTEMPTS_EXHAUSTED'
            raise GatewayFailure(self.terminal_code)
        self.fingerprint = fingerprint
        self.attempts += 1
        try:
            answer = provider(payload, max_output_tokens, self.deadline - now)
        except HttpFailure as error:
            code = {400: 'AI_BAD_REQUEST', 401: 'AI_UNAUTHORIZED',
                    403: 'AI_FORBIDDEN', 429: 'AI_RATE_LIMITED',
                    500: 'AI_PROVIDER_UNAVAILABLE', 503: 'AI_PROVIDER_UNAVAILABLE'}.get(
                        error.status, 'AI_PROVIDER_FAILURE')
            retryable = error.status in (429, 500, 503) and self.attempts < self.limits.max_attempts
            if retryable:
                delay = error.retry_after_seconds if error.status == 429 else 1.0
                if not math.isfinite(delay) or delay < 0:
                    retryable = False
                else:
                    self.next_allowed_at = self.clock() + max(delay, 0.001)
                    retryable = self.next_allowed_at < self.deadline
            if not retryable:
                self.terminal_code = code
            raise GatewayFailure(code, retryable=retryable) from None
        except TimeoutError:
            # Sending may have succeeded; never retry an unknown outcome blindly.
            self.terminal_code = 'AI_OUTCOME_UNKNOWN'
            raise GatewayFailure(self.terminal_code) from None
        except Exception:
            self.terminal_code = 'AI_PROVIDER_FAILURE'
            raise GatewayFailure(self.terminal_code) from None
        # This byte cap is a second containment layer, not a measured token count.
        if not isinstance(answer, bytes) or len(answer) > max_output_tokens * 64:
            self.terminal_code = 'AI_OUTPUT_TOO_LARGE'
            raise GatewayFailure(self.terminal_code)
        if not answer:
            self.terminal_code = 'AI_EMPTY_RESULT'
            raise GatewayFailure(self.terminal_code)
        if self.clock() >= self.deadline:
            self.terminal_code = 'AI_DEADLINE_EXCEEDED'
            raise GatewayFailure(self.terminal_code)
        self.result = answer
        return answer
