# Plan

## Approach
TDD vertical slice: one RED test first (control chars in `b2.text`), verify RED, then one minimal GREEN fix in the block-text check, then GREEN full suite, docs, and commits.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Added RED test `test_rejects_block_text_with_control_characters`; RED confirmed (3 subtests fail with `ContractFailure not raised`) |
| 2 | done | Control-character guard added to block `text` path (`_CONTROL_RANGES` + `_CONTROL_TEXT` + `INVALID_BLOCK_TEXT`); no other path touched |
| 3 | done | GREEN: `test_page_extract -v` 13/13 + gateway `discover` 60/60 OK |
| 4 | done | Stage67 state/progress/verification/handoff/previews filled; docs validated `OK`; `diff --check` clean |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py` (`validate_page_extract` block-text check)
- `services/ai_gateway/test_page_extract.py` (new RED test)
- `docs/codex/2026-09-26-stage-67-block-text-rejects-control-characters/` (task docs)
- `docs/codex/_index.md` (Stage67 row)

## Risks
- Over-broad regex could reject `\n`/Persian/emoji — mitigated by testing only `\x00`, C0, bidi overrides in RED and keeping `\n` accepted by construction.

## Acceptance Checks
- RED run fails with `ContractFailure not raised`.
- GREEN run shows 13/13 page and 60/60 gateway OK.
- `validate_task_docs.py ... --structure-only` passes; `git diff --check` clean.
