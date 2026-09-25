# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
`LocalOutboxWorker.drain({handler, maxRetries, maxPasses})` is implemented and GREEN. Focused drain test 6/6; wider suites GREEN (data 142, domain 114, app 41, Gateway 50). Reviewer gaps closed. Ready for final scans, validator, commit.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Drain composes `runNext` only, no new SQL or state transitions | Keeps the worker a thin composer over the reviewed lifecycle | repo: `local_outbox_worker.dart`, `local_oplog_repository.dart` |
| 2026-09-25 | `maxPasses` required bound, default 10, `< 1` fails closed | Rules out unbounded drain; matches existing fail-closed budget style | Stage33/Stage36 precedent |
| 2026-09-25 | Handler throw propagates; DB rows stay settled, in-memory prefix discarded | Same contract as `runNext`; explicit `releaseClaim` owns the stranded claim; reviewer wording gap closed | review `deleg_05e06418`, repo: `local_outbox_worker.dart` |
| 2026-09-25 | Tie-break by row id (= `operationId`) pinned with same-`createdAt` test | Reviewer noted order claim delegated to `claimNext` without a direct tie test | review `deleg_05e06418`, test: `local_oplog_bounded_drain_test.dart` |

## Blockers
- None

## Done
- Focused RED captured (`drain` undefined) before implementation.
- `drain` GREEN: ordered settle, tie-break, early stop, maxPasses bound, empty no-call, `maxPasses: 0` throws `ArgumentError`.
- Wider suites GREEN; analyzers clean; format 0 changed.
- Reviewer findings addressed and recorded in `05-verification.md`.

## Remaining
- None for this record; slices committed in `7a1cb2f` + `5722e25`, both ancestors of HEAD. Transport/RLS/Storage/background/CI remain later stages.
