# Plan

## Approach
TDD tracer: RED with a focused snapshot-counts test calling a missing repository reader, then GREEN with the smallest read-only fold over existing rows. No new table, column, index, or transition.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Write `local_oplog_snapshot_counts_test.dart`; run and capture RED (`countByState` undefined). |
| 2 | planned | Implement read-only `countByState()` on `LocalOplogRepository`; rerun focused test to GREEN. |
| 3 | planned | Run wider suites (data/domain/app/Gateway) + analyzers + format. |
| 4 | planned | Docs (state/progress/verification/handoff), validator, scans, independent review, commit. |

## Interfaces and Artifacts
- `LocalOplogRepository.countByState()` → `Future<Map<domain.SyncState, int>>` covering all six `SyncState` values, zero-filled.
- `packages/trace_data/test/local_oplog_snapshot_counts_test.dart` (new focused test).
- `docs/codex/2026-09-25-stage-39-local-outbox-snapshot-counts/` + `_index.md` row.

## Risks
- Wide-row fetch on a huge outbox could be slower than a SQL `GROUP BY`; mitigation: outbox is a small local queue, and a pure-Dart fold reuses the already-reviewed `_operationFromRow` mapping with zero new SQL surface. A grouped query is future work, not this slice.
- Concurrent writers mid-snapshot give point-in-time counts only; documented, same TOCTOU note as prior stages.

## Acceptance Checks
- RED evidence captured before production change.
- Focused test GREEN (mixed states, empty all-zero, sum equals inserted rows).
- `dart test` / `dart analyze` (data, domain), `flutter test --no-pub` / `flutter analyze --no-pub` (app), `python -m unittest discover` (Gateway) all GREEN.
- Format clean, docs validator `OK`, scans clean, reviewer verdict recorded, single commit, worktree clean.
