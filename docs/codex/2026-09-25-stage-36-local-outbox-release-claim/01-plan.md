# Plan

## Approach
TDD tracer: RED focused release-claim test, minimal GREEN `releaseClaim` on the existing `_transition` helper, then full suites, docs, review, commit.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Focused `local_oplog_release_claim_test.dart` written; RED captured; committed slice `dca85d1`. |
| 2 | done | `releaseClaim(id)` implemented in `LocalOplogRepository`. |
| 3 | done | GREEN focused test; data/domain/app/Gateway suites + format recorded in `05-verification.md`. |
| 4 | done | Docs synced to done; validator; commit; record close pending commit. |

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
