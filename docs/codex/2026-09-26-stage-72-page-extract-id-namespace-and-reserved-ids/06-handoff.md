# Handoff

## Outcome

`validate_page_extract` now rejects reserved prototype IDs (`__proto__`, `constructor`, `prototype`) at the shared `_require_id` choke point and rejects a figure whose ID collides with any block ID on the page via a new distinct code `FIGURE_ID_COLLIDES_BLOCK_ID`. Both holes came from a systematic trust-boundary probe, not from guessing.

## Changed Artifacts

- `services/ai_gateway/page_extract.py` — `_RESERVED_IDS`, `_require_id`, collision check
- `services/ai_gateway/test_page_extract.py` — `test_rejects_figure_id_colliding_with_block_id`, `test_rejects_reserved_prototype_entity_ids`
- `docs/qa/acceptance-matrix.md` — gateway row 62→64, Stage72 note
- `docs/codex/2026-09-26-stage-72-page-extract-id-namespace-and-reserved-ids/*`, `_index.md`

## How To Continue

- Next probe classes still open for later stages: numeric-string IDs colliding after coercion, unicode casefold collisions, `pageRef` vs block-ID namespace, and text-vs-caption policy divergence.
- Verify with `python -m unittest discover -s services/ai_gateway -p 'test_*.py'` (expect 64).

## Done

- Probe, RED tests, validator patch, GREEN 64/64, docs complete, matrix + index updated.

## Remaining

- None for this stage.

## Verification

- Focused RED→GREEN plus full gateway suite at 64 tests OK; schema file unchanged and still validated against the runtime-accepted fixture. Limits: offline validator only — no Flutter, device, browser, or AI call involved.
