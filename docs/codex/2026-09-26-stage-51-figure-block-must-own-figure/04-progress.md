# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-26T00:00:31 | active | Task docs created. | docs/codex/2026-09-26-stage-51-figure-block-must-own-figure/ |
| 2026-09-26 | active | First-draft lonely-figure-block test passed immediately against old code; probed HEAD and confirmed the real hole (figure on paragraph `b2` accepted) instead. | HEAD probe of `validate_page_extract` |
| 2026-09-26 | active | RED: `test_rejects_figure_attached_to_non_figure_block` fails with `ContractFailure not raised`. | `python -m unittest test_page_extract.PageExtractTests.test_rejects_figure_attached_to_non_figure_block -v` |
| 2026-09-26 | ready-for-review | GREEN: two-way ownership check; fixture updated; page-extract 4/4, gateway 51/51; brief/plan corrected. | `python -m unittest discover -s . -p "test_*.py"` in `services/ai_gateway` |

## Done So Far
- Real RED->GREEN cycle on the actual hole, with fixture updated for the tightened rule.

## Next
- Validate docs, diff-check, commit.
