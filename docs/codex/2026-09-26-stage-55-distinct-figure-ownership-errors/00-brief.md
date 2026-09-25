# Stage 55 distinct figure ownership errors

- Task ID: `2026-09-26-stage-55-distinct-figure-ownership-errors`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Split lumped `FIGURE_BLOCK_WITHOUT_FIGURE` into three distinct fail-closed codes so each ownership violation debugs directly.

## Success Criteria
- Lonely figure block still raises `FIGURE_BLOCK_WITHOUT_FIGURE`.
- Figure on non-figure block raises `FIGURE_ATTACHED_TO_NON_FIGURE_BLOCK`.
- Shared figure block raises `DUPLICATE_FIGURE_BLOCK`.
- Gateway suite 53/53 green (52 old + 1 lonely-block case).

## Context
`page_extract.py:151-155` lumps duplicate, lonely, wrong-kind into one code. Stages 51/53 locked bijection with one code. Debugging blind.

## In Scope
- `services/ai_gateway/page_extract.py` ownership check split.
- `services/ai_gateway/test_page_extract.py` expectations + missing lonely case.
- Stage55 task docs.

## Out of Scope
- Schema change, Vision, cost, Supabase, builds, device/browser/CI.

## Assumptions
- Bijection contract unchanged, only error codes split.
