# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-25T09:34:31 | active | Task docs created. | docs/codex/2026-09-25-stage-26-review-inbox-cached-replay/ |
| 2026-09-25 | active | Scope contract recorded; existing `listDueItems`/`readArtifact` seams confirmed without edits. | `local_review_repository.dart`, `local_lesson_repository.dart`, `main.dart`, `chat_workspace.dart` |
| 2026-09-25 | active | RED/GREEN inbox repository: due filtering, cached artifact replay and tampered-source fail-closed test. | `local_review_inbox_repository_test.dart`, `local_review_inbox_repository.dart` |
| 2026-09-25 | active | ViewModel fraction-safe clock, cache-only page, citation dialog, shell entry and fractional/widget RED coverage. | `review_inbox_view_model.dart`, `review_inbox_page.dart`, `chat_workspace.dart`, `main.dart` |
| 2026-09-25 | active | Full suites, analyzes, web build passed; handoff ready pending docs validation/commit. | Data 101, domain 106, app 39, gateway 50; `build\web` |

## Done So Far
- قرارداد Stage 26، مرزهای data/repository و ممنوعیت استفاده از preview sample ثبت شد.
- مخزن inbox فقط due/active را بازمی‌گرداند و `lesson_box` را با artifact هم‌ID/هم‌hash و شواهد citation بازپخش می‌کند.
- ViewModel، صفحهٔ آفلاین، entry point shell، dialog شاهد، navigation و آزمون‌های SQLite/widget آماده است.

## Next
- Run docs validation and commit, unless a new blocker appears.
