# State

- Current status: `ready-for-review`
- Last updated: 2026-09-29
- Owner: Codex

## Current State
Stage82 RED started. Stage81 is committed at `bf1f83b` with suite `92/92`.
The exact P1 from the review: a second same-fingerprint caller can pass the
adapter checks while the first is still submitting, hit `BudgetedRun.call`,
get `AI_RUN_IN_FLIGHT`, and have the adapter cache that transient code as a
terminal `state.failure`.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-29 | Transient codes `AI_RUN_IN_FLIGHT` / `AI_RETRY_NOT_READY` must never enter `state.failure` | A busy signal is not an outcome; caching it poisons later callers | review `deleg_84e1109a` P1 |
| 2026-09-29 | State transitions (`result`/`failure`) assigned under the adapter guard | Reads are under `_lock` today; writes must match | review `deleg_84e1109a` P1/P2 |
| 2026-09-29 | Transport checks SSE Content-Type with a stable code | Review P3; fail-closed on wrong content type | review `deleg_84e1109a` |

## Blockers
- None.

## Done
- Task scaffold created; brief and plan written.

## Remaining
- RED tests, GREEN fix, full suite, docs, commit.
