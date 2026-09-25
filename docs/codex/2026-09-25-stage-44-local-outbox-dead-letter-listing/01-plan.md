# Plan

## Approach
TDD tracer bullet: failing test first for the dead-letter complement of `listFailedWithinBudget`, then the minimal read-only implementation reusing the same row mapping, ordering, and budget validation.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | `local_oplog_dead_letter_test.dart` written; RED captured; committed `b50f36c`. |
| 2 | done | `listFailedOverBudget` added; focused 2/2 GREEN. |
| 3 | done | Full suites + independent review `deleg_45868dcf` recorded in `05-verification.md`; validator OK; record closes with this commit. |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_oplog_repository.dart`: new `listFailedOverBudget`.
- `packages/trace_data/test/local_oplog_dead_letter_test.dart`: focused tests.
- `docs/codex/2026-09-25-stage-44-local-outbox-dead-letter-listing/`: task record.

## Risks
- Duplicating budget semantics instead of mirroring `canRequeue` (`<=` within vs `>` over); mitigated by review.

## Acceptance Checks
- Focused test GREEN; data/domain/app/Gateway suites exit 0; format clean; validator OK; scans clean.
