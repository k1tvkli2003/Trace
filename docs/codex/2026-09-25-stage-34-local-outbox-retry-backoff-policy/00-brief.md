# Stage 34 local outbox retry backoff policy

- Task ID: `2026-09-25-stage-34-local-outbox-retry-backoff-policy`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Bound the *timing* of local outbox retries. Stage33 bounds *how many* requeues are allowed; without a delay rule a caller can still hot-loop failed rows. Add a deterministic, pure backoff policy for local retry scheduling.

## Success Criteria
- A pure deterministic retry-delay function exists for local outbox rows.
- Delay grows with `retryCount` and caps at a maximum; invalid budgets fail closed.
- Focused test proves RED before GREEN and GREEN after minimal implementation.
- Wider suites stay GREEN; no migration, clock authority, network, Supabase, OCR, or model change.

## Context
Repo `C:/Users/K1/Desktop/Projects/Trace`, branch `master`, HEAD `7ad54cc`. Stages 31-33 closed the local claim/ack/failure/requeue lifecycle, deterministic queue order, and bounded retry budget on `LocalOplogRepository`. No sync transport exists (`supabase/README.md` boundary only).

## In Scope
- Pure delay policy on `LocalOplogRepository` (e.g. exponential backoff with cap).
- Focused Dart test in `packages/trace_data/test/`.
- Task docs plus narrow verification.

## Out of Scope
- Wall-clock scheduling, timers, workers, server ack transport, RLS, Storage.
- Schema migration, payload changes, tombstone semantics, OCR, Vision, models.
- `StudyHub-Web` (reference only, untouched).

## Assumptions
- Caller owns when to wait; this slice only answers "how long" deterministically.
- Device clock is not retry authority; no `DateTime.now()` in the policy.
