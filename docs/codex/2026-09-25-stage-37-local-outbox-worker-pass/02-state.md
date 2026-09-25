# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Stage37 GREEN: `LocalOutboxWorker.runNext({handler, maxRetries})` claims the queue head and settles locally (success to `synced`, failure to `failed` then `pending` within budget, exhausted stays `failed`, empty returns `null`). Focused 4/4 GREEN; data 136/136, domain 114/114, app 41/41, Gateway 50 OK; analyzers clean; format clean.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Single explicit `runNext`, injected `Future<bool> Function(SyncOperation)` handler | Smallest composition without loop/clock/network | GREEN evidence |
| 2026-09-25 | Handler throw leaves claim `in_flight` for explicit `releaseClaim` | No hidden catch; crash recovery already explicit in Stage36 | GREEN evidence |
| 2026-09-25 | Reuse `claimNext`/`acknowledge`/`recordFailure`/`requeueFailed`/`canRequeue` | No new transition path, budget rule unchanged | GREEN evidence |

## Blockers
- None.

## Done
- RED captured (`LocalOutboxWorker` undefined) before implementation.
- GREEN minimal worker + export; full suites verified.
- Docs to ready-for-review.

## Remaining
- Validator, `git diff --check`, stage, review, commit.
