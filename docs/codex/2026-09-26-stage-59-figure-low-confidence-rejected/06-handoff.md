# Handoff

## Outcome
Figure below 0.5 is rejected with `LOW_CONFIDENCE_FIGURE_REJECTED`. No quarantine path exists for figures, so reject is fail-closed.

## Changed Artifacts
- `services/ai_gateway/page_extract.py` (figure floor check)
- `services/ai_gateway/test_page_extract.py` (new rejection test)
- `docs/codex/2026-09-26-stage-59-figure-low-confidence-rejected/` (this task)

## How To Continue
- Validate docs, diff-check, commit.

## Done
- RED observed, GREEN achieved, suites green.

## Remaining
- Commit.
