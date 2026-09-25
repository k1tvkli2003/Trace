# Stage 58 gateway suite count refresh

- Task ID: `2026-09-26-stage-58-gateway-suite-count-refresh`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Matrix gateway row cites Stage55 run (53 tests). Stage57 added the textless figure-block rejection case and the suite is now 54 green. Update the one row, nothing else.

## Scope
- Only file changed: `docs/qa/acceptance-matrix.md` gateway row.
- No production change.

## Non-Goals
- No validator, test, contract, or app change.
- No other matrix row touched.

## Acceptance
- Row cites `Stage57 verification`, says `54 tests OK`, names the textless case.
- `validate_task_docs.py --structure-only` OK.
- `git diff --check` clean; single-row `git diff` shown before commit.
