# Plan

## Approach
TDD RED->GREEN. Contract test first (fails: no `test/e2e/README.md`). Then a markdown plan that names the §18 flows as `NOT RUN`. Update the acceptance matrix only after GREEN. No runner, no device, no browser.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | RED contract `tool/test_e2e_scaffold_contract.py` fails: missing `test/e2e/README.md` |
| 2 | planned | GREEN `test/e2e/README.md` lists §18 flows as `NOT RUN` |
| 3 | planned | Matrix `MISSING` -> `SCAFFOLD (unrun)` |
| 4 | planned | Validate docs, diff-check, commit |

## Interfaces and Artifacts
- `tool/test_e2e_scaffold_contract.py` (new, unittest contract)
- `test/e2e/README.md` (new, unrun plan)
- `docs/qa/acceptance-matrix.md` (E2E row only)

## Risks
- Over-claiming a device/browser run. Mitigation: README and matrix both say `NOT RUN` / `SCAFFOLD (unrun)`.

## Acceptance Checks
- `python -m unittest tool.test_e2e_scaffold_contract -v` RED then GREEN 2/2.
- `validate_task_docs.py --structure-only` OK after docs filled.
- `git diff --check` clean.
