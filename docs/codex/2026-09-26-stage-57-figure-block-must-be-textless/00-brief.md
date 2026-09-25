# Stage 57 figure block must be textless

- Task ID: `2026-09-26-stage-57-figure-block-must-be-textless`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Reject figure-kind block carrying text. Figure anchor holds no transcription; caption lives in figure record only.

## Success Criteria
- Figure block with non-empty text raises `FIGURE_BLOCK_MUST_BE_TEXTLESS`.
- Happy fixture (`b3` text empty) still passes.
- Gateway suite 54/54 green.

## Context
Probe at HEAD `a08ebdd` showed `FIGURE-TEXT-ACCEPTED` when `b3` text set. Validator checks `unknown` quarantine, empty uncertain, but never figure text.

## In Scope
- `services/ai_gateway/page_extract.py` figure-text check.
- `services/ai_gateway/test_page_extract.py` new case.
- Stage57 task docs.

## Out of Scope
- Schema change, Vision, cost, Supabase, builds, device/browser/CI.

## Assumptions
- Empty string required; whitespace-only also rejected.
