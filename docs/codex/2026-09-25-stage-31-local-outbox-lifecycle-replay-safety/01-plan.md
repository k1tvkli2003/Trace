# Plan

## Approach
Use the smallest coherent local-outbox slice: add explicit, immutable-payload
transitions on `LocalOplogRepository` for claim/ack/failure/requeue only.
Tombstone remains rejected as out of scope. Stale same-ID replay must keep
failing closed through the existing exact-immutable `putBatch` guard.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Focused RED lifecycle test written first; committed slice `5c93ac1`. |
| 2 | done | RED verified with missing transition API. |
| 3 | done | Minimal claim/ack/failure/requeue methods added, no migration. |
| 4 | done | GREEN plus full data/domain/app/Gateway suites recorded in `05-verification.md`. |
| 5 | done | Docs, validator, commit, and honest handoff; record close pending commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`
- `packages/trace_data/test/local_oplog_lifecycle_test.dart`
- `docs/codex/2026-09-25-stage-31-local-outbox-lifecycle-replay-safety/`
- `docs/codex/_index.md`

## Risks
- Accidental migration or schema edit: avoid by editing only repository logic,
  keeping `TraceDatabase` and generated code untouched.
- Overbroad sync semantics: reject tombstone/finality questions outside this
  slice explicitly in code and docs.
- Claiming remote sync: keep language local-only; no server ack exists.

## Acceptance Checks
- Focused lifecycle test RED before GREEN.
- `dart test` in `packages/trace_data` passes.
- `dart test` in `packages/trace_domain` passes.
- `flutter test --no-pub` in `apps/trace_flutter` passes.
- `python -m unittest discover -s services/ai_gateway -p 'test_*.py'` passes.
- Analyzers clean on touched packages/app.
- Task docs validator passes.
- `git diff --check` clean.
