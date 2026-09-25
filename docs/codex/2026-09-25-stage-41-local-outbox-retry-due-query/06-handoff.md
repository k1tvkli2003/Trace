# Handoff

## Outcome
Failed outbox rows now have a bounded retry-candidate path without any
clock, scheduler, schema, network, or server-ack:
`LocalOplogRepository.listFailedWithinBudget` lists failed rows within
budget in `createdAt` then `operationId` order, and
`LocalOplogRepository.nextRetryAtUtc` maps a caller-supplied UTC failure
instant through the Stage34 `retryDelay` ladder to a UTC ISO-8601 due
time. RED watched first (both members undefined), then minimal GREEN.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`:
  `listFailedWithinBudget` + `nextRetryAtUtc` (read-only query + pure math).
- `packages/trace_data/test/local_oplog_retry_due_test.dart`: 4 focused tests.
- `docs/codex/2026-09-25-stage-41-local-outbox-retry-due-query/`: full task record.
- `docs/codex/_index.md`: Stage41 row.

## How To Continue
- Next slice: `failedAt` storage per row (schema/migration), or a clock
  owner for `now >= due` evaluation, or server-ack transport against a
  real Supabase project (none exists per `supabase/README.md`).
- Queue on Stage32; budget on Stage33; delay on Stage34; atomic pick on
  Stage35; release on Stage36; single pass on Stage37; bounded drain on
  Stage38; snapshot on Stage39; throw contract on Stage40; this slice
  only adds retry-candidate listing and due-time math.

## Done
- Failing test written; RED confirmed.
- Minimal implementation; focused 4/4 GREEN; format clean.
- Full suites GREEN (data 150, domain 114, app 41, Gateway 50);
  analyzers clean.

## Remaining
- None for this record; committed in `4e7f509` ancestor of HEAD.
- Real sync transport, RLS, Storage, background workers, platform and
  CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed for all executed checks.
  All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
