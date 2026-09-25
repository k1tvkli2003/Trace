# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Review Inbox displays due reviews and replays the cached artifact offline with source evidence. Implementation and verification for this slice are complete except docs validation and commit.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Inbox global و read-only باشد؛ scope کتاب ادعا نشود. | `ReviewItem` owner/library ندارد؛ mapping کتاب فعلاً معتبر نیست. | `review_item.dart` + DB schema |
| 2026-09-25 | فقط `lesson_box` با artifact هم‌ID/هم‌hash باز شود. | Target و hash، پیوند replay معتبر artifact است. | Stage 25 state/seams |
| 2026-09-25 | `TeachingPreviewPage` evidence واقعی نیست. | نمونهٔ عمدی با citation ساختگی است. | `teaching_preview_page.dart` |
| 2026-09-25 | replay هیچ شبکه/AI نداشته باشد. | تعریف Stage: cached replay، همان خروجی محلی. | Plan §25 acceptance |

## Blockers
- None for this slice; only docs validation and commit remain.

## Done
- RED/GREEN repository, ViewModel, page, shell wiring and widget navigation/evidence tests.
- Data 101, domain 106, app 39, gateway 50 pass; both analyzes, format and web build pass.

## Remaining
- Docs validation and commit.
