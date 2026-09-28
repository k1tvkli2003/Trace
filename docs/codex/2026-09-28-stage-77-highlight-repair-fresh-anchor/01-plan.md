# Plan

## Approach

Docs-only pass. Read scaffold docs and existing implementation diff read-only, then fill all seven task docs with truthful English and update the one existing Stage77 index row. No code, test, Stage78, `work/`, or user-change edits. No commit.

## Steps

| Step | Status | Notes |
|---|---|---|
| 1 | done | Read scaffold docs, `_index.md` Stage77 row, read-only `git diff`/`git status`/`git log` |
| 2 | done | Fill 00-brief, 01-plan, 02-state, 03-previews, 04-progress, 05-verification, 06-handoff |
| 3 | done | Update existing Stage77 `_index.md` row to `ready-for-review` / `2026-09-28`, no duplicate row |
| 4 | done | Verify no Dart/code/test, Stage78, `work/`, or user files changed; no commit |

## Interfaces and Artifacts

- Docs written: `docs/codex/2026-09-28-stage-77-highlight-repair-fresh-anchor/00-brief.md`, `01-plan.md`, `02-state.md`, `03-previews.md`, `04-progress.md`, `05-verification.md`, `06-handoff.md`.
- Index row updated: `docs/codex/_index.md` (Stage77 row only).
- Implementation referenced, not modified: `packages/trace_data/lib/src/local/local_annotation_repository.dart` (`repairAnchor`, `_putAnchor`), `packages/trace_data/test/highlight_repair_test.dart`.

## Risks

- Stale or overstated docs misrepresenting uncommitted code: mitigated by describing only what the read-only diff shows and marking code uncommitted.
- Duplicate `_index.md` row: mitigated by editing the existing Stage77 row in place.
- Accidental code touch: mitigated by restricting writes to the seven Stage77 docs plus the one index row.

## Acceptance Checks

- All seven Stage77 docs contain truthful English, no unfinished placeholders.
- Success criteria recorded: fresh-ID repair, exact span/hash/page validation, immutable old anchor and notes preserved, tombstone/old-ID/replay failure-closed.
- Verification records 11 targeted tests passed, 163 full-suite tests passed, analyze passed, root-level `dart test` invalid (no pubspec), no commit claimed.
- `03-previews.md` states No Previews Required.
- Stage77 marked `ready-for-review`, explicitly not release-complete (simultaneous-write proof, real PDF/Farsi extraction, release signing outside stage).
