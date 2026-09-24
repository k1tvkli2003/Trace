# Stage 17 — Slice Planner and Cursor

- Task ID: `2026-09-25-stage-17-slice-planner-and-cursor`
- Status: `done`
- Created: 2026-09-25
- Language: English

## Request
Implement the next concrete StudyForge/Trace step: deterministic learning-slice planning and resumable `SliceCursor` behavior. Use cached, hash-bound source blocks only. No live Vision, OCR, model call, database mutation, or StudyHub-Web change.

## Success Criteria
- Ordered `LearningSlice` records cover eligible source blocks without duplication.
- Slice boundaries carry explicit reasons and the next page that requires Vision when cache coverage ends.
- Cursor resume selects the next unconsumed slice/block deterministically and cannot skip or replay blocks.
- Cross-page blocks and figure dependencies remain in one slice when evidence is present; missing future evidence is surfaced, not guessed.
- Focused tests fail before implementation, then pass; full domain/data suites and analysis stay green.

## Context
Stage 16 completed whitespace-only `SourceBlock` normalization. Existing `LearningSlice` and `SliceCursor` models validate wire data but provide no planner or advancement behavior. `learning_contract.py` already reserves a provider-independent `slice_planner` envelope, but this stage remains deterministic domain logic.

## In Scope
- Domain planner input/output contracts and pure planner helper.
- Cursor selection/advance helper with immutable output JSON.
- Focused Dart tests and concise work documentation.

## Out of Scope
- Vision or OCR.
- AI provider calls or model selection.
- Drift migrations or repository wiring.
- Lesson AST generation, Flutter UI, sync, and StudyHub-Web.

## Assumptions
- Source blocks are already normalized and supplied in reading order.
- A source page is Vision-complete only when all supplied blocks for that page are available; no inferred completeness is allowed.
- `estimatedEffort` is a deterministic block-count proxy until richer source metrics exist.
