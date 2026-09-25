# Plan

## Approach
Split one boolean into three rejects. Order: duplicates first (exact code), then ownership directions. One existing test repointed per RED.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: both repointed tests failed on old code (`AssertionError`, expected two new codes, got lumped code) |
| 2 | done | RED observed for both directions |
| 3 | done | GREEN: split check into three codes |
| 4 | done | Added lonely-block rejection test (missing direction), `FIGURE_BLOCK_WITHOUT_FIGURE` |
| 5 | active | Full suite + validate + diff-check + commit |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py`
- `services/ai_gateway/test_page_extract.py`

## Risks
- None. Validator codes only; schema and fixtures unchanged.

## Acceptance Checks
- Three ownership violations raise three distinct codes.
- Gateway suite 53/53 OK.
- `git diff --check` clean.
