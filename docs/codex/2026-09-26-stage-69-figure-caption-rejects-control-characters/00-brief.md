# Stage 69 figure caption rejects control characters

- Task ID: `2026-09-26-stage-69-figure-caption-rejects-control-characters`
- Status: `done`
- Created: 2026-09-26
- Language: en

## Request
Close the fail-closed hole where figure `caption` carrying control/format-invisible characters is accepted as source transcription. Probe at Stage68 HEAD (`93f8d4c`, suite 60/60) showed `caption-nul`, `caption-bidi`, `caption-c0-del` all `ACCEPTED-HOLE`, while block `text` already rejects the same ranges via `_CONTROL_TEXT` (Stage67).

## Success Criteria
- New failing test fails RED before the fix with `ContractFailure not raised` (caption `NUL`, `U+202E`, `DEL`).
- After the minimal validator fix, `python -m unittest test_page_extract -v` is GREEN and gateway `discover` is 61/61 OK.
- `validate_task_docs.py <task> --structure-only` passes; `git diff --check` clean; feat + close commits.

## Context
`services/ai_gateway/page_extract.py` caption path checks `isinstance`, `strip`, `_MAX_CAPTION`, `_UNSAFE` only. `_CONTROL_TEXT` (ranges `00-08`, `0B-0C`, `0E-1F`, `7F-9F`, `202A-202E`, `2066-2069`) is applied to block `text` but not to `caption`.

## In Scope
- One RED test (`caption` with `NUL`, `U+202E`, `DEL`).
- One minimal GREEN fix: apply `_CONTROL_TEXT` to the figure caption check.

## Out of Scope
- Block `text` path (done Stage67); bbox/confidence/order (done Stage63/65); schema file change; count refresh (next stage).

## Assumptions
- `INVALID_FIGURE_CAPTION` is the correct existing code for caption rejection; no new error code needed.
