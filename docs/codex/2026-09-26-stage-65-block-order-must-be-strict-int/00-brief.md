# Stage 65 block order must be strict int

- Task ID: `2026-09-26-stage-65-block-order-must-be-strict-int`
- Status: `done`
- Created: 2026-09-26
- Feat commit: `bc2c01e`
- Language: en

## Request
Close the fail-closed hole where a non-`int` block `order` passes the sequence check in `services/ai_gateway/page_extract.py`. Live probe at Stage64 HEAD (`4eeb5f0`) accepted `order=1.0` on `b2` (`float-order: ACCEPTED-HOLE`) because `1.0 == 1` compares equal to the expected index. A model emitting JSON `1.0` for an integer field must be rejected, not silently coerced. (`string-order`/`none-order` already reject via `BLOCKS_NOT_ORDERED`, but by accident of inequality, not by type.)

## Success Criteria
- New failing test fails RED before the fix with `ContractFailure not raised` (block `order=1.0`).
- After the minimal validator fix, `python -m unittest test_page_extract -v` (12/12) and full gateway `discover` pass GREEN with 59/59 tests (58 + 1 new).
- `validate_task_docs.py --structure-only` passes; `git diff --check` clean; change committed on `master`.

## Context
`page-extract-v1` is raster-Vision-only, fail-closed. The order check compares `block.get('order') != index` with no type gate, so any value equal to the index passes — including `1.0`. JSON Schema `integer` already excludes floats; the runtime was the hole. Follows the Stage63 `_is_number`/`bool`-rejection pattern; Stage63's explicit `isinstance(order, bool)` guard already names the right error code to keep (`BLOCKS_NOT_ORDERED`).

## In Scope
- One RED test (block order float `1.0` → `BLOCKS_NOT_ORDERED`).
- One minimal GREEN fix: require `type(order) is int` (strict, excludes `bool` and `float`) in the order check.
- Stage65 task docs and `_index.md` row; feat + close commits; no matrix refresh (matrix still cites Stage63 58 until the next count stage).

## Out of Scope
- Schema changes to `docs/contracts/page-extract-v1.json` (already `integer`).
- `confidence` semantics: `1` (int) for a `0..1` float stays accepted — JSON numbers are not split int/float at runtime there, and the probe showed `float-confidence: ACCEPTED-HOLE` is legitimate value acceptance (`1 == 1.0` in range), not coercion of a wrong type.
- Live AI Vision runs, PDF renderer, sync/auth, release builds.
- Touching `StudyHub-Web` (reference-only).

## Assumptions
- `order` is the only strict-`int` field in the contract; `confidence`/`bbox` stay numeric (`int` or `float`, never `bool`).
