# State

- Current status: `ready-for-review`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
Two figures sharing figure block `b3` are now rejected with `FIGURE_BLOCK_WITHOUT_FIGURE`. RED observed (`ContractFailure not raised`), GREEN applied (unique-`blockId` check), gateway suite 52/52 local. Code + test uncommitted.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | One ownership rule stays one code: sharing rejected with `FIGURE_BLOCK_WITHOUT_FIGURE` | Same bijection contract as Stage51: one figure record <-> one figure block | 00-brief.md |

## Blockers
- None

## Done
- RED test `test_rejects_two_figures_sharing_one_figure_block` failed first, passes after fix.
- `page_extract.py` rejects duplicate `blockId`.
- Full gateway suite 52/52.

## Remaining
- Validate docs, diff-check, commit.
