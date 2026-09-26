# Plan

## Approach
TDD vertical slice: one RED test first (control chars in figure `caption`), verify RED, then one minimal GREEN fix applying `_CONTROL_TEXT` to the caption check, then GREEN full suite, docs, and commits.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Added RED test `test_rejects_figure_caption_with_control_characters`; RED confirmed (3 subtests fail with `ContractFailure not raised`) |
| 2 | done | Applied `_CONTROL_TEXT.search(caption)` to the caption check (reuse existing code `INVALID_FIGURE_CAPTION`, no other path touched) |
| 3 | done | GREEN: `test_page_extract -v` 14/14 + gateway `discover` 61/61 OK |
| 4 | done | Feat committed `c00449a`; close flips (brief/state/plan/`_index` → done) staged; validated OK; `diff --check` clean |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py` (caption check)
- `services/ai_gateway/test_page_extract.py` (one new test)
- `docs/codex/2026-09-26-stage-69-figure-caption-rejects-control-characters/`
- `docs/codex/_index.md` (Stage69 row)

## Risks
- Reusing `INVALID_FIGURE_CAPTION` lumps control-char failure with empty/unsafe caption; acceptable for this slice (matches Stage67 reuse of `INVALID_BLOCK_TEXT`).

## Acceptance Checks
- RED run shows the new test failing with `ContractFailure not raised`.
- GREEN run shows 61/61 gateway tests OK.
- `validate_task_docs.py <task> --structure-only` passes; `git diff --check` clean.
