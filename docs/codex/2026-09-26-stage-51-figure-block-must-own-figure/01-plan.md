# Plan

## Approach
TDD vertical slice. Add one rejection case: figure whose `blockId` names a paragraph is accepted. Watch it fail. Then require every figure `blockId` to name a `kind: figure` block, and update the happy fixture so its figure owns a figure block.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: figure attached to paragraph `b2` accepted (probed on HEAD `3b6f15c`; first-draft lonely-figure-block test passed immediately, proving it tested existing behavior, and was replaced) |
| 2 | done | GREEN: `FIGURE_BLOCK_WITHOUT_FIGURE` when figure `blockId` is not a figure block; fixture updated (`fig-1` -> new figure-kind block `b3`, quarantine block renumbered `b4`) |
| 3 | done | Gateway suite green 51/51 |
| 4 | active | Validate docs, diff-check, commit |

## Interfaces and Artifacts
- `services/ai_gateway/test_page_extract.py`
- `services/ai_gateway/page_extract.py`

## Risks
- Happy fixture currently attaches a figure to paragraph `b2`. Mitigation: change that fixture's target to a figure-kind block in the same GREEN step, or the existing pass test breaks for the new rule.

## Acceptance Checks
- New case fails before the code change and passes after.
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` OK.
- `git diff --check` clean.
