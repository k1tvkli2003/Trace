# Handoff

## Outcome
Failed outbox rows now have deterministic caller-owned due filtering without any clock, scheduler, schema, network, or server-ack: `LocalOplogRepository.listDueFailedWithinBudget` returns only failed rows within budget whose supplied due time is at or before supplied `nowUtc`. Ordering matches queue ownership (`createdAt`, then `operationId`). RED was watched first (undefined method), then minimal GREEN.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `listDueFailedWithinBudget` plus shared `_parseUtc`; `nextRetryAtUtc` refactored onto the same parser.
- `packages/trace_data/test/local_oplog_due_ready_test.dart`: 3 focused tests.
- `docs/codex/2026-09-25-stage-42-local-outbox-due-ready-filtering/`: full task record.
- `docs/codex/_index.md`: Stage42 row.

## How To Continue
- Next slice: `failedAt` storage per row (schema/migration), a clock owner for `now >= due`, or server-ack transport against a real Supabase project (none exists per `supabase/README.md`).
- Queue on Stage32; budget on Stage33; delay on Stage34; atomic pick on Stage35; release on Stage36; single pass on Stage37; bounded drain on Stage38; snapshot on Stage39; throw contract on Stage40; retry math on Stage41. This slice only adds due-time filtering over Stage41 candidates.

## Done
- Failing test written; RED confirmed.
- Minimal implementation; focused 3/3 GREEN; format clean.
- Full suites GREEN (data 153, domain 114, app 41, Gateway 50); analyzers clean.

## Remaining
- Independent review, docs validation, scans, commit.

## Verification
- See `05-verification.md`: result passed for all executed checks.
- All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
