# Stage 31 local outbox lifecycle replay safety

- Task ID: `2026-09-25-stage-31-local-outbox-lifecycle-replay-safety`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Close the smallest unsafe gap left by Stage30: local sync outbox rows can be
created and replayed, but there is no safe local lifecycle for
claim -> ack/failure -> retry. Add only the minimal local transition path
with replay safety. No network, no Supabase, no migration, no model change.

## Success Criteria
- One focused test proves: pending can be claimed to in-flight; in-flight can
  be acked to synced or failed with retry increment; failed can be requeued to
  pending; illegal jumps fail closed; stale same-ID replay cannot overwrite a
  transitioned row; crashed in-flight work can be safely reclaimed only through
  the explicit transition path.
- Test is written and run RED before production changes, then GREEN.
- No migration, no schema change, no remote call, no OCR, no AvalAI/OpenHUB.
- Stage31 docs record exact evidence and honest limitations.
- `StudyHub-Web` untouched.

## Context
- Repository: `C:/Users/K1/Desktop/Projects/Trace`
- HEAD at start: `339f1c3 feat: prove offline source-to-learning vertical slice`
- `LocalOplogRepository.putBatch` treats same-ID replay as exact-immutable;
  there is no claim/ack/failure API. `SyncOperation` already carries
  `pending`, `in_flight`, `synced`, `failed` states and `retryCount`.
- `supabase/README.md` states no project, migration or deployed service exists.
- Stage30 proof stays offline and in-memory; this stage extends only the local
  outbox lifecycle, not real sync.

## In Scope
- Focused lifecycle test for `LocalOplogRepository`.
- Smallest transition API needed for that test, inside the existing repository.
- Stage31 work docs, verification receipt, handoff, and index status.

## Out of Scope
- Supabase project/auth/deployment, production schema migration, RLS, Storage.
- Network transport, second-device sync, background workers, notifications.
- Changes to `C:/Users/K1/Desktop/Projects/StudyHub-Web`.
- Model/provider routing or cost changes, Vision calls, OCR.
- Tombstone/delete sync semantics beyond explicitly scoping them out.

## Assumptions
- Local-first only: transitions are local rows; no server ack exists yet.
- `synced` is terminal locally; `tombstone` stays out of scope for this slice.
- Existing `putBatch` exact-immutable replay remains the guard against stale
  overwrites.
