# Handoff

## Outcome
Local outbox pick-and-claim is now atomic: `LocalOplogRepository.claimNext()` selects the pending head (`createdAt`, then `operationId`) and writes `in_flight` in one transaction, returning `null` on empty queue. No clock, migration, network, or Supabase change.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: atomic `claimNext` helper.
- `packages/trace_data/test/local_oplog_claim_next_test.dart`: focused 3-case claim-next test.
- `docs/codex/2026-09-25-stage-35-local-outbox-atomic-claim-next/`: full task record.
- `docs/codex/_index.md`: Stage35 row.

## How To Continue
- Next slice: worker loop honoring `claimNext` + `canRequeue`/`retryDelay`, or server ack transport against a real Supabase project (none exists yet per `supabase/README.md`).
- Claim order on Stage32; budget on Stage33; delay on Stage34; this slice only closes the list-then-claim race.

## Done
- RED claim-next evidence captured before implementation.
- Minimal atomic helper reusing conditional write.
- Focused 3/3 GREEN; wider suites GREEN (data 129, domain 114, app 41, Gateway 50).
- Analyzers clean; format clean.

## Remaining
- Validator + review + commit (this verify step).
- Real sync transport, RLS, Storage, background workers, platform and CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed. All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
