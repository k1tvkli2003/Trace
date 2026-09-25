# Plan

## Approach
One RED test first, then minimal floor check inside figure loop mirroring block rule.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: new low-confidence figure test failed first (`AssertionError: ContractFailure not raised`) |
| 2 | done | GREEN: reject figure below 0.5 with `LOW_CONFIDENCE_FIGURE_REJECTED` |
| 3 | done | Full suite + validate + diff-check + commit (`0e9415d`) |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py`
- `services/ai_gateway/test_page_extract.py`
- `docs/codex/2026-09-26-stage-59-figure-low-confidence-rejected/` (this task)

## Risks
- None. Validator-only addition; figure record carries no `uncertain` field, so reject is the only fail-closed option.
