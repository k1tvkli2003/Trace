# Handoff

## Outcome
First local `STUDIED` action creates deterministic `fixed-offset-v2` ReviewItem due in one day and targets source-verified lesson artifact. One transaction covers versioned state, pending sync operation and item. UI path remains absent.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_lesson_repository.dart`: first-study review seam.
- `packages/trace_data/test/local_lesson_state_action_test.dart`: creation, replay, non-study, later-study, conflict and injected insert failure coverage.
- `docs/codex/2026-09-25-stage-25-studied-review-atomic-wiring/` and `_index.md`.

## How To Continue
Build Review Inbox on cached `LessonArtifact` using `LocalReviewRepository.listDueItems`. Do not wire sample `TeachingPreviewPage` as real content. Explicit local status action UI and chat tool should share `applyStateAction`; create a real artifact load path before that. Define review-event-to-outbox contract before claiming cross-device consistency.

## Done
- First studied action creates one due item with stable ID `review:<original state ID>`, artifact hash and `lesson_box` target.
- Action replay and later status changes do not reinitialize schedule; conflicting pre-existing review aborts.
- Injected review insert failure rolls back state and outbox.

## Remaining
- User-visible footer and inbox, cached replay, manual snooze/reset, sync review/event transport and device/browser tests.

## Verification
- Data 99/99, domain 106/106, gateway 50/50. Data analyze and format clean. App/device/browser tests not run for this data-only slice.
