# Stage 32 local outbox pending queue ordering

- Task ID: `2026-09-25-stage-32-local-outbox-pending-queue-ordering`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Close the next unsafe gap after Stage31: `LocalOplogRepository` can transition single rows by ID, but a worker has no deterministic way to pick the next pending row. Add only a minimal local pending-queue reader with stable ordering. No network, no Supabase, no migration, no model change.

## Success Criteria
- One focused test proves: only `pending` rows are returned; order is `createdAt` ascending then `operationId` ascending; `limit` bounds the result; invalid limit fails closed; empty queue returns empty.
- Test is written and run RED before production changes, then GREEN.
- No migration, no schema change, no remote call, no OCR, no AvalAI/OpenHUB.
- Stage32 docs record exact evidence and honest limitations.
- `StudyHub-Web` untouched.

## Context
- Repository: `C:/Users/K1/Desktop/Projects/Trace`
- HEAD at start: `5c93ac1 feat: add local outbox claim ack failure requeue lifecycle`
- Stage31 added `claimPending`/`acknowledge`/`recordFailure`/`requeueFailed` plus `readOperation`, all local-only with conditional state writes. `listOperations()` returns all rows with no ordering guarantee, so two workers or two runs can pick different "next" rows.
- `supabase/README.md` states no project, migration or deployed service exists. This stage extends only local queue ordering, not real sync.

## In Scope
- Focused queue-ordering test for `LocalOplogRepository`.
- Smallest queue reader needed for that test, inside the existing repository.
- Stage32 work docs, verification receipt, handoff, and index status.

## Out of Scope
- Supabase project/auth/deployment, production schema migration, RLS, Storage.
- Network transport, second-device sync, background workers, notifications.
- Changes to `C:/Users/K1/Desktop/Projects/StudyHub-Web`.
- Model/provider routing or cost changes, Vision calls, OCR.
- Tombstone/delete sync semantics, server ack, crash reaper.

## Assumptions
- Local-first only: queue order is a local read convenience; claiming still goes through the explicit Stage31 transition path.
- Ordering key is `createdAt` then `operationId`; both are already stored and immutable per `putBatch`.
- Existing `sync_operations_state_created` index already covers `(syncState, createdAt)`; no schema change needed.
