# Handoff

## Outcome
Certain text-bearing blocks (`heading`, `paragraph`, `list`, `table`, `formula`, `caption`, `footnote`) with `uncertain=false` and empty/whitespace `text` are now rejected with `EMPTY_TEXT_BLOCK_REJECTED`. `figure` and `unknown` keep their dedicated codes.

## Changed Artifacts
- `services/ai_gateway/page_extract.py` (`_TEXT_KINDS`, `EMPTY_TEXT_BLOCK_REJECTED` rule)
- `services/ai_gateway/test_page_extract.py` (`test_rejects_certain_text_block_without_text`)
- `docs/codex/2026-09-26-stage-61-certain-text-blocks-must-carry-text/` (brief/plan/state/progress/verification/previews; handoff pending final commit SHAs)
- `docs/codex/_index.md` (Stage61 row; status to `done` after close commit)

## How To Continue
- Next: Stage62 gateway suite count refresh (matrix still cites Stage59 55 tests; suite is now 56 after Stage61).

## Done
- RED test + RED verification + GREEN rule + GREEN suites (9/9 page, 56/56 gateway) + feat `e4540a7`.

## Remaining
- None.

## Verification
- Code GREEN + docs validated + `diff --check` clean (see `05-verification.md`); close commit SHA recorded below after push.
