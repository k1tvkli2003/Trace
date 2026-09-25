# State

- Current status: `done`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
Floor check committed (`0e9415d`). Figure below 0.5 rejected. Matrix row still cites 54; 54 -> 55 refresh stays remaining. RED observed first, then GREEN. Page-extract 8/8, gateway 55/55.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Reject figure below block floor instead of quarantining | Figure record has no `uncertain` field, so reject is the only fail-closed option | Contract textless/quarantine rule, schema fields |

## Remaining
- Validate docs, diff-check, commit.
