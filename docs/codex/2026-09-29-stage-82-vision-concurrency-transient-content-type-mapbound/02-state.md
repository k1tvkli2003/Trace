# State

- Current status: `ready-for-review`
- Last updated: 2026-09-29
- Owner: Codex

## Current State
Stage82 is committed at `2006021` on top of Stage81 `bf1f83b`. Transient codes
`AI_RUN_IN_FLIGHT` and `AI_RETRY_NOT_READY` are never stored in `state.failure`.
`state.result` and terminal `state.failure` writes go through the adapter lock.
Transport rejects a non-SSE Content-Type with `AI_RESPONSE_INVALID`. The
in-process operation map stops at `_MAX_OPERATIONS = 1024` with
`AI_OPERATION_LIMIT_EXCEEDED`. Targeted tests `27/27`, full gateway suite `95/95`.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-29 | Transient codes `AI_RUN_IN_FLIGHT` / `AI_RETRY_NOT_READY` must never enter `state.failure` | A busy signal is not an outcome; caching it poisons later callers | review `deleg_84e1109a` P1 |
| 2026-09-29 | State transitions (`result`/`failure`) assigned under the adapter guard | Reads are under `_lock` today; writes must match | review `deleg_84e1109a` P1/P2 |
| 2026-09-29 | Transport checks SSE Content-Type with a stable code | Review P3; fail-closed on wrong content type | review `deleg_84e1109a` |

## Blockers
- None.

## Done
- Transient codes stay out of the terminal failure cache.
- Failure and result writes are locked.
- Non-SSE Content-Type is rejected fail-closed.
- Operation map is bounded. Committed at `2006021`.

## Remaining
- Dead `HttpFailure`/`TimeoutError` adapter branches, post-deadline completion
  policy, operation eviction policy, and live capture need an explicit order.
