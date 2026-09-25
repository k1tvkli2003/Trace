# Handoff

## Outcome
Local pending-queue ordering is closed: `LocalOplogRepository` now exposes `listReadyToClaim` returning only `pending` rows in `createdAt` then `operationId` order with a bounded limit. No migration, no network, no Supabase change.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `listReadyToClaim` reader added.
- `packages/trace_data/test/local_oplog_queue_test.dart`: focused 4-case queue test.
- `docs/codex/2026-09-25-stage-32-local-outbox-pending-queue-ordering/`: full task record.
- `docs/codex/_index.md`: Stage32 row added.

## How To Continue
- Next slice: bounded retry/backoff policy or server ack transport against a real Supabase project (none exists yet per `supabase/README.md`).
- Queue claiming stays on the Stage31 `claimPending` conditional-write path; this reader never auto-claims.

## Done
- RED queue evidence captured before implementation.
- Minimal queue reader without migration.
- Focused 4/4 GREEN; wider suites GREEN (data 118, domain 114, app 41, Gateway 50).
- Analyzers clean; format and diff checks clean.

## Remaining
- None for this record; committed in `be22ee3` ancestor of HEAD.
- Real sync transport, RLS, Storage, background workers, platform and CI evidence remain open and out of scope for this slice.

## Verification
- See `05-verification.md`: result passed. All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
