# Plan

## Approach
TDD RED: add one failing contract test for the missing workflow; GREEN: add a minimal CI-only `ci.yml` mirroring the Stage30 runbook (no secrets, no publish); verify locally with parse/contract checks plus targeted suite spot-checks. Docs-only close after: no GitHub run claim.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: `tool/test_ci_workflow_contract.py` failed on missing `.github/workflows/ci.yml` (`FileNotFoundError` + failed existence assert) |
| 2 | done | GREEN: `.github/workflows/ci.yml` + `tool/check_task_docs_structure.py` (CI docs job); contract 2/2 pass |
| 3 | done | Verify: YAML parse + contract OK; docs-structure 39 tasks OK; full validator pending final fill |
| 4 | done | Fill state/progress/verification/handoff + `_index.md`; commits `fcbecdd`, `41db80a`, `ca5b7bd` |

## Interfaces and Artifacts
- `.github/workflows/ci.yml` (new, CI checks only)
- Contract test (new, fails before GREEN)
- `docs/codex/2026-09-25-stage-47-ci-workflow-foundation/*`, `docs/codex/_index.md`

## Risks
- No remote/runner: CI run itself is NOT verifiable here — mitigated by explicit no-run-claim in brief/verification/matrix.
- Flutter/Dart in CI may drift from local 3.44.0/3.12.0 — mitigated by pinning version string + documenting drift as known issue.

## Acceptance Checks
- Contract test fails RED before workflow, passes GREEN after.
- Workflow parses; triggers/permissions/jobs match brief; no `secrets.` reference.
- `validate_task_docs.py` OK; `git diff --check` clean.
