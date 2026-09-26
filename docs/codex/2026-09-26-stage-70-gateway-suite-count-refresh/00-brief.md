# Stage 70 gateway suite count refresh

- Task ID: `2026-09-26-stage-70-gateway-suite-count-refresh`
- Status: `active`
- Created: 2026-09-26
- Refresh commit: pending
- Language: en

## Request
Refresh `docs/qa/acceptance-matrix.md` gateway row from Stage67 60 tests to Stage69 61 tests (Stage69 added the figure-caption control-character rejection case).

## Success Criteria
- Fresh `discover` evidence in this stage: `Ran 61 tests ... OK`.
- Matrix gateway row cites Stage69 verification with 61 tests OK and names the caption control-character case.
- Task docs validate `--structure-only`; `git diff --check` clean; refresh + close commits land; status `done`.

## Context
Stage69 feat `c00449a` rejected C0/C1/bidi control characters in figure `caption` with `INVALID_FIGURE_CAPTION` (page suite 14/14). Suite now 61 tests (`444a191` closed Stage69). Matrix still cites Stage67 60.

## In Scope
- Matrix gateway row patch (Stage67 60 → Stage69 61).
- Stage70 task docs + `_index.md` row; refresh commit + close commit.

## Out of Scope
- Production/validator change; contract JSON change.

## Assumptions
- None: evidence is the fresh local `discover` run.
