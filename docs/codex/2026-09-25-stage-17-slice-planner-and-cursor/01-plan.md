# Plan

## Approach
Add two narrow, deterministic domain helpers: one that partitions already-normalized `SourceBlock` records into ordered `LearningSlice` JSON records, and one that advances an immutable `SliceCursor` JSON record through those slices. Keep both helpers pure and test them against real models, not mocks.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Read existing slice, cursor, block, node, and page models and planner contract. |
| 2 | done | Write failing focused test for planner coverage, boundary, and lookahead. |
| 3 | done | Write failing focused test for cursor selection, advance, resume, and mismatch rejection. |
| 4 | done | Add minimal `slice_planner.dart` helper and export it. |
| 5 | done | Add minimal `slice_cursor_advance.dart` helper and export it. |
| 6 | done | Run focused tests, full domain/data suites, analysis, and docs validation. |
| 7 | done | Update task docs, set status done, commit. |

## Interfaces and Artifacts
- New pure helpers under `packages/trace_domain/lib/src/models/`.
- New exports in `packages/trace_domain/lib/trace_domain.dart`.
- New focused tests under `packages/trace_domain/test/`.
- Task docs under `docs/codex/2026-09-25-stage-17-slice-planner-and-cursor/`.

## Risks
- Overplanning could smuggle model behavior into deterministic code; mitigation is fixed boundary rules and bounded tests.
- Cross-page associations could be guessed; mitigation is to keep figure/page dependency evidence explicit and fail closed on missing evidence.

## Acceptance Checks
- `dart test test/slice_planner_test.dart test/slice_cursor_advance_test.dart -r expanded` passes.
- `dart test -r compact` passes in `trace_domain`.
- `dart test -r compact` passes in `trace_data`.
- `dart analyze lib test` passes in `trace_domain`.
- Work-docs structure validation passes.
