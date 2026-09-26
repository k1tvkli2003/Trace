# Plan

## Approach

Narrow validator hardening in the single owning layer (`page_extract.py`): reserve prototype-polluting IDs at the shared `_require_id` choke point, then reject cross-namespace figure/block collisions right after the figure duplicate check. No schema change; contract JSON already allows runtime-stricter acceptance.

## Steps

| Step | Status | Notes |
|---|---|---|
| 1 | done | Nine-case probe: 4 ACCEPTED, 5 REJECTED |
| 2 | done | RED tests written, confirmed `ContractFailure not raised` ×3 |
| 3 | active | Patch `_RESERVED_IDS` + collision check, run full suite |
| 4 | planned | Task docs, matrix 62→64, `_index.md`, validate, feat commit |

## Interfaces and Artifacts

- `services/ai_gateway/page_extract.py`: `_RESERVED_IDS`, `_require_id`, `FIGURE_ID_COLLIDES_BLOCK_ID`
- `services/ai_gateway/test_page_extract.py`: 2 new regression tests
- `docs/contracts/page-extract-v1.json`: unchanged (runtime stricter than schema, same as Stage71)
- `docs/qa/acceptance-matrix.md`, `docs/codex/_index.md`, Stage72 task folder

## Risks

- Over-blocking a legitimate ID: mitigated — reserved set is exactly three prototype-chain names; collision check only fires when a figure ID equals an existing block ID on the same page.
- Schema/runtime drift: none — schema keeps `minLength 1 / maxLength 512`; runtime stays fail-closed-stricter, documented pattern since Stage71.

## Acceptance Checks

- `PYTHONPATH=services/ai_gateway python -m unittest test_page_extract` → 17 tests OK (was 15 pre-Stage71... now 17 with 2 new)
- `python -m unittest discover -s services/ai_gateway -p 'test_*.py'` → 64 tests OK
- `validate_task_docs.py <taskdir> --structure-only` → OK
- `git status --porcelain` shows only intended files; `git diff --check` clean
