# Plan

## Approach
Keep existing v1 interval semantics for persisted items. Add `fixed-offset-v2` using existing `schedulerVersion`, `dueAt`, and `intervalDays` fields, without schema migration. First-study constructor creates A+1; subsequent gap sequence [2,4,8,15] places on-time due dates at A+[3,7,15,30]. Late reviews derive next due from actual review instant. A `hard` or `again` rating intentionally moves off original anchor; immutable initial receipt preserves initial due, not an extra anchor field. Repository checks projected next due before append. RED/GREEN one behavior at a time. Footer integration not claimed.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | completed | Inspect v1 item/event/DB and pin offset contract. |
| 2 | completed | Added targeted failing offset and first-study tests before implementation. |
| 3 | completed | Added `fixed-offset-v2` projection and first-study constructor; no migration. |
| 4 | completed | Added late/again/easy/post-30/duplicate/version-mismatch coverage. |
| 5 | completed | Package tests/analyze/format and docs validation passed; committed in ecb8e16. |

## Interfaces and Artifacts
- Modify: `packages/trace_domain/lib/src/models/review_item.dart`, `packages/trace_data/lib/src/local/local_review_repository.dart`, `packages/trace_data/lib/src/local/trace_database.dart` (only if new persistence needed).
- Tests: `packages/trace_data/test/local_review_repository_test.dart`, `packages/trace_domain/test/review_item_test.dart`, migration tests as needed.
- Docs: task folder and index.

## Risks
- Reinterpreting v1 review rows would move existing due dates; keep versioned policy.
- Source of anchor must survive restart; avoid synthesizing it from mutable due date.
- Generation/migration may require existing cached packages; fail honestly if unavailable.

## Acceptance Checks
- Focused RED fails for incorrect cumulative milestones; GREEN meets A+1/3/7/15/30 and late-review contract.
- Event append and replay remain atomic/idempotent; original v1 tests green.
- `flutter test --no-pub`, `flutter analyze --no-pub`, `dart format`, docs validation and `git diff --check` pass.
