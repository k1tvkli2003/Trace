# Plan

## Approach
Use strict TDD. Add a focused test describing caller-owned due requeue over existing failed rows. Confirm RED because no due-requeue API exists. Implement the smallest composing transition: reuse `listDueFailedWithinBudget` for selection, then `requeueFailed` per row so budget and wrong-state checks stay single-sourced. Run focused and full suites, then close docs and commit.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | active | Write Stage43 docs and focused RED test. |
| 2 | planned | Add minimal due-requeue repository method. |
| 3 | planned | Run focused/full verification and independent review. |
| 4 | planned | Finalize docs, validate, scan, commit. |

## Interfaces and Artifacts
- `LocalOplogRepository.requeueDueFailedWithinBudget({required String nowUtc, required Map<String, String> dueAtUtcByOperationId, int maxRetries = 5})`.
- `packages/trace_data/test/local_oplog_due_requeue_test.dart`.
- Stage43 task docs and `_index.md`.

## Risks
- Batch transition could partially apply. Mitigate by validating all input through the read-only filter first, then transitioning one row at a time with the same single-row checks.
- Due map has no persisted provenance. Keep it caller-owned and explicit; do not claim durable scheduling.

## Acceptance Checks
- Due rows within budget become `pending` with `retryCount` untouched; returned in `createdAt` then `operationId` order.
- Future, missing-due, non-failed, and over-budget rows stay `failed`/`pending` as before.
- Invalid UTC/budget input throws before any transition.
- Data/domain/app/Gateway tests, analyzers, format, docs validator, diff and secret/static scans pass.
