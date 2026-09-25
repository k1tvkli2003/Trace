# Handoff

## Outcome
Local outbox retry loop is now bounded: `LocalOplogRepository.requeueFailed(id, {maxRetries = 5})` requeues only within budget; exhausted rows stay `failed` as a local dead-letter with `retryCount` preserved. Pure `LocalOplogRepository.canRequeue` exposes the same rule without a DB hit. No migration, no network, no Supabase change.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: bounded `requeueFailed` + `canRequeue` + budget validation.
- `packages/trace_data/test/local_oplog_retry_policy_test.dart`: focused 4-case retry-policy test.
- `docs/codex/2026-09-25-stage-33-local-outbox-bounded-retry-policy/`: full task record.
- `docs/codex/_index.md`: Stage33 row.

## How To Continue
- Next slice: backoff/delay policy (clock-owned, caller-side) or server ack transport against a real Supabase project (none exists yet per `supabase/README.md`).
- Claiming stays on Stage31 conditional-write path; queue order stays on Stage32 `listReadyToClaim`; this slice only bounds requeue.

## Done
- RED retry evidence captured before implementation.
- Minimal bounded retry without migration.
- Focused 4/4 GREEN; wider suites GREEN (data 122, domain 114, app 41, Gateway 50).
- Analyzers clean; format and diff checks clean.

## Remaining
- None for this record; committed in `7ad54cc` ancestor of HEAD.
- Real sync transport, RLS, Storage, background workers, platform and CI evidence remain open and out of scope.

## Verification
- See `05-verification.md`: result passed (validator `OK`). All claims above are backed by commands actually run on 2026-09-25.
- `StudyHub-Web` untouched.
