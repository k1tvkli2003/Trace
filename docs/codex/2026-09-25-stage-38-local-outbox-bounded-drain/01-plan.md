# Plan

## Approach
TDD tracer bullet: one focused RED test for a bounded `drain` composed only of repeated `runNext` calls, then the minimal GREEN loop with an explicit `maxPasses` bound and early stop on empty queue.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | `local_oplog_bounded_drain_test.dart` written; RED captured; committed `7a1cb2f` + throw-pin `5722e25`. |
| 2 | done | `drain({handler, maxRetries, maxPasses})` implemented on `LocalOutboxWorker`; GREEN focused test (6/6 with tie-break + throw pin). |
| 3 | done | Wider suites GREEN recorded in `05-verification.md` (data 142, domain 114, app 41, Gateway 50). |
| 4 | done | `dart format`, docs validator, secret/static scans, independent review `deleg_05e06418`, commit; record close pending commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_outbox_worker.dart`: add `Future<List<domain.SyncOperation>> drain({...})`.
- `packages/trace_data/test/local_oplog_bounded_drain_test.dart`: new focused test.
- `docs/codex/2026-09-25-stage-38-local-outbox-bounded-drain/`: task record.

## Risks
- Unbounded loop disguised as drain: mitigated by required `maxPasses >= 1` and a loop counter that stops at the bound even if the queue never empties.
- Hiding handler throws: mitigated by letting throws propagate (same contract as `runNext`) and documenting the settled-prefix loss.
- Scope creep into scheduling/transport: mitigated by brief out-of-scope list; reviewer checks it.

## Acceptance Checks
- Focused drain test: 4/4 GREEN.
- Wider suites GREEN with no regressions.
- `dart analyze` clean, `dart format` 0 changed, docs validator OK, scans clean.
