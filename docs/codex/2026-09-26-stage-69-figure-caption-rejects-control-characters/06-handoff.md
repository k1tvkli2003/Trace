# Handoff

## Outcome
Figure `caption` carrying control/format-invisible characters now raises `INVALID_FIGURE_CAPTION` (pending feat commit).

## Changed Artifacts
- `services/ai_gateway/page_extract.py` (caption check: `_CONTROL_TEXT.search(caption)`)
- `services/ai_gateway/test_page_extract.py` (`test_rejects_figure_caption_with_control_characters`)
- `docs/codex/2026-09-26-stage-69-figure-caption-rejects-control-characters/`
- `docs/codex/_index.md` (Stage69 row)

## How To Continue
- Validate docs, `diff --check`, feat commit, flip Stage69 to `done`, close commit.

## Done
- RED confirmed + GREEN 14/14 page, 61/61 gateway.

## Remaining
- Docs validation; `diff --check`; feat + close commits.

## Verification
- Evidence GREEN (see `05-verification.md`); docs validation + commits pending.

## Next
- Verification/handoff/previews; docs validation; `diff --check`; feat + close commits.
