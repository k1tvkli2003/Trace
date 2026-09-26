# State

- Current status: `ready-for-review`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
RED test confirmed the caption control-character hole (`NUL`, `DEL`, U+202E in `fig-1.caption` accepted). GREEN fix applied (`_CONTROL_TEXT.search(caption)` in the caption check, reusing `INVALID_FIGURE_CAPTION`).

Full gateway suite GREEN 61/61. Feat commit pending.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Reject control/format-invisible chars in figure `caption` | Probe at Stage68 HEAD showed `caption-nul`, `caption-bidi`, `caption-c0-del` all accepted; same ranges block `text` rejects since Stage67 | `05-verification.md` |

## Open Questions
- None.

## Blockers
- None.

## Next
- Validate docs; `diff --check`; feat commit + close commit.

## Remaining
- Fill progress/verification/handoff/previews; validate docs; `diff --check`; feat commit + close commit.
