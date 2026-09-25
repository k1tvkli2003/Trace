# Stage 39 local outbox snapshot counts

- Task ID: `2026-09-25-stage-39-local-outbox-snapshot-counts`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Add a read-only outbox snapshot: one call returns per-state row counts (`pending`, `in_flight`, `failed`, `synced`, plus tombstone/unsupported buckets when present) so the worker/drain progress and dead-letter backlog are observable without scanning rows. No state transitions, no clock, no network.

## Success Criteria
- RED test proves the snapshot reader is missing before implementation.
- One read-only call returns deterministic per-state counts covering every inserted row.
- Empty outbox returns all-zero counts, not an empty map.
- Focused snapshot test GREEN; wider data/domain/app/Gateway suites GREEN.

## Context
- Repo: `C:/Users/K1/Desktop/Projects/Trace`, branch `master`.
- Stage31 built claim/ack/failure/requeue; Stage32 ordered the pending queue; Stage33 bounded retries with dead-letter `failed`; Stage34 added pure `retryDelay`; Stage35 atomic `claimNext`; Stage36 explicit `releaseClaim`; Stage37 single-pass `runNext`; Stage38 bounded `drain`.
- Missing piece: no cheap observable of queue depth per state. `listOperations()` exists but forces callers to scan and fold rows themselves.
- `supabase/README.md` confirms no real project/transport; scope stays local.

## In Scope
- New focused test `packages/trace_data/test/local_oplog_snapshot_counts_test.dart`.
- One read-only counter on `LocalOplogRepository` (pure read, no transitions).
- Task docs for Stage39 and `_index.md` row.

## Out of Scope
- State transitions, claim/ack/requeue changes.
- Clock, sleep, timers, background scheduler wiring.
- Retry delay enforcement, server-ack transport, Supabase, migrations, RLS, Storage.
- OCR, Vision, ingestion, UI, release builds.

## Assumptions
- Single-writer tests; concurrent mutation during a snapshot remains out of scope (same TOCTOU note as Stage33/35/38).
- Counts are a point-in-time read, not a consistency guarantee across concurrent writers.
