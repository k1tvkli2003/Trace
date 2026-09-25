# Stage 28 notes backlinks and export

- Task ID: `2026-09-25-stage-28-notes-backlinks-and-export`
- Status: `done`
- Created: 2026-09-25T11:01:39
- Language: fa

## Request
ادامهٔ Trace: یادداشت‌های متنی به block/page/lesson وصل بمانند و قابل export/import باشند؛ طبق پلن بخش ۲۷، متن note و drawing جدا و positioning فقط نمایشی است.

## Success Criteria
- هر note دست‌کم یک target معتبر (anchor زنده، sourceBlock، figure تأییدشده یا lessonBlock) داشته باشد و backlink آن قابل query باشد.
- لیست note برای anchor/block/figure/lesson با ترتیب قطعی `updatedAt` و سپس `id` برگردد و tombstoneها دیده نشوند.
- خروجی export شامل همان JSON معتبر note به‌علاوهٔ locator خوانا (block/page/document یا anchor/quote) باشد و re-import همان محتوا را idempotent بپذیرد.
- تست RED/GREEN و suite/analyze محدود اجرا و مرزهای اثبات ثبت شود.

## Context
HEAD `e52a638`؛ `putNote` و `readNote` و tombstone موجود است ولی query معکوس (backlink) و export قابل‌انتقال وجود ندارد. `StudyHub-Web` فقط reference است.

## In Scope
- متدهای فقط‌خواندنی `listNotesFor` در `LocalAnnotationRepository` برای anchor/block/figure/lesson.
- تابع خالص export در دامنه یا data که JSON معتبر note و locator خوانا تولید کند.
- آزمون SQLite برای ترتیب، tombstone، target نامعتبر و round-trip export/import.

## Out of Scope
- UI یادداشت و ویرایش هم‌زمان/conflict UI، drawing note، sync/auth، ingest واقعی و ادعای device.
- تغییر schema یا migration؛ جدول `StudyNotes` کافی است.

## Assumptions
- Export متن note را می‌برد؛ positioning/drawing حمل نمی‌شود.
- Conflict چنددستگاهی در sync حل می‌شود، نه در این slice.
