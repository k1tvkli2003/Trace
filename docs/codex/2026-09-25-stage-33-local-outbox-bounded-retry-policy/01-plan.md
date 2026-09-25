# Plan

## Approach
Vertical tracer bullet on `LocalOplogRepository`: one RED retry-policy test, then the minimal bounded `requeueFailed` extension plus a pure `canRequeue` predicate. No schema change, no migration, no transport.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | `test/local_oplog_retry_policy_test.dart` written RED; committed slice `7ad54cc`. |
| 2 | done | Focused test failed on missing-API not typo. |
| 3 | done | `requeueFailed(id, {maxRetries = 5})` bound + `canRequeue` helper implemented. |
| 4 | done | GREEN focused test, then full suites, analyzers, format, validator recorded in `05-verification.md`; record close pending commit. |

## Interfaces and Artifacts
- `LocalOplogRepository.requeueFailed(String id, {int maxRetries = 5})`: `failed -> pending` only when `retryCount <= maxRetries`; otherwise throws `StateError` and leaves the row `failed`.
- `LocalOplogRepository.canRequeue(SyncOperation operation, {int maxRetries = 5})`: static/pure eligibility (`syncState == failed && retryCount <= maxRetries && maxRetries >= 0` validated).
- `packages/trace_data/test/local_oplog_retry_policy_test.dart`: exhausted budget stays failed; budget respected on requeue; invalid budget fails closed; pure helper agrees with stored rows.
- Task docs `2026-09-25-stage-33-local-outbox-bounded-retry-policy/00`–`06`, `_index.md`.

## Risks
- Overloading `requeueFailed` signature breaks Stage31 callers: mitigate with optional named parameter defaulting to current unbounded-safe value semantics only when callers opt in — existing no-arg calls keep compiling but now enforce the default budget of 5 (documented behavior change, tested).
- Clock-based backoff temptation: rejected; no `DateTime.now()` in this slice — budget only, delay policy is a later stage.

## Acceptance Checks
- `dart test test/local_oplog_retry_policy_test.dart` RED then GREEN.
- `dart test` data + domain, `flutter test --no-pub`, Gateway unittest all pass.
- `dart analyze`, `flutter analyze --no-pub`, `dart format` check, `validate_task_docs.py`, `git diff --check` clean.
