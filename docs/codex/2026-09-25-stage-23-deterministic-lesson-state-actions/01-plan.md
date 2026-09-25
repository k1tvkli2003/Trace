# Plan

## Approach
Use a small vertical TDD slice in the existing Drift boundary. Add a typed domain action request and receipt, then add `LocalLessonRepository.applyStateAction` as one transaction: validate current state and identity, derive next projection, append one `SyncOperation`, and upsert a versioned learner-state row. Same action ID + same payload replays; same ID + different payload fails. No scheduler or network code.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | completed | Capture Stage 23 scope and inspect existing state/oplog contracts. |
| 2 | completed | Tests cover studied, replay, conflict, identity, stale time, and no-write failure. |
| 3 | completed | Domain action contract and local transactional repository method implemented. |
| 4 | completed | Focused/full suites and analysis pass; handoff docs updated. |
| 5 | completed | Committed in a1ad434; HEAD also carries Stage25 extension 9c33f6c on same files. |

## Interfaces and Artifacts
- Create: `packages/trace_domain/lib/src/models/learner_state_action.dart`
- Export: `packages/trace_domain/lib/trace_domain.dart`
- Modify: `packages/trace_data/lib/src/local/local_lesson_repository.dart`
- Tests: `packages/trace_data/test/local_lesson_state_action_test.dart`
- Docs: this task folder and `docs/codex/_index.md`

## Risks
- Existing learner-state IDs are immutable in current repository code; action method must create versioned projection IDs without deleting history.
- Oplog payload identity and content hash must match canonical `SyncOperation`, not ad-hoc JSON.
- Review schedule must not be silently created here; Stage 24 owns it.

## Acceptance Checks
- Focused action tests pass with an in-memory Drift database.
- Duplicate identical action is a no-op/replay receipt; conflicting ID fails closed.
- Transaction rollback leaves no learner-state or oplog row after a forced conflict.
- Existing domain/data suites remain green.
- `dart format`, `flutter analyze --no-pub`, docs validation, and `git diff --check` pass.
