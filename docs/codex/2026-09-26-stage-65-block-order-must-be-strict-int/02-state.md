# State

- Current status: `done`
- Last updated: 2026-09-26
- Owner: Codex
- Feat commit: `bc2c01e`

## Current State
RED test confirmed the float-order hole (`order=1.0` accepted via `1.0 == 1`). GREEN fix applied: order check now requires `type(order) is int`. Full gateway suite GREEN 59/59. Committed as feat `bc2c01e`.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Require `type(order) is int`, keep `BLOCKS_NOT_ORDERED` code | `1.0 == 1` passed the equality check; strict type excludes `bool`/`float` impostors | live probe at Stage64 HEAD |
| 2026-09-26 | Leave `confidence: 1` (int) accepted | JSON numbers are not split int/float at runtime; `1 == 1.0` in range is legitimate value acceptance | probe `float-confidence` |

## Blockers
- None

## Done
- RED test added and confirmed RED.
- GREEN fix applied; `test_page_extract -v` 12/12; gateway `discover` 59/59 OK.

## Remaining
- None — stage closed at feat `bc2c01e` + close commit.
