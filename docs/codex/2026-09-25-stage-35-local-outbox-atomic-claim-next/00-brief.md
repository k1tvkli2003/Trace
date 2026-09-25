# Stage 35 local outbox atomic claim next

- Task ID: `2026-09-25-stage-35-local-outbox-atomic-claim-next`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Close the list-then-claim race in the local outbox: one atomic `claimNext()` that picks the queue head and marks it `in_flight` in a single transaction. Returns `null` when no pending row exists.

## Success Criteria
- New failing test proves `claimNext` is missing before implementation.
- `claimNext()` returns queue head (`createdAt`, then `operationId`) as `in_flight`.
- Empty queue returns `null`; second call skips already-claimed row.
- Full suites stay GREEN; docs validator OK; independent review passes; commit lands.

## Context
- Repo `C:/Users/K1/Desktop/Projects/Trace`, branch `master`, parent `7d869ed` (Stage34).
- Stage31 gave `claimPending(id)`; Stage32 gave `listReadyToClaim` ordering; Stage33/34 gave budget + backoff. Two workers calling list-then-claim can both see the same head (TOCTOU, noted in Stage33 report).
- Local-only, no clock/network/migration/Supabase/OCR.

## In Scope
- `LocalOplogRepository.claimNext()` atomic pick-and-claim.
- Focused test `local_oplog_claim_next_test.dart`.
- Task docs + validator + review + commit.

## Out of Scope
- Retry budget/backoff changes, scheduler wiring, server ack, Supabase, RLS, CI/release.

## Assumptions
- Single-device SQLite semantics: one writer transaction at a time; conditional-write pattern from `_writeTransition` is sufficient.
