# Plan

## Approach
Tracer on `LocalOplogRepository`: RED focused test for a pure `retryDelay(retryCount, ...)` rule, then minimal static helper with exponential growth, cap, and budget validation. No DB write, no clock, no migration.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Focused failing test `local_oplog_backoff_test.dart` written; committed slice `7d869ed`. |
| 2 | done | RED exit nonzero for the missing symbol verified. |
| 3 | done | Minimal pure `retryDelay` + cap validation implemented. |
| 4 | done | GREEN focused + data/domain/app/Gateway suites recorded in `05-verification.md`; record close pending commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `retryDelay` static helper.
- `packages/trace_data/test/local_oplog_backoff_test.dart`: focused policy test.
- `docs/codex/2026-09-25-stage-34-local-outbox-retry-backoff-policy/`: task record.

## Risks
- Overfitting delay constants to one caller: keep base/cap parameters explicit.
- Clock-based flakiness: none, policy is pure input-to-duration.

## Acceptance Checks
- `dart test test/local_oplog_backoff_test.dart` RED then GREEN.
- `dart test` + `dart analyze` in trace_data and trace_domain GREEN.
- `flutter test --no-pub` + `flutter analyze --no-pub` in trace_flutter GREEN.
- Gateway `python -m unittest discover` GREEN; format/diff checks clean.
