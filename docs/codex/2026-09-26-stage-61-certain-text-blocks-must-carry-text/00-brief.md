# Stage 61 certain text blocks must carry text

- Task ID: `2026-09-26-stage-61-certain-text-blocks-must-carry-text`
- Status: `done`
- Created: 2026-09-26
- Language: en

## Request
Close the fail-closed hole where certain (`uncertain=false`) text-bearing blocks accept empty/whitespace `text` in `services/ai_gateway/page_extract.py`. Live probe at Stage60 HEAD accepted `empty-certain-paragraph`, `ws-certain-paragraph`, and `empty-certain-heading`.

## Success Criteria
- New failing test `test_rejects_certain_text_block_without_text` fails RED before the fix with `ContractFailure not raised`.
- After the minimal validator fix, `python -m unittest test_page_extract -v` and full gateway `discover` pass GREEN with 56/56 tests.
- `validate_task_docs.py --structure-only` passes; `git diff --check` clean; change committed on `master`.

## Context
`page-extract-v1` is raster-Vision-only, fail-closed. Existing rules already reject `unknown` blocks carrying text, `figure` blocks carrying text, and `uncertain` non-unknown blocks with empty text (`EMPTY_TRANSCRIPTION_REJECTED`). The mirror direction was missing: certain blocks of text kinds (`heading`, `paragraph`, `list`, `table`, `formula`, `caption`, `footnote`) with empty/whitespace text were accepted, letting silent content loss pass as a complete page.

## In Scope
- One RED test for certain empty/whitespace text blocks.
- One minimal GREEN validator rule (`EMPTY_TEXT_BLOCK_REJECTED` or equivalent) for text kinds only.
- Stage61 task docs (brief/plan/state/progress/verification/handoff/previews) and `_index.md` row.
- Commits for feat + close; no matrix refresh beyond what the suite count requires.

## Out of Scope
- Schema changes to `docs/contracts/page-extract-v1.json` beyond what the runtime rule needs (none expected).
- Live AI Vision runs, PDF renderer, sync/auth, release builds.
- Touching `StudyHub-Web` (reference-only).

## Assumptions
- `figure` and `unknown` kinds keep their existing dedicated rules; the new rule covers only genuine text-bearing kinds.
- Whitespace-only counts as empty (`text.strip()`).
