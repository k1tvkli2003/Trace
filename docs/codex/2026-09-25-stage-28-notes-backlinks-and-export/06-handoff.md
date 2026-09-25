# Handoff

## Outcome
یادداشت‌ها حالا backlink فقط‌خواندنی دارند: `listNotesForAnchor` با ترتیب قطعی `updatedAt` و `id` و حذف tombstone، و `exportNote` با همان JSON معتبر note به‌علاوهٔ locator نمایشی (anchor/quote/page یا block/document). Import مجدد همان JSON idempotent است.

## Changed Artifacts
- `packages/trace_data/lib/src/local/local_annotation_repository.dart` — `listNotesForAnchor` و `exportNote`
- `packages/trace_data/test/notes_backlinks_test.dart` — لیست قطعی بدون tombstone و export/re-import
- `docs/codex/2026-09-25-stage-28-notes-backlinks-and-export/` — brief/plan/state/progress/verification/handoff
- `docs/codex/_index.md` — سطر Stage 28

## How To Continue
1. `flutter test --no-pub test/notes_backlinks_test.dart` در `packages/trace_data`
2. `validate_task_docs.py` روی پوشه Stage 28 و `git diff --check`
3. commit با پیام `feat: add note backlinks and display-only export`

## Done
- تست RED پیش از پیاده‌سازی دیده شد
- Query معکوس فقط‌خواندنی با ترتیب قطعی و tombstone filter
- Export خالص note+locator با round-trip idempotent
- Suite داده (۱۰۷)، دامنه (۱۱۲)، اپ (۳۹) و analyze پاس

## Remaining
- None for this record; slice committed in `6b1b4ac`.
- تعمیم به block/figure/lesson در slice بعدی در صورت نیاز محصول
- UI یادداشت، sync واقعی و آزمون device/browser

## Verification
- Result: partial؛ suiteهای آفلاین پاس، UI/device/browser/E2E و sync واقعی اجرا نشده.
