# State

- Current status: `done`
- Last updated: 2026-09-24
- Owner: Hermes

## Current State
Bounded PDF thumbnail batches and contact sheets exist in the Flutter app. Resume recomputes stable page IDs and rejects checkpoints outside the requested batch. OCR is absent.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-24 | Cap each run at 8 pages | Bound memory and keep checkpoints small | Stage 12 plan |
| 2026-09-24 | Recompute stable IDs on resume | Checkpoint JSON must not invent page identity | audit finding |
| 2026-09-24 | Scale-to-fit contact cells | Navigation grids must not crop page evidence | Stage 12 plan |

## Blockers
- None.

## Done
- Worker, contact sheet, tests, and audit fix.

## Remaining
- Persistence of rasters and contact sheets is a later stage.
