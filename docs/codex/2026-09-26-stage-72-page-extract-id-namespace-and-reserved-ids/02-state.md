# State

- Current status: `done`
- Last updated: 2026-09-26
- Owner: Codex

## Current State

RED confirmed for both Stage72 defects (`ContractFailure not raised` ×3). Fix drafted in `page_extract.py` (`_RESERVED_IDS` + `FIGURE_ID_COLLIDES_BLOCK_ID`). Page suite GREEN at 17/17; full gateway count (64) pending a discover run.

## Decisions

| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Stage72 scope = cross-namespace collision + reserved prototype IDs | Only these two probe holes are real defects; `long-id-512` (cap) and `bbox-edge-touch` (on-page) are intended semantics | probe result `fig-id-eq-block-id ACCEPTED-HOLE`, `proto-block-id ACCEPTED-HOLE` |
| 2026-09-26 | Reserved set = `__proto__`, `constructor`, `prototype` | Minimal prototype-pollution guard for Python/JS consumers of extract JSON | repo test evidence |
| 2026-09-26 | New error code `FIGURE_ID_COLLIDES_BLOCK_ID` | Distinct from `DUPLICATE_FIGURE_ID`/`FOREIGN_FIGURE_BLOCK`; matches Stage55 three-code precedent | repo convention |

## Blockers

- None

## Done

- Nine-case trust-boundary probe executed
- Task folder scaffolded (`create_task_docs.py`, status active)
- Two RED regression tests written and confirmed failing pre-fix
- `_RESERVED_IDS` + collision check patched

## Remaining

- Full gateway discover run (expect 64 OK)
- Fill `02-state.md` done, `03-previews.md`, `04-progress.md`, `05-verification.md`, `06-handoff.md`
- Matrix 62→64, `_index.md` flip to done, validate, feat + close commits
