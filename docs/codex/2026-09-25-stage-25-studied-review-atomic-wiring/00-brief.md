# Stage 25 studied review atomic wiring

- Task ID: `2026-09-25-stage-25-studied-review-atomic-wiring`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Continue Trace implementation with next concrete learning-loop step. Wire first `STUDIED` action to deterministic local review creation before UI review inbox work.

## Success Criteria
- First studied action creates exactly one `fixed-offset-v2` item due at action UTC +1 day within same transaction as versioned learner state and sync operation.
- Identical action replays without duplicate. Non-study or subsequent studied action does not reset review.
- Missing/invalid artifact or review conflict rolls back state and operation.
- Real in-memory Drift tests, package tests, analyze, format and docs validation pass.

## Context
Stage 23 `applyStateAction` writes versioned state + pending operation. Stage 24 `firstStudyItem` creates v2 projection but is not called. Existing UI is explicitly offline preview and must not claim real lesson persistence.

## In Scope
Local repository action/review seam and regression tests; handoff docs.

## Out of Scope
Review Inbox UI, cached replay UI, manual snooze/reset, device sync, AI and production authentication.

## Assumptions
Target of whole-lesson review is the immutable lesson artifact ID with `lesson_box` target type. Stable review identity derives from original state ID. Only first `STUDIED` creates an item; later status changes do not reschedule it.
