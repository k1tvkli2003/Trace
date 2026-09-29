# State

- Current status: `ready-for-review`
- Last updated: 2026-09-29
- Owner: Hermes

## Current State
At baseline `ac778b9`, the response/stream phase used the original
5-second socket timeout even after 2 seconds elapsed. Stage83 first RED
failed with waits `[5.0, 5.0]`, expected `[3.0, 2.0]`. Initial commit
`e5a1802` passed targeted 13/13 and full gateway 96/96. Follow-up RED
found three edge gaps: deadline exhaustion before header wait still waited,
`HTTPResponse` could detach the socket from `HTTPConnection`, and a late
terminal frame could be accepted after deadline. Transport now fails closed
before an expired wait, refreshes detached response socket, and rejects
late frames. Current targeted 16/16 and full gateway 99/99 OK. A local
loopback healthy request completed and a stalled header timed out in 1.00s
with a 1s budget. No provider call.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-29 | Use one monotonic deadline and refresh only socket wait at each phase | Prevent each blocking phase from receiving a fresh full timeout | RED regression plus `nine_router_transport.py` trace |
| 2026-09-29 | Keep single attempt and route unchanged | Unknown provider outcome must not be retried blindly | `budget.py` 113-116; user model rule |

## Blockers
- None for this slice. Live model capture not authorized in this turn.

## Done
- Initial RED/GREEN `e5a1802`: waits `[5.0, 5.0]` to `[3.0, 2.0]`,
  targeted 13/13, full gateway 96/96.
- Edge RED/GREEN: expired-deadline wait rejected, detached socket waits
  `[3.0, 2.0]`, late completion rejected; targeted 16/16, full 99/99.

## Remaining
- Correction committed at `93f5c21`; validator `OK`, workdir/cached `diff --check` clean.
- Deadline clock granularity, response-header correlation, and provider SSE
  timing remain open; not claimed by this slice.
- Separate tasks: cross-process idempotency, operation retention policy,
  real-PDF schema-valid pilot, concurrent-tab runtime proof, signing.
