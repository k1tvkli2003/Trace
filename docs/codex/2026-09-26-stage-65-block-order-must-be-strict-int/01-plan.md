# Plan

## Approach
TDD vertical slice: one RED test first (block `order=1.0`), verify RED, then one minimal GREEN fix requiring strict `int` order, then GREEN full suite, docs, and commits.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Added RED test `test_rejects_float_block_order`; RED confirmed (`ContractFailure not raised`) |
| 2 | done | Require `type(order) is int` in the `BLOCKS_NOT_ORDERED` check (excludes `bool`/`float`, supersedes Stage63 `isinstance` guard) |
| 3 | done | GREEN: `test_page_extract -v` 12/12 + gateway `discover` 59/59 OK |
| 4 | done | Stage65 docs validated; feat `bc2c01e`; status flipped to `done` |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py` (`validate_page_extract` order check)
- `services/ai_gateway/test_page_extract.py`
- `docs/codex/2026-09-26-stage-65-block-order-must-be-strict-int/`
- `docs/codex/_index.md`

## Risks
- Over-rejecting legit orders — mitigated: sequence indices are always Python `int` from `enumerate`, and the fixture emits `int`; `type() is int` only excludes `bool`/`float` impostors.

## Acceptance Checks
- RED run shows the new test failing with `ContractFailure not raised`.
- GREEN run shows 59/59 gateway tests OK.
- `validate_task_docs.py <task> --structure-only` passes; `git diff --check` clean; commits on `master`.
