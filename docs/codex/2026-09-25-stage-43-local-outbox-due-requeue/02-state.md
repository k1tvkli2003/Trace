# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex
- Provenance: slice committed in `bad9f27` ancestor of HEAD.

## Current State
`requeueDueFailedWithinBudget` added and GREEN. Focused 2/2 pass. Full suites pass: data 155/155, domain 114/114, app 41/41, Gateway 50. Analyzers and format clean. Record closes with validator OK; review `deleg_07174870` already recorded.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Compose due filter with single-row requeue instead of a new bulk SQL path | Keeps budget/wrong-state checks single-sourced; no schema change | `local_oplog_repository.dart` Stage33/Stage42 |
| 2026-09-25 | Keep caller-owned `nowUtc` and due map; no clock or `failedAt` column | Stage42 already established this boundary; durable clock still absent | `trace_database.dart`, Stage42 docs |

## Blockers
- None

## Done
- Focused RED test written; missing-method RED confirmed.
- Minimal `requeueDueFailedWithinBudget` composing filter + `requeueFailed`; focused 2/2 GREEN.
- Full suites GREEN; analyzers and format clean.

## Remaining
- None for this record; committed in `bad9f27` ancestor of HEAD.
