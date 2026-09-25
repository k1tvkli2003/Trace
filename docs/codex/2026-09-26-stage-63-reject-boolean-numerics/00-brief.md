# Stage 63 reject boolean numerics

- Task ID: `2026-09-26-stage-63-reject-boolean-numerics`
- Status: `done`
- Created: 2026-09-26
- Feat commit: `8444ccc`
- Language: en

## Request
Close the fail-closed hole where Python `bool` values pass numeric checks in `services/ai_gateway/page_extract.py`. Live probe at Stage62 HEAD (`5360db7`) accepted `confidence=True` on a block, `order=True` on a block, and `confidence=True` on a figure (`bool-bbox` with `True`/`False` coordinates was already rejected via `BBOX_OUT_OF_PAGE`, but only by accident of arithmetic, not by type).

## Success Criteria
- New failing tests fail RED before the fix with `ContractFailure not raised` (block `order=True` + block `confidence=True` in one test, figure `confidence=True` in a second).
- After the minimal validator fix, `python -m unittest test_page_extract -v` (11/11) and full gateway `discover` pass GREEN with 58/58 tests (56 + 2 new).
- `validate_task_docs.py --structure-only` passes; `git diff --check` clean; change committed on `master`.

## Context
`page-extract-v1` is raster-Vision-only, fail-closed. `validate_page_extract` checks `isinstance(value, (int, float))` for `order`, `confidence`, and bbox coordinates. In Python `bool` is a subclass of `int`, so `True`/`False` slip through: `True == 1` passes the order check, `True` passes the 0..1 confidence range. A model emitting JSON `true` for a numeric field must be rejected, not silently coerced.

## In Scope
- Two RED tests (block order+confidence bools, figure confidence bool).
- One minimal GREEN fix: reject `bool` in numeric validators (`order`, `confidence`, bbox coordinates).
- Stage63 task docs and `_index.md` row; feat + close commits; no matrix refresh beyond what the suite count requires (matrix still cites Stage61 56).

## Out of Scope
- Schema changes to `docs/contracts/page-extract-v1.json` (JSON Schema `integer`/`number` already exclude booleans in Draft 2020-12; runtime was the hole).
- Live AI Vision runs, PDF renderer, sync/auth, release builds.
- Touching `StudyHub-Web` (reference-only).

## Assumptions
- `uncertain` stays the only `bool` field; every other numeric field rejects `bool` explicitly.
