# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex
- Provenance: slice committed in `4f55712` ancestor of HEAD.

## Current State
`listDueFailedWithinBudget` added and GREEN. Focused 3/3 pass. Full suites pass: data 153/153, domain 114/114, app 41/41, Gateway 50. Analyzers and format clean. Record closes with validator OK; review `deleg_031e9984` already recorded.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Use caller-owned due-time map instead of schema/failedAt migration | Schema change would expand migration surface; durable clock still absent | `trace_database.dart`, `local_oplog_repository.dart` |
| 2026-09-25 | Keep Stage41 ordering and `<=` budget semantics | Consistent queue ownership | Stage33/Stage41 tests |
| 2026-09-25 | Validate every map entry eagerly, exclude missing due instead of defaulting | Caller map has no provenance; eager parse fails closed even for unused keys, while absent keys cannot invent readiness | Stage42 RED/GREEN |

## Blockers
- None

## Done
- Focused RED test written; missing-method RED confirmed.
- Minimal `listDueFailedWithinBudget` plus shared `_parseUtc`; refactored `nextRetryAtUtc` onto the same parser; focused 3/3 GREEN.
- Full suites GREEN; analyzers and format clean.

## Remaining
- None for this record; committed in `4f55712` ancestor of HEAD.
