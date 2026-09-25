# Stage 64 gateway suite count refresh

- Task ID: `2026-09-26-stage-64-gateway-suite-count-refresh`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Refresh `docs/qa/acceptance-matrix.md` gateway row from Stage61 56 tests to the fresh post-Stage63 count of 58 tests OK, naming the Stage63 boolean-numeric rejection cases. Docs-only, no production change.

## Success Criteria
- Fresh `discover` evidence re-run in this stage: `Ran 58 tests ... OK`.
- Matrix gateway row cites Stage63 verification with 58 tests OK and names the boolean-numeric cases.
- `validate_task_docs.py --structure-only` passes; `git diff --check` clean; change committed on `master`.

## Context
Stage63 (`8444ccc` + close `b605211`) added `test_rejects_boolean_order_confidence` and `test_rejects_boolean_figure_confidence` to the gateway suite. The matrix still cites Stage61 56 tests, so it is two tests behind the real suite. Same docs-only refresh pattern as Stages 52/54/56/58/60/62.

## In Scope
- One matrix row patch (gateway suite count 56 → 58, Stage61 → Stage63 citation).
- Stage64 task docs and `_index.md` row; refresh + close commits.

## Out of Scope
- Production code changes (validator/tests already committed in Stage63).
- Live AI Vision runs, PDF renderer, sync/auth, release builds.
- Touching `StudyHub-Web` (reference-only).

## Assumptions
- Suite count stays 58 through this stage (no new tests land mid-refresh).
