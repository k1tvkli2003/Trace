# Stage 33 local outbox bounded retry policy

- Task ID: `2026-09-25-stage-33-local-outbox-bounded-retry-policy`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Close the unbounded local requeue loop left by Stage31/Stage32: a failed operation can currently return to pending forever with ever-growing `retryCount` and no dead-letter signal. Add a deterministic local retry budget with no network, clock, or server.

## Success Criteria
- `requeueFailed` enforces a bounded `maxRetries` budget and fails closed when exhausted; exhausted rows stay `failed` with `retryCount` preserved.
- A pure `canRequeue` helper answers retry eligibility without a DB hit.
- Focused retry-policy test is RED before implementation and GREEN after.
- Full data/domain/app/Gateway suites, analyzers, format, docs validator, and `git diff --check` pass; commit is clean.

## Context
- Repo: `C:/Users/K1/Desktop/Projects/Trace`, branch `master`.
- Stage31 (`5c93ac1`) added `claimPending`/`acknowledge`/`recordFailure`/`requeueFailed` on `LocalOplogRepository` with conditional-write transitions and immutable payloads.
- Stage32 (`be22ee3`) added `listReadyToClaim` reader: pending-only, `createdAt` then `operationId` order, bounded limit.
- Neither stage bounds retries: `failed -> pending -> in_flight -> failed` can repeat without limit.
- `supabase/README.md`: no project, migration, or deployed service exists. This stage stays local-only.

## In Scope
- Extend `packages/trace_data/lib/src/local/local_oplog_repository.dart` with bounded `requeueFailed({maxRetries})` plus pure `canRequeue`.
- Add `packages/trace_data/test/local_oplog_retry_policy_test.dart` (in-memory DB, no network).
- Task docs `00`–`06` plus `_index.md` row.

## Out of Scope
- Network transport, server ack, Supabase schema/RLS/Storage, background workers, crash auto-recovery, backoff timers/clocks, tombstone transitions, Vision/OCR, release readiness.
- `StudyHub-Web` changes (reference-only, untouched).

## Assumptions
- `retryCount` counts recorded local failures; `recordFailure` remains the only writer that increments it.
- Default budget `5` is a local sentinel, not a server SLA; callers may pass a tighter bound per operation.
