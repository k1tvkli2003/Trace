# Plan

## Approach
Use strict TDD. Add a focused test describing caller-owned due-time filtering over existing failed rows. Confirm RED because no due-ready API exists. Implement the smallest read-only method: validate UTC `nowUtc` and every selected due value, filter failed rows within retry budget, keep only `dueAt <= now`, and preserve queue ordering. Run focused and full suites, then close docs and commit.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | active | Write Stage42 docs and focused RED test. |
| 2 | planned | Add minimal due-ready repository method. |
| 3 | planned | Run focused/full verification and independent review. |
| 4 | planned | Finalize docs, validate, scan, commit. |

## Interfaces and Artifacts
- `LocalOplogRepository.listDueFailedWithinBudget({required Map<String, String> dueAtUtcByOperationId, required String nowUtc, int maxRetries = 5})`.
- `packages/trace_data/test/local_oplog_due_ready_test.dart`.
- Stage42 task docs and `_index.md`.

## Risks
- Due map has no persisted provenance. Keep it caller-owned and explicit; do not claim durable scheduling.
- Map may contain unrelated or malformed values. Validate only candidate failed rows and fail closed on malformed selected input.

## Acceptance Checks
- Due equality is included.
- Future, absent, non-failed, and over-budget rows are excluded.
- Output order is `createdAt`, then `operationId`.
- Invalid UTC/budget input throws before mutation; method is read-only.
- Data/domain/app/Gateway tests, analyzers, format, docs validator, diff and secret/static scans pass.
