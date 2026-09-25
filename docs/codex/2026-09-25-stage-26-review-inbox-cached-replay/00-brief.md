# Stage 26 review inbox cached replay

- Task ID: `2026-09-25-stage-26-review-inbox-cached-replay`
- Status: `ready-for-review`
- Created: 2026-09-25T09:34:31
- Language: fa

## Request
ادامهٔ Trace: گام عملی بعد از اتصال اتمیک «خواندم» به مرور، نمایش مرورهای موعددار و بازپخش درس تأییدشده از cache محلی بدون AI.

## Success Criteria
- Inbox از `LocalReviewRepository.listDueItems` در زمان UTC خوانده شود؛ مرور آینده یا suspended نمایش داده نشود.
- هدف `lesson_box` فقط وقتی باز شود که artifact با همان ID/hash و شواهد ارجاع معتبر در DB موجود باشد؛ محتوای نمونهٔ preview هرگز به‌جای آن استفاده نشود.
- ارجاع‌های درس locator و پیوند بازکردن شاهد منبع داشته باشند؛ missing/corrupt evidence حالت خطای صریح دهد.
- entry point واقعی از shell روی صفحه‌های باریک و عریض قابل دسترسی باشد؛ مسیر cache-only هیچ مدل یا شبکه‌ای را صدا نزند.
- تست RED/GREEN و suite/analyze/build محدود اجرا و مرزهای اثبات ثبت شود.

## Context
HEAD اولیه `9c33f6c`، worktree پیش از scaffold پاک؛ `ReviewItem` در اولین `STUDIED` با هدف artifact ساخته می‌شود؛ `readArtifact` شواهد و AST را بازاعتبارسنجی می‌کند. UI فعلی فقط `TeachingPreviewPage` نمونه دارد. `StudyHub-Web` reference محافظت‌شده است.

## In Scope
نمایش Inbox سراسری تک‌کاربره، load/replay محلی، شواهد citation و navigation از shell؛ آزمون SQLite و widget.

## Out of Scope
ثبت پاسخ مرور و event/outbox، snooze/reset، AI generation، sync/auth، ingest واقعی PDF و ادعای آزمون device.

## Assumptions
بدون رابطهٔ library مستقیم در ReviewItem، Inbox فعلاً سراسری است؛ برای کتاب‌های متعدد scope کتاب بدون mapping معتبر ادعا نمی‌شود. unsupported target باز نمی‌شود.
