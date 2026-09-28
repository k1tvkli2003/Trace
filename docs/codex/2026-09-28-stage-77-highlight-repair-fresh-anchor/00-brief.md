# Stage 77 highlight repair with fresh anchor

- Task ID: `2026-09-28-stage-77-highlight-repair-fresh-anchor`
- Status: `ready-for-review`
- Created: 2026-09-28T01:05:11
- Language: en

## Request

Stage77 work-docs only. Fill the existing task docs under `docs/codex/2026-09-28-stage-77-highlight-repair-fresh-anchor/` from scaffold placeholders into truthful English docs. Update `docs/codex/_index.md` only for the existing Stage77 row, changing status to `ready-for-review` and last updated to `2026-09-28`; do not add duplicate row. Do not touch any Dart/code/test files, Stage78 files, `work/`/critic files, or user changes. Do not commit.

## Success Criteria

- Explicit fresh-ID repair of a detached highlight exists: `repairAnchor(oldId, replacement)` requires old anchor detached, replacement attached, different fresh ID, unchanged quote.
- Exact raw source span/hash/page validation: replacement must match `sourceBlocks.rawText.substring(startOffset, endOffset) == quote`, `endOffset <= rawText.length`, `block.pageId == replacement.pageId`, `block.sourceHash == replacement.contentHashAtCreation`.
- Immutable old anchor and notes preserved: old detached row is never mutated; repair only inserts the fresh anchor inside the same transaction; existing tombstone and immutability guards still reject writes to tombstoned rows and JSON changes to stored anchors.
- Tombstone/old-ID/replay failure-closed: missing old row, tombstoned old row, non-detached old row, same-ID replacement, detached replacement, quote change, or span/hash/page mismatch all throw `StateError`.
- Verified tests recorded: targeted suite passed 11 tests; full `trace_data` suite passed 163 tests; `dart analyze` on `local_annotation_repository.dart` passed; root-level `dart test` noted invalid (no pubspec there).
- Previews marked as No Previews Required.
- Stage77 explicitly not release-complete: simultaneous-write proof, real PDF/Farsi extraction, and release signing remain outside this stage.
- No commit claimed.

## Context

- Project root: `C:/Users/K1/Desktop/Projects/Trace`. HEAD `70a5963` at docs pass.
- Existing Stage77 implementation was uncommitted at the docs pass and preserved untouched: `packages/trace_data/lib/src/local/local_annotation_repository.dart` (adds `repairAnchor` plus `_putAnchor` refactor) and `packages/trace_data/test/highlight_repair_test.dart`.
- Existing Stage77 docs were scaffold placeholders; this pass fills docs only.

## In Scope

- Fill `00-brief.md`, `01-plan.md`, `02-state.md`, `03-previews.md`, `04-progress.md`, `05-verification.md`, `06-handoff.md`.
- Update the single existing Stage77 row in `docs/codex/_index.md` to `ready-for-review` / `2026-09-28`.

## Out of Scope

- Any Dart/code/test change, including Stage77 implementation and test files.
- Stage78 files, `work/`/critic files, user changes.
- Simultaneous-write proof, real PDF/Farsi extraction, release signing.
- Committing anything.

## Assumptions

- Test and analyze results listed above were verified earlier in this continuation and are recorded as given; this docs pass did not re-run them.
- Read-only inspection (`git diff`, `git status`, `git log`) does not count as touching code.
