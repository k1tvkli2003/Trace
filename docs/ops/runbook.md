# Runbook (local verification only)

This runbook covers only local verification commands that were actually run for the Stage30 vertical slice. It is not a production, deploy, signing, migration, or incident runbook.

## Prerequisites

- Windows host with the repo at `C:/Users/K1/Desktop/Projects/Trace`.
- Flutter 3.44.0 stable / Dart 3.12.0 baseline (per `tool/target-matrix.md`).
- `flutter doctor -v` reports unaccepted Android SDK licenses; builds passed despite the warning, which must never be read as license acceptance.
- No Supabase project, no CI runner, no device farm is required or used here.

## Local verification commands (as recorded in Stage30)

From `packages/trace_data`:

```text
dart test test/offline_vertical_slice_test.dart
dart test
dart analyze
dart format --output=none --set-exit-if-changed test/offline_vertical_slice_test.dart
```

From `packages/trace_domain`:

```text
dart test
```

From `apps/trace_flutter`:

```text
flutter test --no-pub
flutter analyze --no-pub
```

From the repo root:

```text
python -m unittest discover -s services/ai_gateway -p "test_*.py"
git diff --check
python <work-docs skills dir>/scripts/validate_task_docs.py docs/codex/2026-09-25-stage-30-vertical-slice-proof-and-release-gate --structure-only
```

Expected results for the slice: targeted test exit 0, full data/domain/app suites exit 0, Gateway 50 tests OK, both analyzers clean, targeted format 0 changed, docs validator OK, `git diff --check` clean. The intentional wrong-ID mutation check fails with exit 1 before the fix is restored; that failure is the RED evidence, not a regression.

## Known formatting caveat

App-wide `dart format` reports changes in unrelated pre-existing PDF files under the installed Dart SDK. Leave them unchanged (Stage30 known issue); only the targeted format check above is release-gate evidence.

## Explicitly NOT covered

- Production deploy, release signing/rotation, package distribution, hosting origin.
- Supabase migration, auth provisioning, RLS/storage policy changes.
- CI pipeline operation (no workflow exists), benchmark runs, E2E device/browser runs.
- Incident response and SLOs; on any failure, keep the failing output, restore the tree with `git status` / `git diff --check`, and re-run the failing command only.
