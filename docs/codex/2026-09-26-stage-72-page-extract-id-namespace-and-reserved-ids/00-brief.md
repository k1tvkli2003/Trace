# Stage 72 page extract ID namespace and reserved IDs

- Task ID: `2026-09-26-stage-72-page-extract-id-namespace-and-reserved-ids`
- Status: `done`
- Created: 2026-09-26
- Language: en

## Request

Close two real trust-boundary holes found by automated probing of `validate_page_extract`: a figure ID colliding with a block ID is accepted, and reserved prototype IDs (`__proto__`, `constructor`, `prototype`) are accepted as entity IDs.

## Success Criteria

- `test_rejects_figure_id_colliding_with_block_id` fails RED before the fix and passes GREEN after, asserting `FIGURE_ID_COLLIDES_BLOCK_ID`.
- `test_rejects_reserved_prototype_entity_ids` fails RED before the fix and passes GREEN after, asserting `INVALID_BLOCK_ID` / `INVALID_FIGURE_ID`.
- Full gateway suite stays GREEN (64 tests) after the fix.
- Docs: task folder complete, acceptance matrix 62→64, `_index.md` row updated, `validate_task_docs.py --structure-only` OK.

## Context

`services/ai_gateway/page_extract.py` is the fail-closed validator for `page-extract-v1`. Blocks and figures each have their own duplicate checks (`DUPLICATE_BLOCK_ID`, `DUPLICATE_FIGURE_ID`), but no cross-namespace check and no reserved-word check. Nine-case probe result: `fig-id-eq-block-id ACCEPTED-HOLE`, `proto-block-id ACCEPTED-HOLE`, `long-id-512 ACCEPTED-HOLE` (intended: 512 is the documented cap, kept), `bbox-edge-touch ACCEPTED-HOLE` (intended: exact-touch is in-page, kept); the rest rejected.

## In Scope

- `_RESERVED_IDS` denylist in `_require_id` for block, figure, and page-ref IDs.
- Cross-namespace `FIGURE_ID_COLLIDES_BLOCK_ID` check after `DUPLICATE_FIGURE_ID`.
- Two regression tests, task docs, matrix refresh, `_index.md`, feat commit.

## Out of Scope

- Touching `long-id-512` cap, `bbox-edge-touch` semantics, text/caption rules, schema file, OCR policy.
- avalAI/OpenHUB, model routing, Flutter, sync, release builds.

## Assumptions

- `long-id-512` accepted is correct (cap `> 512` rejects); `bbox-edge-touch` accepted is correct (`x + w == 1.0` is on-page).
