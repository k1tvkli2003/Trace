# Stage 51 figure block must own figure

- Task ID: `2026-09-26-stage-51-figure-block-must-own-figure`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Close a real hole in `page-extract-v1`: a figure record whose `blockId` names a non-figure block (paragraph, caption, ...) is accepted. Stage14 says every figure is tied to a block, but the validator only checked that the `blockId` exists, never that the target is a `kind: figure` block. Fix only that rule. No live Vision, no OCR, no text layer.

## Success Criteria
- A new test fails first because a figure attached to a non-figure block is accepted.
- After the fix, that case raises `ContractFailure` with `FIGURE_BLOCK_WITHOUT_FIGURE`.
- Existing page-extract tests and the gateway suite still pass.
- No model call, no OCR, no PDF text layer, no StudyHub-Web change.

## Context
`services/ai_gateway/page_extract.py` already rejects a figure whose `blockId` is missing, and rejects a `kind: figure` block with no owning figure record. It never checks the reverse: that a figure record's `blockId` points at a `kind: figure` block. The committed fixture itself attaches `fig-1` to paragraph `b2` and passes. Gateway suite is 50 OK at HEAD `3b6f15c`.

## In Scope
- One failing test in `services/ai_gateway/test_page_extract.py`.
- One ownership check in `validate_page_extract`.
- Task docs for this stage.

## Out of Scope
- Live `page_vision_extract` call, cost ledger, raster render, Supabase, release builds.
- Schema rewrite beyond what the new test forces.
- Any change to StudyHub-Web.

## Assumptions
- Figure records must attach only to `kind: figure` blocks. A caption/paragraph block may not own a figure.
- Existing valid fixture (figure attached to paragraph `b2`, no figure-kind block) becomes invalid and must be updated so the figure owns a figure block.
