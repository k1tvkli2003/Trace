# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Hermes

## Current State
Local Vision cache exists at schema v11. Hits require the same key and pixel hash. Writes require a real rendered page and a complete bound extract.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Unique index created with `IF NOT EXISTS` | Drift table creation can already create the declared index | migration failure |
| 2026-09-25 | Page ID convention `page-<n>` | Current rendered-page identity in tests and worker | repository tests |

## Blockers
- None

## Done
- Cache table, repository, hit/miss, forgery, corruption, and v10-to-v11 migration

## Remaining
- None for this slice
