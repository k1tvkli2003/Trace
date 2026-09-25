# Handoff

## Outcome
Highlight anchors now rehydrate through the explicit ordered ladder and detach visibly instead of moving silently. Domain evaluator returns exact, quote, prefix/suffix, bbox-fallback, or absent verdicts; repository exposes read-only `rehydrateAnchor` and explicit `markDetached` with tombstone and locator guards.

## Changed Artifacts
- `packages/trace_domain/lib/src/models/highlight_rehydration.dart`
- `packages/trace_domain/lib/trace_domain.dart`
- `packages/trace_domain/test/highlight_rehydration_test.dart`
- `packages/trace_data/lib/src/local/local_annotation_repository.dart`
- `packages/trace_data/test/highlight_rehydration_test.dart`
- `docs/codex/2026-09-25-stage-27-highlight-anchor-engine/` and `_index.md`

## How To Continue
Run docs validation, then commit this slice. Next: repair flow with a fresh anchor ID that reuses the same quote/prefix/suffix evidence, then selection/repair UI. Do not write new offsets into an existing anchor row.

## Done
- Domain ladder with whitespace-only Persian matching and no Yeh/Kaf rewrite.
- Repository read-only verdict and explicit attached-to-detached transition.
- SQLite tests for exact, moved, detached/repair, and Persian whitespace cases.
- Domain/data/app suites, both analyzes, format, and gateway regression pass.

## Remaining
- Docs validation and commit.
- Fresh-anchor repair flow, annotation UI, sync transport, device/browser proof.

## Verification
- Result partial: domain 112/112, data 105/105, app 39/39, gateway 50/50; both Flutter analyzes and format pass.
- UI selection/repair, sync, packaging, and integrated device/browser proof remain unrun.
