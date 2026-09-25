# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-25 | active | Task docs created; brief/plan/state written. | docs/codex/2026-09-25-stage-41-local-outbox-retry-due-query/00-brief.md |
| 2026-09-25 | active | Failing test written; RED confirmed (both members undefined). | packages/trace_data/test/local_oplog_retry_due_test.dart |
| 2026-09-25 | active | Minimal `listFailedWithinBudget` + `nextRetryAtUtc` added; focused 4/4 GREEN, format clean. | packages/trace_data/lib/src/local/local_oplog_repository.dart |
| 2026-09-25 | ready-for-review | Full suites GREEN: data 150/150, domain 114/114, app 41/41, Gateway 50; analyzers clean. | 05-verification.md |

## Done So Far
- TDD loop complete: RED -> GREEN -> suites.
- Read-only retry-candidate listing with deterministic order.
- Pure UTC failure-time to next-retry mapping on the Stage34 ladder.

## Next
- Done: slice committed in `4e7f509` ancestor of HEAD; local-only record closes here.
