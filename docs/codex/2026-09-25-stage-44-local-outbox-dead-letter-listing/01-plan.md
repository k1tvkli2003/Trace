# Plan

## Approach
TDD tracer bullet: failing test first for the dead-letter complement of `listFailedWithinBudget`, then the minimal read-only implementation reusing the same row mapping, ordering, and budget validation.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Write `local_oplog_dead_letter_test.dart`; watch RED (method missing) |
| 2 | planned | Add `listFailedOverBudget({maxRetries = 5})`; watch focused GREEN |
| 3 | planned | Run full suites + analyzers; fill state/progress/verification/handoff; validate; scan; commit |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: new `listFailedOverBudget`.
- `packages/trace_data/test/local_oplog_dead_letter_test.dart`: focused tests.
- `docs/codex/2026-09-25-stage-44-local-outbox-dead-letter-listing/`: task record.

## Risks
- Duplicating budget semantics instead of mirroring `canRequeue` (`<=` within vs `>` over); mitigated by review.

## Acceptance Checks
- Focused test GREEN; data/domain/app/Gateway suites exit 0; format clean; validator OK; scans clean.
