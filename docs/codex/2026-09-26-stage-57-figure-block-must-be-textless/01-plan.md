# Plan

## Approach
One RED test first, then minimal check inside block loop next to quarantine rules.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: new figure-text test failed first (`AssertionError: ContractFailure not raised`) |
| 2 | done | GREEN: reject non-empty figure text with `FIGURE_BLOCK_MUST_BE_TEXTLESS` |
| 3 | done | Full suite + validate + diff-check + commit (`341a31b`) |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py`
- `services/ai_gateway/test_page_extract.py`

## Risks
- None. One block-kind check.

## Acceptance Checks
- New case raises `FIGURE_BLOCK_MUST_BE_TEXTLESS`.
- Suite 54/54 OK, `git diff --check` clean.
