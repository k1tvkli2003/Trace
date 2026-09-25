# Stage 53 figure block single ownership

- Task ID: `2026-09-26-stage-53-figure-block-single-ownership`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Close a real hole in `page-extract-v1`: two figure records claiming the same `kind: figure` block are accepted. The Stage51 set-equality check (`figure_blocks <= owned` and reverse) dedupes `blockId` into a set, so a shared block looks identical to single ownership. Fix only that rule. No live Vision, no OCR, no text layer.

## Success Criteria
- A new test fails first because two figures (`fig-1`, `fig-2`) both attached to figure block `b3` are accepted.
- After the fix, that case raises `ContractFailure` with `FIGURE_BLOCK_WITHOUT_FIGURE`.
- Existing page-extract tests and the gateway suite still pass (52/52).
- No model call, no OCR, no PDF text layer, no StudyHub-Web change.

## Context
`services/ai_gateway/page_extract.py` (Stage51, commit `21c63f2`) builds `owned` as a set comprehension, so duplicate `blockId` values collapse. Verified live: two figures both owning `b3` returns the document instead of raising. Gateway suite is 51 OK at HEAD `2fa71fe`.

## In Scope
- One failing test in `services/ai_gateway/test_page_extract.py`.
- One uniqueness check in `validate_page_extract`.
- Task docs for this stage.

## Out of Scope
- Live `page_vision_extract` call, cost ledger, raster render, Supabase, release builds.
- Schema rewrite beyond what the new test forces.
- Any change to StudyHub-Web.

## Assumptions
- Each `kind: figure` block is owned by exactly one figure record; sharing is rejected with the same ownership code.
