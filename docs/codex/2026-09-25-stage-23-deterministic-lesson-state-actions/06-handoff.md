# Handoff

## Outcome
Stage 23 adds one deterministic local-first learner-state action: footer actions are validated, applied as new versioned `LearnerState` projections, and queued as one pending `SyncOperation` in the same Drift transaction. No scheduler, network, or UI mutation happens here.

## Changed Artifacts
- `packages/trace_domain/lib/src/models/learner_state_action.dart`: typed action enum, request, and receipt.
- `packages/trace_domain/lib/trace_domain.dart`: exports the new contract.
- `packages/trace_data/lib/src/local/local_lesson_repository.dart`: transactional `applyStateAction` with idempotent replay and fail-closed reuse.
- `packages/trace_data/test/local_lesson_state_action_test.dart`: seven focused action/replay/conflict/identity tests.
- Stage 23 task docs in `docs/codex/2026-09-25-stage-23-deterministic-lesson-state-actions/`.

## How To Continue
- Stage 24 can attach deterministic review scheduling to the stored action receipt.
- Flutter footer/chat wiring should call `applyStateAction` once per tapped action and reuse the same action ID on retry.
- Oplog replay remains bounded to local queueing; server push/replay is outside this slice.

## Done
- Domain contract created and exported.
- Repository implementation preserves history, returns original receipts on replay, and refuses conflicting reuse.
- Focused and full suites pass with no regressions.

## Remaining
- None for Stage 23; slice committed in a1ad434.
- UI/chat binding, review scheduling, sync push, and device runtime proof remain for later stages.

## Verification
- Data 84, domain 106, design 12, app 35, and gateway 50 tests passed.
- `flutter analyze --no-pub` passed in `trace_data` and `trace_domain`.
