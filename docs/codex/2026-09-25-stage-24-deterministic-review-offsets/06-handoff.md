# Handoff

## Outcome
Added versioned deterministic offline review schedule in Trace data repository. On-time first-study offsets are +1/+3/+7/+15/+30 days; existing v1 records keep original interval policy.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_review_repository.dart`: `fixed-offset-v2`, `firstStudyItem`, rating projection, version validation, bounded after-30 policy and UTC subsecond preservation.
- `packages/trace_data/test/local_review_repository_test.dart`: on-time/late/rating/duplicate/event identity/persistence tests.
- `docs/codex/2026-09-25-stage-24-deterministic-review-offsets/` and `_index.md`: plan, state, limits, verification.

## How To Continue
1. Wire Stage 23 `STUDIED` action to `ReviewItem` first creation in **same local transaction**, preserving action replay and ownership. Implement with a failing data integration test first.
2. Wire footer UI and chat tool to same mutation use case. Add Review Inbox with cached lesson replay; do not claim AI/live sync until tested.
3. Define manual snooze/reset events and high-volume due-query/index design before claiming Stage 24 entire acceptance, especially app behavior.

## Done
- Bounded v2 scheduler + Drift repository behavior verified; v1 backward compatibility remains.

## Remaining
- Local learner-state/review atomic integration, user-visible footer/review inbox, snooze/reset, due-query performance, device/browser tests, notifications and sync.

## Verification
- Data package: 93 tests pass, analyze clean. Domain: 106 tests pass, analyze clean. Gateway regression: 50 tests pass. Data format clean. No live UI/device flow or network proof.
