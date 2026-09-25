# Plan

## Approach
TDD vertical slice: two RED tests first (block order+confidence bools, figure confidence bool), verify RED, then one minimal GREEN fix rejecting `bool` in numeric paths, then GREEN full suite, docs, and commits.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Added 2 RED tests (`test_rejects_boolean_order_confidence` covers order+block-confidence, `test_rejects_boolean_figure_confidence`); RED confirmed (`ContractFailure not raised`, both) |
| 2 | done | Added `_is_number` (`not isinstance(bool)`) in `_check_box`, both `confidence` checks; explicit `isinstance(order, bool)` guard on `BLOCKS_NOT_ORDERED` |
| 3 | done | GREEN: `test_page_extract -v` 11/11 + gateway `discover` 58/58 OK |
| 4 | planned | Fill Stage63 state/progress/verification/handoff/previews; validate docs; `diff --check`; feat commit + close commit |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py` (`validate_page_extract`, `_check_box`)
- `services/ai_gateway/test_page_extract.py`
- `docs/codex/2026-09-26-stage-63-reject-boolean-numerics/`
- `docs/codex/_index.md`

## Risks
- Over-rejecting the legitimate `uncertain` bool — mitigated by touching only numeric checks, never the `isinstance(uncertain, bool)` path.
- None known beyond that.

## Acceptance Checks
- RED run showed both new tests failing with `ContractFailure not raised`.
- GREEN run shows 58/58 gateway tests OK.
- `validate_task_docs.py <task> --structure-only` passes; `git diff --check` clean; commits on `master`.
