# Stage 29 native adapters and background jobs

- Task ID: `2026-09-25-stage-29-native-adapters-and-background-jobs`
- Status: `ready-for-review`
- Created: 2026-09-25T11:24:17
- Language: fa

## Request
ادامهٔ Trace طبق پلن بخش ۲۹: هر capability پلتفرمی (notification، background lifecycle، file/window، Web PWA) پشت interface مشترک برود؛ jobهای import/vision با restart ادامه یابند؛ notification فقط برای due واقعی باشد.

## Success Criteria
- هر capability پلتفرم پشت interface مشترک با fallback صادقانه باشد؛ هیچ ادعای background delivery پس از بسته‌شدن مرورگر/اپ بدون شاهد runtime نباشد.
- ادامهٔ job پس از restart فقط از روی checkpoint hash-bound (`PdfRenderCheckpoint` JSON) تصمیم گرفته شود؛ checkpoint جعلی یا ناسازگار fail-closed رد شود.
- نامزد notification فقط از `listDueItems` فعال و due<=now بیاید؛ Inbox منبع حقیقت بماند؛ idempotent در برابر تکرار باشد.
- تست RED پیش از کد دیده شود؛ suite محدود داده/دامنه/اپ و analyze پاس شود.

## Context
HEAD `6b1b4ac`؛ `PdfRenderBatchWorker` با checkpoint/resume و cancel مرزی و hash-bound موجود است (`pdf_render_batch_worker.dart`) ولی persistence پس از restart و قرارداد capability پلتفرم ندارد. `LocalReviewRepository.listDueItems` منبع due است. Stage 4 (`dependency-decisions.md`) صریح است: `flutter_local_notifications` و `flutter_secure_storage` روی Windows این هاست به‌علت ATL (`atlbase.h`/`atlstr.h`) BLOCKED هستند؛ Web نمی‌تواند با مرورگر بسته notification زمان‌بندی کند؛ Android نیازمند desugaring/permission proof است. پس این slice هیچ پلاگین native تازه اضافه نمی‌کند.

## In Scope
- قرارداد خالص دامنه: `PlatformCapabilities` و سیاست خالص `DueNoticePolicy`.
- آداپتر نازک اپ: `TracePlatformNotifier` با پیاده‌سازی foreground-only و fallback صادقانه.
- کمک‌تابع خالص resume: صفحات باقی‌مانده از روی checkpoint بدون I/O.
- آزمون آفلاین unit/widget برای همین سه‌تایی.

## Out of Scope
- افزودن `flutter_local_notifications` / `flutter_secure_storage` یا هر dependency native تازه؛ دست‌کاری `android/` و `windows/` و `web/`؛ ادعای schedule سیستمی، permission واقعی، PWA install/update، secure storage، sync/auth واقعی.
- تغییر schema یا migration؛ جدول Drift تازه نیست.
- Vision واقعی، ingest واقعی، ارسال notification واقعی OS.

## Assumptions
- Notification واقعی OS در این slice صدا زده نمی‌شود؛ فقط decision و نمایش foreground.
- ادامه پس از restart یعنی تصمیم resume از checkpoint ذخیره‌شده، نه اجرای background حین kill.
