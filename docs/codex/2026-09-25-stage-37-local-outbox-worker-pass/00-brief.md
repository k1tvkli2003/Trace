# Stage 37 local outbox worker pass

- Task ID: `2026-09-25-stage-37-local-outbox-worker-pass`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Close the worker gap in the local outbox: wire `claimNext`, `acknowledge`, `recordFailure`, `requeueFailed`/`canRequeue` into one explicit single-pass worker step with an injected handler. No loop, clock, sleep, network, or Supabase.

## Success Criteria
- RED test proves worker pass is missing before implementation.
- GREEN `runNext` claims head, acknowledges on handler success, records failure and requeues within budget, leaves exhausted rows `failed`, returns `null` on empty queue.
- Full suites stay GREEN; docs end `ready-for-review` with validator OK.

## Context
Stage31 lifecycle, Stage32 queue, Stage33 budget, Stage34 backoff, Stage35 atomic `claimNext`, Stage36 explicit `releaseClaim` are committed (`dca85d1`). No worker composes them yet; `supabase/README.md` confirms no project/service exists.

## In Scope
- `LocalOutboxWorker.runNext({handler, maxRetries})` in `trace_data`.
- Focused `local_oplog_worker_pass_test.dart` (success ack, failure requeue, exhausted stays failed, empty null).
- Task docs for this slice only.

## Out of Scope
- Continuous loops, clocks, sleep/delay waiting, schedulers, lease timeouts.
- Schema/migration, network, Supabase/RLS/Storage, OCR.

## Assumptions
- Single local worker; handler is injected `Future<bool> Function(SyncOperation)`.
- `retryDelay` stays a separate pure calculation; this pass does not wait.
