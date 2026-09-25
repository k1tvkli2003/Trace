# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Hermes

## Current State
Local claim/ack/failure/requeue transitions are GREEN in `LocalOplogRepository`
with no migration. Payload is immutable across transitions; only state and
retry metadata change. Full data/domain/app/Gateway checks pass. Docs are being
closed for review.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Keep `synced` terminal and `tombstone` out of scope | Avoid inventing delete-sync semantics in a lifecycle slice | Stage31 brief |
| 2026-09-25 | No migration or schema change | Existing row already carries state/retry/payload metadata | `trace_database.dart`, `local_oplog_repository.dart` |
| 2026-09-25 | Keep exact-immutable `putBatch` replay guard | Stale writers must not overwrite transitioned rows | `local_oplog_repository_test.dart` |
| 2026-09-25 | Use conditional state write inside transaction | Prevent lost-update transitions when state changes concurrently | Focused lifecycle test |
| 2026-09-25 | Leave `StudyHub-Web` untouched | Protected reference-only constraint | Project memory |

## Blockers
- None.

## Done
- Stage30 committed as `339f1c3` with clean worktree.
- Stage31 brief/plan/state populated.
- RED lifecycle test observed before implementation.
- Minimal lifecycle implementation added without migration.
- Focused test GREEN; full wider suites GREEN.

## Remaining
- None for this record; slice committed in `5c93ac1` ancestor of HEAD. Real sync transport/RLS/Storage/background/CI remain later stages.
