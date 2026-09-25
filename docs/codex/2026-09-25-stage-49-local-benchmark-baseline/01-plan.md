# Plan

## Approach
TDD RED->GREEN: contract test first (fails: no `benchmarks/` baseline), then a minimal stdlib runner that re-times manifest/SHA-256/PDF reads over the synthetic fixture and writes one timestamped JSON baseline.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED contract `tool/test_benchmark_baseline_contract.py` failed 2/2, no `benchmarks/baseline-*.json` |
| 2 | done | GREEN `benchmarks/run_local_baseline.py` stdlib-only runner, N=20, wrote `baseline-Keyvan-20260925.json` |
| 3 | done | Matrix `MISSING` -> `SCAFFOLD (local-only baseline)`; contract GREEN 2/2, validator OK, diff-check clean |
| 4 | planned | Validate docs, diff-check, commit |

## Interfaces and Artifacts
- `tool/test_benchmark_baseline_contract.py` (new, unittest contract)
- `benchmarks/run_local_baseline.py` (new, stdlib only)
- `benchmarks/baseline-*.json` (one generated artifact, committed as evidence)
- `docs/qa/acceptance-matrix.md` (Benchmarks row only)
- Stage49 task docs + `docs/codex/_index.md`

## Risks
- Host clock jitter: mitigated by reporting min/median/max over 20 runs, never a single number as budget.

## Acceptance Checks
- `python -m unittest tool.test_benchmark_baseline_contract -v` passes locally (2/2).
- `validate_task_docs.py` OK for the Stage49 folder; `git diff --check` clean.
