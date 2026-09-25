# Stage 40 local outbox drain throw propagation

- Task ID: `2026-09-25-stage-40-local-outbox-drain-throw-propagation`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Close the FAIL-CLOSED finding from the Stage38 independent review
(`deleg_05e06418`): the handler-throw contract of
`LocalOutboxWorker.drain` is documented in the docstring but no test
pins it. Add a drain-level test proving a handler throw propagates
(not swallowed), rows settled before the throw stay settled in the
database, the in-flight claim is left `in_flight` and releasable via
`releaseClaim`.

## Non-Goals
No production-code change is expected: `drain`/`runNext` already carry
no try/catch. No new SQL, transition, clock, sleep, network, migration,
Supabase, or OCR. No server-ack transport. `StudyHub-Web` stays
untouched.

## Success Criteria
- New drain-level test proves a handler throw completes the `drain`
  future with the same error (not swallowed into a partial list).
- Test proves rows settled before the throw stay `synced` in the DB.
- Test proves the throwing claim stays `in_flight` and is releasable
  via `releaseClaim` back to `pending`.
- Focused drain test GREEN 7/7 against unchanged production code;
  wider data/domain/app/Gateway suites GREEN.
