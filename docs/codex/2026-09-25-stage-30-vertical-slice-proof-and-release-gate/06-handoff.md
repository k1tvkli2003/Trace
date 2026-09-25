# Handoff

## Outcome
Offline vertical-slice proof is green. Existing local repositories already
cover the loop: Markdown import -> page/block/citation -> validated Persian
lesson -> learner state -> deterministic review -> cached replay ->
highlight/note backlink.

## Changed Artifacts
- Added: `packages/trace_data/test/offline_vertical_slice_test.dart`
- No production files changed; RED required no new wiring.
- Stage30 task docs updated in this folder.
- `docs/codex/_index.md` links this task as `ready-for-review`.

## How To Continue
1. Run `dart test test/offline_vertical_slice_test.dart` from `packages/trace_data`.
2. Run full data/domain/app/Gateway suites before release work.
3. Add genuine release-gate artifacts only when their owners exist:
   acceptance matrix, runbook, CI workflow, benchmarks, E2E, Supabase, and
   native/device/browser proofs.

## Done
- Test-first proof written, RED-verified, and GREEN-verified.
- Suites, analyzer, formatter, docs validator, and `git diff --check` run.
- No AvalAI/OpenHUB use; `StudyHub-Web` untouched.

## Remaining
- CI workflow, acceptance matrix, runbook, benchmarks, E2E fixtures.
- Supabase/auth/sync proof.
- Android/Windows/Web release builds and persistence/device evidence.
- PDF Vision fidelity and live AI route pilot.
- Target matrix release readiness beyond scaffold smoke.

## Verification
- `dart test test/offline_vertical_slice_test.dart`: pass (`TERMINAL_EXIT=0`).
- Full data `dart test`: pass (`TERMINAL_EXIT=0`).
- Full domain `dart test`: pass (`TERMINAL_EXIT=0`).
- Gateway `unittest discover`: 50 tests OK.
- `flutter test --no-pub`: pass (`TERMINAL_EXIT=0`).
- `flutter analyze --no-pub`: clean.
- Data targeted formatter: 0 changed.
- App formatter reports unrelated pre-existing drift; left untouched.
