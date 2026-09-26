# State

- Current status: `done`
- Last updated: 2026-09-26
- Owner: Codex
- Evidence: feat `c00449a`; GREEN 61/61 (`discover -s services/ai_gateway`)

## Current State
RED test confirmed the caption control-character hole (`NUL`, `DEL`, U+202E in `fig-1.caption` accepted). GREEN fix applied (`_CONTROL_TEXT.search(caption)` in the caption check, reusing `INVALID_FIGURE_CAPTION`).

Full gateway suite GREEN 61/61. Feat commit `c00449a` landed; close commit next.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Reject control/format-invisible chars in figure `caption` | Probe at Stage68 HEAD showed `caption-nul`, `caption-bidi`, `caption-c0-del` all accepted; same ranges block `text` rejects since Stage67 | `05-verification.md` |

## Open Questions
- None.

## Blockers
- None.

## Next
- Validate docs; `diff --check`; feat committed `c00449a`; close commit next.

## Remaining
- Close commit only.
