# Plan

## Approach
Tracer bullet on `LocalOplogRepository`: RED test calling missing `claimNext()`, then minimal atomic implementation (select head inside transaction + conditional in_flight write), then full verification.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | `local_oplog_claim_next_test.dart` written; RED captured; committed slice `de5fca3`. |
| 2 | done | `claimNext()` atomic pick-and-claim implemented. |
| 3 | done | GREEN focused test; data/domain/app/Gateway suites + analyzers + format recorded in `05-verification.md`. |
| 4 | done | Docs verification/handoff, validator, commit; record close pending commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: add `Future<SyncOperation?> claimNext()`.
- `packages/trace_data/test/local_oplog_claim_next_test.dart`: new focused test.
- `docs/codex/2026-09-25-stage-35-local-outbox-atomic-claim-next/`: task record.

## Risks
- Concurrent-writer semantics on web/native differ; mitigation: local-only single-writer scope, conditional write fails closed on contention.
- None known beyond that.

## Acceptance Checks
- `dart test test/local_oplog_claim_next_test.dart` GREEN.
- `dart test` + `dart analyze` in trace_data GREEN; domain/app/Gateway suites GREEN.
- `validate_task_docs.py` OK; `git diff --check` clean; reviewer JSON `passed=true`.
