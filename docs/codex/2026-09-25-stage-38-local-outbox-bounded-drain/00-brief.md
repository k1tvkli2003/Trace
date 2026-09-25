# Stage 38 local outbox bounded drain

- Task ID: `2026-09-25-stage-38-local-outbox-bounded-drain`
- Status: `ready-for-review`
- Created: 2026-09-25T15:18:33
- Language: en

## Request
Compose the Stage37 single-pass `LocalOutboxWorker.runNext` into a bounded multi-pass drain. One call should settle up to N queue heads in deterministic order without an unbounded loop, clock, sleep, or network.

## Success Criteria
- RED test proves `drain` is missing before implementation.
- `drain({handler, maxRetries, maxPasses})` settles heads in `createdAt` then `operationId` order.
- Empty queue stops early and returns what settled (possibly empty).
- `maxPasses < 1` fails closed with `ArgumentError`.
- Focused drain test GREEN; wider data/domain/app/Gateway suites GREEN.

## Context
- Repo: `C:/Users/K1/Desktop/Projects/Trace`, branch `master`.
- Stage37 delivered `LocalOutboxWorker.runNext` (claim head, ack on true, record+requeue on false within budget, dead-letter `failed` when exhausted, null on empty). Handler throw leaves `in_flight` for explicit `releaseClaim`; the pass never catches.
- Queue order (Stage32), retry budget (Stage33), atomic pick (Stage35), explicit release (Stage36) are the composed primitives.
- `supabase/README.md` confirms no real project/transport; scope stays local.

## In Scope
- New focused test `packages/trace_data/test/local_oplog_bounded_drain_test.dart`.
- Bounded `drain` on `LocalOutboxWorker` reusing `runNext` only.
- Task docs for Stage38 and `_index.md` row.

## Out of Scope
- Clock, sleep, timers, background scheduler wiring.
- Retry delay waiting (`retryDelay` stays a pure timing value, unenforced).
- Server-ack transport, Supabase, migrations, RLS, Storage.
- OCR, Vision, ingestion, UI, release builds.

## Assumptions
- Single worker per drain call; concurrent drain callers remain out of scope (same TOCTOU note as Stage33/35).
- A handler throw propagates without catch; the in-flight claim stays for explicit `releaseClaim` and the already-settled prefix is lost to the throw (documented, not hidden).
