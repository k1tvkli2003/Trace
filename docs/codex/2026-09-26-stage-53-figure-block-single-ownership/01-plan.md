# Plan

## Approach
TDD vertical slice. Add one rejection case: two figures sharing figure block `b3` are accepted. Watch it fail. Then require figure `blockId` values to be unique (bijection between figure records and figure blocks).

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: two figures both owning `b3` accepted (`AssertionError: ContractFailure not raised`) |
| 2 | done | GREEN: `blockId` list must be unique — shared ownership raises `FIGURE_BLOCK_WITHOUT_FIGURE` |
| 3 | done | Gateway suite green 52/52 |
| 4 | active | Validate docs, diff-check, commit |

## Interfaces and Artifacts
- `services/ai_gateway/test_page_extract.py`
- `services/ai_gateway/page_extract.py`

## Risks
- None. One comparison added; existing legal fixture has exactly one figure per figure block.

## Acceptance Checks
- New case fails before the code change and passes after.
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` OK (52 tests).
- `git diff --check` clean.
