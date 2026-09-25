# Plan

## Approach
TDD vertical tracer bullet: one failing queue-ordering test for a new `listReadyToClaim` reader, then the smallest Drift query using the existing `(syncState, createdAt)` index, no schema change.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Write failing `local_oplog_queue_test.dart`: pending-only, createdAt then operationId order, limit bound, invalid limit fail-closed, empty queue |
| 2 | planned | Run RED, confirm failure is missing API not typo |
| 3 | planned | Add `listReadyToClaim({int limit})` to `LocalOplogRepository` |
| 4 | planned | Run GREEN focused test, then full data/domain/app/Gateway suites and analyzers |
| 5 | planned | Format, docs, validator, commit |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: add `listReadyToClaim`
- `packages/trace_data/test/local_oplog_queue_test.dart`: new focused test
- `docs/codex/2026-09-25-stage-32-local-outbox-pending-queue-ordering/`: task record

## Risks
- Ordering by text `createdAt` relies on UTC ISO-8601 already enforced by `SyncOperation.fromJson`; test uses zero-padded timestamps so lexicographic order equals time order.
- No concurrency claim here: reader returns candidates; claiming stays on Stage31 conditional write.

## Acceptance Checks
- RED observed before implementation.
- GREEN focused test plus data 114+, domain 114+, app 41, Gateway 50 suites pass with clean analyzers.
- `git diff --check`, format check, and docs validator clean.
