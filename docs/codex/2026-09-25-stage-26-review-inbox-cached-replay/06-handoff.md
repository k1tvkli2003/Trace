# Handoff

## Outcome
Review Inbox displays active due reviews from immutable local schedule and replays the verified cached `LessonArtifact` with source-name/locator evidence. Missing, non-due, unsupported, or hash-changed content is rejected; `TeachingPreviewPage` remains separate sample content.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_review_inbox_repository.dart`
- `packages/trace_data/lib/trace_data.dart`
- `packages/trace_data/test/local_review_inbox_repository_test.dart`
- `apps/trace_flutter/lib/app/review_inbox_view_model.dart`
- `apps/trace_flutter/lib/review_inbox_page.dart`
- `apps/trace_flutter/lib/chat_workspace.dart`
- `apps/trace_flutter/lib/main.dart`
- `apps/trace_flutter/test/review_inbox_view_model_test.dart`
- `apps/trace_flutter/test/app_smoke_test.dart`
- `docs/codex/2026-09-25-stage-26-review-inbox-cached-replay/` and `_index.md`

## How To Continue
Start the app, open a collection, choose `Open review inbox`; due items open the same cached artifact without AI. Add review ratings/events, footer status action, sync transport, and book scoping next. Do not route inbox content through the sample teaching preview.

## Done
- Due query, cached artifact replay, source evidence and tamper rejection wired and passing.
- ViewModel clock preserves UTC fraction behavior; shell entry and empty/error/back states tested.
- Data, domain, app, gateway, analyze, format and web build pass.

## Remaining
- Review event recording, snooze/reset, outgoing sync/review transport and device/browser runs.
- Book-scoped inbox only after valid ownership mapping is designed.
- None for docs; this slice committed in 63927f7.

## Verification
- Result partial: data 101/101, domain 106/106, app 39/39, gateway 50/50; both Flutter analyzes and web build pass.
- Review answers/events, sync, packaging, integrated device/browser proof remain unrun.
