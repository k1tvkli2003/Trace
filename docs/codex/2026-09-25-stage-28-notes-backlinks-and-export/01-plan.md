# Plan

## Approach
ابتدا query معکوس فقط‌خواندنی `listNotesFor{Anchor,SourceBlock,Figure,LessonBlock}` در `LocalAnnotationRepository` با ترتیب قطعی `updatedAt` و `id` و حذف tombstone؛ سپس export خالص note+locator و آزمون round-trip.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | ثبت brief/state/progress و مرز no-schema-change |
| 2 | done | RED: تست لیست معکوس و export پیش از پیاده‌سازی |
| 3 | done | GREEN: `listNotesFor*` فقط‌خواندنی با ترتیب قطعی و tombstone filter |
| 4 | done | GREEN: `exportNote` خالص با locator خوانا و round-trip import |
| 5 | done | suite داده/دامنه و analyze و format و docs validation؛ committed in `6b1b4ac` |

## Interfaces and Artifacts
- `packages/trace_data/lib/src/local/local_annotation_repository.dart`
- `packages/trace_domain/lib/src/models/study_note_export.dart` (یا تابع export در data)
- `packages/trace_data/test/notes_backlinks_test.dart`
- `docs/codex/2026-09-25-stage-28-notes-backlinks-and-export/`

## Risks
- Query معکوس بدون index کند شود؛ حجم MVP تک‌کاربره و فیلتر tombstone کافی است.
- Locator خوانا با identity قاطی شود؛ locator فقط نمایشی است و شناسه همان IDهاست.

## Acceptance Checks
- لیست هر target فقط noteهای زندهٔ همان target را با ترتیب قطعی برمی‌گرداند.
- Export شامل JSON معتبر note و locator خوانا است و import مجدد همان rows را idempotent می‌پذیرد.
- suite داده و دامنه و analyze/format پاس.
