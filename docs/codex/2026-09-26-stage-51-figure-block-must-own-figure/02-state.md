# State

- Current status: `ready-for-review`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
RED->GREEN complete locally. `page_extract.py` now requires a two-way figure/block ownership: a `kind: figure` block needs an owning figure record, and every figure `blockId` must name a `kind: figure` block. Fixture updated so `fig-1` owns new figure-kind block `b3` (quarantine block renumbered `b4`).

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Test the reverse triangle, not the lonely-figure-block case | The lonely-figure-block case passed immediately against old code, proving it covered existing behavior; the real hole was figure `blockId` -> paragraph `b2`, which HEAD accepted | HEAD probe + TDD skill |
| 2026-09-26 | Keep error code `FIGURE_BLOCK_WITHOUT_FIGURE` for both directions | One ownership rule, one code; brief success criteria already names it | 00-brief.md |

## Blockers
- None

## Done
- RED test `test_rejects_figure_attached_to_non_figure_block` observed failing (`ContractFailure not raised`).
- GREEN validator check + fixture update; page-extract 4/4, gateway 51/51.
- Brief/plan corrected to describe the real hole.

## Remaining
- Validate docs, diff-check, commit.
