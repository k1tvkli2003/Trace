# Stage 36 local outbox release claim

- Task ID: `2026-09-25-stage-36-local-outbox-release-claim`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Close the stranded-claim gap in the local outbox: an explicit `releaseClaim(id)` returns one `in_flight` row to `pending` without touching `retryCount`.

## Success Criteria
- RED test proves `releaseClaim` is missing before implementation.
- GREEN `releaseClaim(id)` moves `in_flight` to `pending`, immutable payload otherwise.
- Wrong-state/absent rows fail closed with `StateError`.
- Full suites stay GREEN; docs end `ready-for-review` with validator OK.

## Context
Stage31 lifecycle, Stage32 queue, Stage33 budget, Stage34 backoff, Stage35 atomic `claimNext` are committed (`de5fca3`). A crashed worker currently strands rows in `in_flight`: `acknowledge`/`recordFailure` require the same worker, and `claimNext` only picks `pending`.

## In Scope
- `LocalOplogRepository.releaseClaim(id)`: `in_flight` to `pending`, `retryDelta: 0`.
- Focused `local_oplog_release_claim_test.dart` (release, wrong-state fails, absent fails).
- Task docs for this slice only.

## Out of Scope
- Lease timeouts, clocks, schedulers, worker loops, backoff changes.
- Schema/migration, network, Supabase/RLS/Storage, OCR.

## Assumptions
- Single local worker; release is cooperative/explicit, not automatic.
