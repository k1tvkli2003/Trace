# State

- Current status: `ready-for-review`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
Figure-kind block with text now rejected (`FIGURE_BLOCK_MUST_BE_TEXTLESS`). RED observed first, then GREEN. Page-extract 7/7, gateway 54/54.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Figure anchor holds no transcription; caption lives in figure record | Prevents smuggled transcription under figure kind | Probe `FIGURE-TEXT-ACCEPTED` at HEAD `a08ebdd` |

## Blockers
- None

## Done
- RED: `AssertionError: ContractFailure not raised`.
- GREEN: `FIGURE_BLOCK_MUST_BE_TEXTLESS` check.
- Page-extract 7/7 OK, gateway 54/54 OK.

## Remaining
- Validate docs, diff-check, commit.
