# Handoff

## Outcome
Local outbox crash recovery is now explicit: `LocalOplogRepository.releaseClaim(id)` returns one stranded `in_flight` row to `pending` with retries untouched, so the next worker can `claimNext` it. No clock, migration, network, or Supabase change.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: `releaseClaim` helper.
- `packages/trace_data/test/local_oplog_release_claim_test.dart`: focused 3-case release test.
- `docs/codex/2026-09-25-stage-36-local-outbox-release-claim/`: full task record.
- `docs/codex/_index.md`: Stage36 row.

## How To Continue
- Next slice: worker loop honoring `claimNext` + `releaseClaim` + `canRequeue`/`retryDelay`, or server ack transport against a real Supabase project (none exists yet per `supabase/README.md`).
- Claim order on Stage32; budget on Stage33; delay on Stage34; atomic pick on Stage35; this slice only adds explicit release.

## Done
- RED release evidence captured before implementation.
- Minimal release helper reusing conditional write.
- Focused 3/3 GREEN; wider suites GREEN (data 132, domain 114, app 41, Gateway 50).
- Analyzers clean; format clean.

## Remaining
- None for this record; committed in `dca85d1` ancestor of HEAD.
- Real sync transport, RLS, Storage, background workers, platform and CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed. All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
