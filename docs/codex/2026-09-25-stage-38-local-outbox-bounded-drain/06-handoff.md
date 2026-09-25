# Handoff

## Outcome
Local outbox now has a bounded drain: `LocalOutboxWorker.drain({handler, maxRetries, maxPasses})` repeats `runNext` up to `maxPasses` times in queue order, stops early on empty, returns settled rows in settle order, and fails closed on `maxPasses < 1`. No loop without bound, clock, sleep, migration, network, or Supabase change.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_outbox_worker.dart`: `drain` method.
- `packages/trace_data/test/local_oplog_bounded_drain_test.dart`: focused 5-case drain test.
- `docs/codex/2026-09-25-stage-38-local-outbox-bounded-drain/`: full task record.
- `docs/codex/_index.md`: Stage38 row.

## How To Continue
- Next slice: server-ack transport against a real Supabase project (none exists yet per `supabase/README.md`), or `retryDelay`-aware scheduling once a clock owner exists.
- Queue on Stage32; budget on Stage33; delay on Stage34; atomic pick on Stage35; release on Stage36; single pass on Stage37; this slice only bounds repeated passes.

## Done
- RED drain evidence captured before implementation.
- Minimal drain reusing `runNext` only.
- Focused 5/5 GREEN; wider suites GREEN (data 141, domain 114, app 41, Gateway 50).
- Analyzers clean; format clean.

## Remaining
- Validator + scans + review + commit (this verify step).
- Real sync transport, RLS, Storage, background workers, platform and CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed. All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
