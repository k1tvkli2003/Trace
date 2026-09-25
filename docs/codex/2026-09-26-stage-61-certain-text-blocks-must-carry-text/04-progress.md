# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-26 | active | Probed certain empty text blocks at Stage60 HEAD: `empty-certain-paragraph`, `ws-certain-paragraph`, `empty-certain-heading` all ACCEPTED | `services/ai_gateway/page_extract.py` probe |
| 2026-09-26 | active | Created Stage61 task docs (brief/plan) | `docs/codex/2026-09-26-stage-61-certain-text-blocks-must-carry-text/` |
| 2026-09-26 | active | Added `test_rejects_certain_text_block_without_text`; RED confirmed (`ContractFailure not raised`) | `services/ai_gateway/test_page_extract.py`; unittest single-test run |
| 2026-09-26 | ready-for-review | Added `_TEXT_KINDS` + `EMPTY_TEXT_BLOCK_REJECTED` rule; GREEN 9/9 page + 56/56 gateway | `services/ai_gateway/page_extract.py`; `test_page_extract -v`; `discover` |

## Done So Far
- RED test + RED verification.
- Minimal GREEN validator rule scoped to text kinds.
- GREEN full page + gateway suites.

## Next
- Validate docs, `diff --check`, feat commit + close commit.
