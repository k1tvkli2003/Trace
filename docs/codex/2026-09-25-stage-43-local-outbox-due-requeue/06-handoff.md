# Handoff

## Outcome
Due failed rows now transition back to pending deterministically without any clock, scheduler, schema, network, or server-ack: `LocalOplogRepository.requeueDueFailedWithinBudget` composes the Stage42 read-only due filter with the Stage33 single-row requeue. RED was watched first (undefined method), then minimal GREEN.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `requeueDueFailedWithinBudget` composing filter + transition.
- `packages/trace_data/test/local_oplog_due_requeue_test.dart`: 2 focused tests.
- `docs/codex/2026-09-25-stage-43-local-outbox-due-requeue/`: full task record.
- `docs/codex/_index.md`: Stage43 row.

## How To Continue
- Next slice: `failedAt` storage per row (schema/migration), a clock owner for `now >= due`, or server-ack transport against a real Supabase project (none exists per `supabase/README.md`).
- Queue on Stage32; budget on Stage33; delay on Stage34; atomic pick on Stage35; release on Stage36; single pass on Stage37; bounded drain on Stage38; snapshot on Stage39; throw contract on Stage40; retry math on Stage41; due filter on Stage42. This slice only adds the due-gated transition over those pieces.

## Done
- Failing test written; RED confirmed.
- Minimal implementation; focused 2/2 GREEN; format clean.
- Full suites GREEN (data 155, domain 114, app 41, Gateway 50); analyzers clean.

## Remaining
- Independent review, docs validation, scans, commit.

## Verification
- See `05-verification.md`: result passed for all executed checks.
- All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
