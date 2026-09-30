# Stage84 vision operation retention eviction

- Task ID: `2026-09-29-stage84-vision-operation-retention-eviction`
- Status: `done`
- Created: 2026-09-29
- Language: en

## Request
Close the Stage82 leftover: the in-process operation map stops at
`_MAX_OPERATIONS = 1024` with `AI_OPERATION_LIMIT_EXCEEDED` and never
releases entries, so a long-lived process eventually denies all new
operations. Define and implement a retention eviction policy.

## Success Criteria
- Map stays bounded at `_MAX_OPERATIONS = 1024`.
- A new operation is accepted after evicting the oldest terminal entry.
- In-flight operations are never evicted; single submission preserved.
- Retained entries keep exact replay (same `request_id`, no resubmit).
- Targeted `test_page_vision` plus full gateway suite green.
- Task docs validator `OK`, `git diff --check` clean, one commit.

## Context
- Owner: `services/ai_gateway/page_vision.py` (`VisionAdapter._operations`).
- Baseline HEAD `31eeb98`; Stage82 state/handoff defer eviction explicitly.
- No network, provider, retry, or route change in this slice.

## In Scope
- FIFO eviction of oldest terminal (result or failure) entries only.
- In-flight guard so no entry with an active user is removed.
- RED-first tests for eviction and in-flight safety.
- Task docs plus `_index.md` row.

## Out of Scope
- Cross-process idempotency, TTL/clock retention, persistent cache.
- Live model capture, provider timing, real-PDF pilot.
- Changes to `budget.py`, `nine_router_transport.py`, retry rules, route.

## Assumptions
- RAM-only replay contract stands: an evicted entry resubmits once on
  next use with a fresh `request_id`. Retention loss is documented, not
  silent: eviction order is FIFO terminal-first and stated in docs.
