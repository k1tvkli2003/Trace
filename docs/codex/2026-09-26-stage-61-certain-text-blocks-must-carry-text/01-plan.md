# Plan

## Approach
TDD vertical slice: RED test first for certain empty text blocks, verify RED, then one minimal GREEN validator rule covering text kinds only, then GREEN full suite, docs, and commits.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Added `test_rejects_certain_text_block_without_text`; RED confirmed (`ContractFailure not raised`) |
| 2 | done | Added `_TEXT_KINDS` + `EMPTY_TEXT_BLOCK_REJECTED` rule for certain text kinds with empty `text.strip()` |
| 3 | done | GREEN: `test_page_extract -v` 9/9, gateway `discover` 56/56, no regressions |
| 4 | active | Fill Stage61 state/progress/verification/handoff/previews; validate docs; `diff --check`; feat commit + close commit |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py` (`validate_page_extract`)
- `services/ai_gateway/test_page_extract.py`
- `docs/codex/2026-09-26-stage-61-certain-text-blocks-must-carry-text/`
- `docs/codex/_index.md`

## Risks
- Over-rejecting `figure`/`unknown` paths that already have dedicated codes — mitigated by scoping the new rule to text kinds only.
- None known beyond that.

## Acceptance Checks
- RED run shows the new test failing with `ContractFailure not raised`.
- GREEN run shows 56/56 gateway tests OK.
- `validate_task_docs.py <task> --structure-only` passes; `git diff --check` clean; commits on `master`.
