# Handoff

## Outcome
Stage38's FAIL-CLOSED finding is closed: `drain`'s handler-throw
contract is now pinned by a drain-level test. Handler succeeds on the
first head, throws `StateError('boom-throw-b')` on the second; the
drain future completes with that exact error (not a partial list),
exactly 2 handler calls occur, the first row reads back `synced`, the
second stays `in_flight`, and `releaseClaim` returns it to `pending`.

## Changed Artifacts
- `packages/trace_data/test/local_oplog_bounded_drain_test.dart`: new
  throw-propagation test plus `openDrainRepoWith` helper; production
  code unchanged.
- `docs/codex/2026-09-25-stage-40-local-outbox-drain-throw-propagation/`: full task record.
- `docs/codex/_index.md`: Stage40 row.

## How To Continue
- Next slice: server-ack transport against a real Supabase project
  (none exists yet per `supabase/README.md`), or `retryDelay`-aware
  scheduling once a clock owner exists.
- Queue on Stage32; budget on Stage33; delay on Stage34; atomic pick
  on Stage35; release on Stage36; single pass on Stage37; bounded
  drain on Stage38; snapshot on Stage39; this slice only pins the
  documented throw contract.

## Done
- Throw-propagation gap captured as RED (contract documented but
  untested per `deleg_05e06418`).
- One focused test added; passes against unchanged production code.
- Focused 7/7 GREEN; wider suites GREEN (data 146, domain 114,
  app 41, Gateway 50).
- Analyzers clean; format clean.

## Remaining
- None for this record; committed in `5722e25` ancestor of HEAD.
- Real sync transport, RLS, Storage, background workers, platform and
  CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed for all executed checks.
  All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
