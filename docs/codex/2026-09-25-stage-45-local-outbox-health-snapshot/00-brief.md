# Stage 45 local outbox health snapshot

- Task ID: `2026-09-25-stage-45-local-outbox-health-snapshot`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Add a single read-only health snapshot over the local outbox so worker/drain callers can observe actionable backlog in one call: pending ready, stranded in-flight, retryable failed, and exhausted dead-letter — without new state, clock, scheduler, transport, or schema.

## Success Criteria
- `LocalOplogRepository.outboxHealth({maxRetries = 5})` returns one snapshot with `pending`, `inFlight`, `failedRetryable`, `failedDeadLetter` counts from a single row scan.
- Failed split reuses `canRequeue` semantics (`retryCount <= maxRetries` retryable, otherwise dead-letter).
- Negative `maxRetries` fails closed with `ArgumentError` before any read worth guarding.
- No transition, clock, sleep, scheduler, schema, or network involvement.

## Context
- Stage33 bounded `requeueFailed` + `canRequeue` defined the budget split.
- Stage39 `countByState()` gives per-state totals but no budget split of failed rows.
- Stage41 `listFailedWithinBudget` and Stage44 `listFailedOverBudget` list each side; no single health reader composes them.

## In Scope
- Read-only `outboxHealth({maxRetries = 5})` on `LocalOplogRepository`, single scan, `canRequeue` for the failed split.
- Focused test: mixed-state seed asserts all four counts + invalid budget fails closed.

## Out of Scope
- Any state transition, `failedAt` storage, clock owner, scheduler, transport, Supabase, RLS, migration, OCR, model routing.

## Assumptions
- Snapshot is point-in-time over existing rows; `synced`/`tombstone` rows are not counted as actionable backlog.
- Default budget 5 to match `requeueFailed`/`canRequeue`/`runNext`/`drain`.
