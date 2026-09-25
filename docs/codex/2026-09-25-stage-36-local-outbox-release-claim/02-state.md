# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Stage36 GREEN: `LocalOplogRepository.releaseClaim(id)` moves `in_flight` to `pending` with `retryDelta: 0` via `_transition`. Focused 3/3 GREEN; data 132/132, domain 114/114, app 41/41, Gateway 50 OK; analyzers clean; format clean.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Scope to explicit release `in_flight` to `pending`, `retryDelta: 0` | Smallest crash-recovery fix, no clock | Plan |
| 2026-09-25 | Fail closed on absent/wrong-state rows | Preserve lifecycle invariants | GREEN evidence |
| 2026-09-25 | Reuse `_transition` conditional write | Fail closed on contention, no new write path | GREEN evidence |

## Blockers
- None.

## Done
- RED captured (`releaseClaim` undefined) before implementation.
- GREEN minimal release helper; full suites verified.
- Docs to ready-for-review.

## Remaining
- Validator, `git diff --check`, stage, review, commit.
