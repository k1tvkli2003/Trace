# Handoff

## Outcome
Exhausted failed rows are now listable read-only without any transition, clock, scheduler, schema, or network: `LocalOplogRepository.listFailedOverBudget` is the dead-letter complement of the Stage41 within-budget list. RED was watched first (undefined method), then minimal GREEN.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `listFailedOverBudget`.
- `packages/trace_data/test/local_oplog_dead_letter_test.dart`: 2 focused tests.
- `docs/codex/2026-09-25-stage-44-local-outbox-dead-letter-listing/`: full task record.
- `docs/codex/_index.md`: Stage44 row.

## How To Continue
- Next slice: surface the dead-letter set in worker/drain observability, `failedAt` storage per row (schema/migration), a clock owner for `now >= due`, or server-ack transport against a real Supabase project (none exists per `supabase/README.md`).
- Budget on Stage33; retry candidates on Stage41; due filter on Stage42; due transition on Stage43. This slice only adds the exhausted-side reader.

## Done
- Failing test written; RED confirmed.
- Minimal implementation; focused 2/2 GREEN; format clean.
- Full suites GREEN (data 157, domain 114, app 41, Gateway 50); analyzers clean.

## Remaining
- Independent review, docs validation, scans, commit.

## Verification
- See `05-verification.md`: result passed for all executed checks.
- All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
