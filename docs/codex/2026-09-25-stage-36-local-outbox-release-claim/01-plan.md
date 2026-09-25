# Plan

## Approach
TDD tracer: RED focused release-claim test, minimal GREEN `releaseClaim` on the existing `_transition` helper, then full suites, docs, review, commit.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Write focused `local_oplog_release_claim_test.dart`; run RED |
| 2 | planned | Implement `releaseClaim(id)` in `LocalOplogRepository` |
| 3 | planned | GREEN focused test; run data/domain/app/Gateway suites + format |
| 4 | planned | Docs to ready-for-review; validator; stage; review; commit |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `releaseClaim`
- `packages/trace_data/test/local_oplog_release_claim_test.dart`: focused tests
- `docs/codex/2026-09-25-stage-36-local-outbox-release-claim/`: task record

## Risks
- Over-scoping into lease/timeout logic; mitigation: explicit release only, no clock.

## Acceptance Checks
- Focused test RED then GREEN with real commands.
- `dart test`, `dart analyze`, `flutter test --no-pub`, `flutter analyze --no-pub`, Gateway unittest all exit 0.
- Validator OK; `git diff --check` clean.
