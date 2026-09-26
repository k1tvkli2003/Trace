# Plan

## Approach
TDD slice: add one failing ID-hygiene test (RED), harden `_require_id` with the existing `_CONTROL_TEXT`/`_UNSAFE` regexes plus surrounding-whitespace rejection (GREEN), run full suites, fill docs, validate, feat commit, flip to `done`, close commit.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | RED test: padded/control/HTML IDs rejected |
| 2 | planned | GREEN `_require_id` hardening |
| 3 | planned | 15/15 + 62/62 evidence; docs validated; feat + close commits |

## Interfaces and Artifacts
- `services/ai_gateway/page_extract.py` (`_require_id`)
- `services/ai_gateway/test_page_extract.py` (ID-hygiene test)
- `docs/codex/2026-09-26-stage-71-entity-ids-must-be-clean/` (task docs)
- `docs/codex/_index.md` (Stage71 row)

## Risks
- None known: same regexes already guard text/caption; IDs get identical treatment.

## Acceptance Checks
- RED `ContractFailure not raised` before fix; GREEN after.
- `validate_task_docs.py ... --structure-only` passes; `git diff --check` clean.
