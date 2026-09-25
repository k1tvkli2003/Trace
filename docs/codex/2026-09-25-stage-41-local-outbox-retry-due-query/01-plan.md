# Plan

## Approach
TDD tracer bullet: one failing test file first (RED: both members
missing), then minimal repository addition (GREEN), then full suites
and docs. No refactor of existing paths.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Task docs filled; committed `4e7f509`. |
| 2 | done | `local_oplog_retry_due_test.dart` written; RED watched (both members undefined). |
| 3 | done | `listFailedWithinBudget` + `nextRetryAtUtc` added; focused 4/4 GREEN. |
| 4 | done | Data/domain/app/Gateway suites + analyzers + format recorded in `05-verification.md`. |
| 5 | done | State/progress/verification/handoff finalized; validator OK; record closes with this commit. |

## Interfaces and Artifacts
- `LocalOplogRepository.listFailedWithinBudget({maxRetries = 5})`
- `LocalOplogRepository.nextRetryAtUtc({failedAtUtc, retryCount, baseDelay, maxDelay})`
- `packages/trace_data/test/local_oplog_retry_due_test.dart`
- `docs/codex/2026-09-25-stage-41-local-outbox-retry-due-query/`

## Risks
- Budget filter must stay consistent with `canRequeue` (`<=`); test pins it.
- `retryCount` is payload-embedded, so filtering is post-mapping; document it.

## Acceptance Checks
- Focused test file GREEN; `dart test` data, `dart test` domain,
  `flutter test --no-pub`, Gateway unittest all pass.
- `validate_task_docs.py` OK; secret/static scans clean.
