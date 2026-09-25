# State

- Current status: `ready-for-review`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
Three ownership codes enforced and green: lonely keeps `FIGURE_BLOCK_WITHOUT_FIGURE`, wrong-kind raises `FIGURE_ATTACHED_TO_NON_FIGURE_BLOCK`, shared raises `DUPLICATE_FIGURE_BLOCK`. Page-extract 6/6, gateway 53/53.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Split one lumped code into three | Each violation debugs directly instead of guessing under one code | Stage51/53 history |

## Blockers
- None

## Done
- RED observed for both repointed tests (`FAILED (failures=2)`).
- Split validator, added lonely-block test.
- Page-extract 6/6 OK, gateway 53/53 OK.

## Remaining
- Validate docs, diff-check, commit.
