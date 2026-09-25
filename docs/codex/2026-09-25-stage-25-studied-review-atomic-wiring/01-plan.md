# Plan

## Approach
Extend Stage 23 local transaction using Stage 24 scheduler factory. Preserve backward-compatible action request/receipt. No generated lesson or model call.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Inspect repository and contract; scope local atom only. |
| 2 | done | First studied test failed on absent ReviewItem, then passed. |
| 3 | done | Stable review identity and source-verified artifact binding added within action transaction. |
| 4 | done | Replay, later actions, non-study and conflict/injected insert rollback passed. |
| 5 | active | Data/domain/gateway suites, analyze and format passed; docs validation and commit follow. |

## Interfaces and Artifacts
- `LocalLessonRepository.applyStateAction` remains public entry point.
- `LocalReviewRepository.firstStudyItem` and `putReviewItem` own scheduler and persistence.
- `packages/trace_data/test/local_lesson_state_action_test.dart` verifies integrated effects.

## Risks
- Duplicate review on repeated studied action: stable ID + first transition gate.
- Inconsistent state/outbox/review: shared Drift transaction and negative rollback test.
- Forged or stale artifact: read source-verified artifact before linking target.

## Acceptance Checks
- One first-study due item exactly +1 day, `fixed-offset-v2`, correct artifact hash.
- No duplicate on replay or later action; no review for non-study.
- Failure writes zero new state, outbox or review rows.
