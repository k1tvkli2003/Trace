# Handoff

## Outcome
Local outbox now has an explicit single-pass worker: `LocalOutboxWorker.runNext({handler, maxRetries})` claims the queue head, acknowledges on success, records failure and requeues within budget, leaves exhausted rows `failed`, and returns `null` on an empty queue. No loop, clock, waiting, migration, network, or Supabase change.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_outbox_worker.dart`: `runNext` worker.
- `packages/trace_data/lib/trace_data.dart`: worker export.
- `packages/trace_data/test/local_oplog_worker_pass_test.dart`: focused 4-case worker test.
- `docs/codex/2026-09-25-stage-37-local-outbox-worker-pass/`: full task record.
- `docs/codex/_index.md`: Stage37 row.

## How To Continue
- Next slice: bounded drain loop over `runNext`, or server ack transport against a real Supabase project (none exists yet per `supabase/README.md`).
- Queue on Stage32; budget on Stage33; delay on Stage34; atomic pick on Stage35; release on Stage36; this slice only composes them once per call.

## Done
- RED worker evidence captured before implementation.
- Minimal worker reusing existing conditional writes.
- Focused 4/4 GREEN; wider suites GREEN (data 136, domain 114, app 41, Gateway 50).
- Analyzers clean; format clean.

## Remaining
- None for this record; committed in `ca1dc15` ancestor of HEAD.
- Real sync transport, RLS, Storage, background workers, platform and CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed. All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
