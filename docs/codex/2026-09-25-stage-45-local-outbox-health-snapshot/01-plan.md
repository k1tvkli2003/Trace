# Plan

## Approach
TDD tracer bullet: failing test first for the single-call health split, then minimal read-only `outboxHealth` folding existing rows once and reusing `canRequeue` for the failed side.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Write `local_oplog_health_snapshot_test.dart`; watch RED (record missing) |
| 2 | planned | Add `OutboxHealth` + `outboxHealth({maxRetries = 5})`; watch focused GREEN |
| 3 | planned | Run full suites + analyzers; fill state/progress/verification/handoff; validate; scan; commit |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: new `OutboxHealth` record + `outboxHealth`.
- `packages/trace_data/test/local_oplog_health_snapshot_test.dart`: focused tests.
- `docs/codex/2026-09-25-stage-45-local-outbox-health-snapshot/`: task record.

## Risks
- Duplicating budget semantics instead of reusing `canRequeue`; mitigated by calling the pure predicate.

## Acceptance Checks
- Focused test GREEN; data/domain/app/Gateway suites exit 0; format clean; validator OK; scans clean.
