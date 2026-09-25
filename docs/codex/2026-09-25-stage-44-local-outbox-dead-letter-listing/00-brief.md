# Stage 44 local outbox dead-letter listing

- Task ID: `2026-09-25-stage-44-local-outbox-dead-letter-listing`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Add a read-only dead-letter listing over the local outbox: failed rows whose `retryCount` exceeds the caller's retry budget, so worker/drain callers can distinguish "retryable failed" from "exhausted failed" without inventing new state.

## Success Criteria
- `LocalOplogRepository.listFailedOverBudget({maxRetries = 5})` returns only `failed` rows with `retryCount > maxRetries`, ordered `createdAt` asc then `operationId` asc.
- Negative `maxRetries` fails closed with `ArgumentError` before any read side-effect worth guarding.
- No transition, clock, sleep, scheduler, schema, or network involvement.

## Context
- Stage33 bounded `requeueFailed` + `canRequeue` defined the dead-letter set (`retryCount > maxRetries` stays `failed`).
- Stage41 added `listFailedWithinBudget` (retryable candidates); the exhausted complement has no first-class reader yet.
- Stage42/43 added caller-owned due filtering and due-gated requeue on top of the within-budget list.

## In Scope
- Read-only `listFailedOverBudget({maxRetries = 5})` on `LocalOplogRepository`.
- Focused test: inclusion/exclusion + deterministic order + invalid budget fails closed.

## Out of Scope
- Any state transition, `failedAt` storage, clock owner, scheduler, transport, Supabase, RLS, migration, OCR, model routing.

## Assumptions
- `retryCount` stays inside `payloadJson` (no DB column); budget filter applies after row mapping, mirroring Stage41.
- Default budget 5 to match `requeueFailed`/`canRequeue`/`runNext`/`drain`.
