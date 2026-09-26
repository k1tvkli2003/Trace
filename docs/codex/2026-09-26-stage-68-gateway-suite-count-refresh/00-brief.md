# Stage 68 gateway suite count refresh

- Task ID: `2026-09-26-stage-68-gateway-suite-count-refresh`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Refresh `docs/qa/acceptance-matrix.md` gateway row from Stage65 59 tests to Stage67 60 tests (Stage67 added the control-character block-text rejection case).

## Success Criteria
- Fresh `discover` evidence in this stage: `Ran 60 tests ... OK`.
- Matrix gateway row cites Stage67 verification with 60 tests OK and names the control-character case.
- Task docs validate `--structure-only`; `git diff --check` clean; refresh + close commits land; status `done`.

## Context
Stage67 feat `3a0d336` rejected C0/C1/bidi control characters in block `text` with `INVALID_BLOCK_TEXT` (page suite 13/13). Suite now 60 tests (`f6bfaef` closed Stage67). Matrix still cites Stage65 59.

## In Scope
- Matrix gateway row patch (Stage65 59 → Stage67 60).
- Stage68 task docs + `_index.md` row; refresh commit + close commit.

## Out of Scope
- Production/validator change; contract JSON change.

## Assumptions
- None: evidence is the fresh local `discover` run.
