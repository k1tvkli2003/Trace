# Stage 82 vision concurrency transient content-type mapbound

- Task ID: `2026-09-29-stage-82-vision-concurrency-transient-content-type-mapbound`
- Status: `ready-for-review`
- Created: 2026-09-29
- Language: en

## Request
Fix the remaining P1 concurrency defect from review `deleg_84e1109a` that Stage81
deferred, plus the small bounded follow-ups: transient-failure cache behavior,
dead branches, transport Content-Type check, and operation-map bounds.

## Success Criteria
- `AI_RUN_IN_FLIGHT` / `AI_RETRY_NOT_READY` are never cached as terminal failure.
- Concurrent same-operation duplicate submits once and replays after completion.
- Dead `HttpFailure`/`TimeoutError` branches are removed or mapped to stable codes.
- Transport rejects a non-SSE Content-Type with a stable code.
- The operation map is bounded and documented; `02-state.md` reflects the policy.
- Full gateway suite passes; task docs validate; changes commit cleanly.

## Context
- Review `deleg_84e1109a` P1: adapter caches transient `AI_RUN_IN_FLIGHT` at
  `page_vision.py:214-216`, and state writes at `187/215/251` are unsynchronized.
- Stage81 handoff deferred: lock refactor, dead branches, Content-Type check,
  operation-map bounds, eviction. Stage81 is committed at `bf1f83b`.
- Trust boundary unchanged: server-only, fixed route, env-only key, no OCR.

## In Scope
- `services/ai_gateway/page_vision.py`: transient guard, locked transitions.
- `services/ai_gateway/nine_router_transport.py`: Content-Type check.
- Tests for: transient non-caching, in-flight third caller, duplicate during
  slow validation, Content-Type rejection, failure replay still single-submit.

## Out of Scope
- Route, budget policy, schema, Flutter, sync, live re-proof.
- Raw diagnostic capture of the live schema mismatch.

## Assumptions
- None beyond: `BudgetedRun` remains the second submit gate; adapter is the
  first gate and the failure-cache owner.
