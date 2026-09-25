# Stage 52 gateway suite count refresh

- Task ID: `2026-09-26-stage-52-gateway-suite-count-refresh`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
The acceptance matrix still cites the Stage30 gateway count (50 tests) after Stage51 closed with a new passing test (51 tests). Refresh the gateway row to the verified Stage51 count. Docs-only fix; no production code.

## Success Criteria
- Matrix gateway row cites 51 tests OK with Stage51 evidence.
- Gateway suite still passes 51/51 locally.
- No other matrix row changed; no production file touched.

## Context
Stage51 (`21c63f2`) added `test_rejects_figure_attached_to_non_figure_block` to `test_page_extract.py`; its verification records 51/51. The matrix gateway row was never updated and still says 50.

## In Scope
- `docs/qa/acceptance-matrix.md` (gateway row only).
- Task docs for this stage.

## Out of Scope
- Any production code, fixture, schema, or contract change.
- Live Vision, cost ledger, Supabase, release builds, device/browser/CI runs.

## Assumptions
- All other matrix rows still trace to their Stage30 runs; only the gateway row needs a refresh.
