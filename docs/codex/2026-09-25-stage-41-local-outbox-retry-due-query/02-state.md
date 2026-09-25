# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
`listFailedWithinBudget` + `nextRetryAtUtc` added and GREEN. Full
suites pass: data 150/150, domain 114/114, app 41/41, Gateway 50.
Analyzers and format clean. Next: validator, scans, commit.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Read-only listing + pure due-time math; no clock/schema/scheduler in this slice | Due evaluation needs a clock owner and `failedAt` storage, neither exists yet | repo evidence (`trace_database.dart`, `local_oplog_repository.dart`) |
| 2026-09-25 | Reuse `retryDelay` ladder and `<=` budget semantics from `canRequeue` | One budget rule across read and write paths | Stage33/34 tests |

## Blockers
- None

## Done
- Failing test written first; RED confirmed (both members undefined).
- Minimal `listFailedWithinBudget` + `nextRetryAtUtc`; focused 4/4 GREEN.
- Data 150/150, domain 114/114, app 41/41, Gateway 50; analyzers clean.

## Remaining
- None for this record; committed in `4e7f509` ancestor of HEAD.
