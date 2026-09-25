# Stage 66 gateway suite count refresh

- Task ID: `2026-09-26-stage-66-gateway-suite-count-refresh`
- Status: `done`
- Created: 2026-09-26
- Refresh commit: `d664b7b`
- Language: en

## Request
Refresh `docs/qa/acceptance-matrix.md` gateway suite row from Stage63 58 tests to Stage65 59 tests, keeping the count claim backed by a fresh same-day run.

## Success Criteria
- Gateway suite re-run from repo root shows 59/59 OK.
- Matrix gateway row cites Stage65 verification with 59 tests OK and names the strict-int order case.
- Task docs validate `--structure-only`; `git diff --check` clean; refresh + close commits land; status `done`.

## Context
Stage65 added `test_rejects_float_block_order` and required `type(order) is int`, moving the suite 58 → 59. The matrix still cites Stage63 58.

## In Scope
- Fresh `discover` evidence (59/59).
- One-line matrix gateway row patch (Stage63 58 → Stage65 59, name strict-int order case).
- Stage66 task docs + `_index.md` row; refresh commit + close commit.

## Out of Scope
- No validator, test, contract, or product changes.

## Assumptions
- The 59/59 run in this stage is the evidence cited by the refreshed row.
