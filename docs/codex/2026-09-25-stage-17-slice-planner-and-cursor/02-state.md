# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Deterministic slice planner and cursor-advance helpers are implemented, exported, and green. Evidence: domain `All tests passed` with `DOMAIN_EXIT=0`, data `All tests passed` with `DATA_EXIT=0`, `dart analyze` clean, work-docs structure validation `OK`.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Keep Stage 17 deterministic and domain-only. | Model output, Vision, persistence, and UI belong to later stages. | repo/test/source |
| 2026-09-25 | Bound a slice by heading, figure, caption, cross-page continuation, page window, and block-count caps. | These are observable source-shape signals; semantic concept detection is out of scope. | repo/test/source |
| 2026-09-25 | Treat a page as Vision-covered only when all supplied blocks for that page are available. | Partial pages must surface missing evidence instead of looking complete. | repo/test/source |

## Blockers
- None

## Done
- Read existing `LearningSlice`, `SliceCursor`, `SourceBlock`, `SourcePage`, `KnowledgeNode`, and slice-planner contract.
- Created Stage 17 brief and plan.
- Added failing-then-green tests `slice_planner_test.dart` and `slice_cursor_advance_test.dart`.
- Implemented `slice_planner.dart` and `slice_cursor_advance.dart`, exported from `trace_domain.dart`.
- Ran focused/domain/data tests, `dart analyze`, and docs validation green.

## Remaining
- Domain-only helpers need wiring into ingestion and persisted cursor update in later stages.
- No live PDF/Vision, figure asset fidelity, crash-restart, or UI E2E proof yet.
