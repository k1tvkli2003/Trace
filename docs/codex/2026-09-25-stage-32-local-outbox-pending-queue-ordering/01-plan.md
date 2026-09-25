# Plan

## Approach
TDD vertical tracer bullet: one failing queue-ordering test for a new `listReadyToClaim` reader, then the smallest Drift query using the existing `(syncState, createdAt)` index, no schema change.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Failing `local_oplog_queue_test.dart` written; committed slice `be22ee3`. |
| 2 | done | RED confirmed missing API not typo. |
| 3 | done | `listReadyToClaim({int limit})` added to `LocalOplogRepository`. |
| 4 | done | GREEN focused test, then full data/domain/app/Gateway suites and analyzers recorded in `05-verification.md`. |
| 5 | done | Format, docs, validator, commit; record close pending commit. |

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
