# Plan

## Approach
TDD tracer bullet: failing test first for the single-call health split, then minimal read-only `outboxHealth` folding existing rows once and reusing `canRequeue` for the failed side.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | `local_oplog_health_snapshot_test.dart` written; RED captured; committed `04ca2f7`. |
| 2 | done | `OutboxHealth` + `outboxHealth` added; focused 3/3 GREEN. |
| 3 | done | Full suites + independent review `deleg_a9a9d0f4` recorded in `05-verification.md`; validator OK; record closes with this commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: new `OutboxHealth` record + `outboxHealth`.
- `packages/trace_data/test/local_oplog_health_snapshot_test.dart`: focused tests.
- `docs/codex/2026-09-25-stage-45-local-outbox-health-snapshot/`: task record.

## Risks
- Duplicating budget semantics instead of reusing `canRequeue`; mitigated by calling the pure predicate.

## Acceptance Checks
- Focused test GREEN; data/domain/app/Gateway suites exit 0; format clean; validator OK; scans clean.
