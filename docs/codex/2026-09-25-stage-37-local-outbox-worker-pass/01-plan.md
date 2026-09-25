# Plan

## Approach
TDD tracer: RED focused worker-pass test, minimal GREEN `LocalOutboxWorker.runNext` composing existing repository methods, then full suites, docs, review, commit.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Focused `local_oplog_worker_pass_test.dart` written; RED captured; committed slice `ca1dc15`. |
| 2 | done | `LocalOutboxWorker.runNext` implemented in adjacent file. |
| 3 | done | GREEN focused test; data/domain/app/Gateway suites + format recorded in `05-verification.md`. |
| 4 | done | Docs synced to done; validator; commit; record close pending commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_outbox_worker.dart`: `runNext`
- `packages/trace_data/lib/trace_data.dart`: worker export
- `packages/trace_data/test/local_oplog_worker_pass_test.dart`: focused tests
- `docs/codex/2026-09-25-stage-37-local-outbox-worker-pass/`: task record

## Risks
- Over-scoping into loops/clocks/network; mitigation: single pass, injected handler, no waiting.

## Acceptance Checks
- Focused test RED then GREEN with real commands.
- `dart test`, `dart analyze`, `flutter test --no-pub`, `flutter analyze --no-pub`, Gateway unittest all exit 0.
- Validator OK; `git diff --check` clean.
