# State

- Current status: `active`
- Last updated: 2026-10-01
- Owner: Codex

## Current State
سقف‌ها بالا رفت و commit شد (`889afe7`). پایلوت Harrison صفحه 1 با high و 16384 دوباره `http 200` داد. کاربر سه poll را جواب داد: pooler سروری Trace، اجرا روی Supabase Edge، sub از env سرور، و تایید نوشتن spec. فایل‌های spec در حال تکمیل است. Supabase با توکن فعلی `401` است و پیاده‌سازی‌اش منتظر توکن تازه است.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-10-01 | سقف‌ها به 16384 توکن و 300 ثانیه رسید؛ stream ceiling همان 262144 ماند | کف اثبات‌شده پایلوت همین بود؛ دو تست مستقل stream ceiling را جدا نگه داشت | raw-vision-16k.json + suite 101 OK |
| 2026-10-01 | هیچ pool تازه در 9Router ساخته نشد؛ rotator دست نخورد | pool زنده 36/36 بود و لاگ `preserving running pool` گارد را نشان داد | admin /api/proxy-pools + refresh.log |
| 2026-10-01 | A pooler سروری Trace | کاربر می‌خواهد سرور داخل اپ باشد نه وابسته به این سیستم | poll |
| 2026-10-01 | محل اجرا Supabase Edge؛ sub از env سرور | انتخاب کاربر در poll دوم | poll |
| 2026-10-01 | تایید نوشتن spec با control روی Supabase و egress جدا | انتخاب کاربر در poll سوم؛ Edge نمی‌تواند xray نگه دارد پس egress جدا صادقانه ثبت می‌شود | poll + ماهیت Edge |
| 2026-10-01 | Supabase با توکن فعلی 401 قرمز؛ بدون توکن تازه پیاده‌سازی نیست | probe مدیریتی `Unauthorized` داد | curl api.supabase.com/v1/projects |

## Blockers
- Supabase: توکن فعلی `401 Unauthorized`؛ مالک: کاربر؛ شرط رفع: توکن تازه + مشخصات پروژه (URL/ref). تا آن زمان هیچ کدنویسی Edge انجام نمی‌شود.

## Done
- RED واقعی دیده شد (`ValueError: Run policy exceeds hard safety ceiling` برای 16384/300).
- GREEN: شش فایل (سه سورس + سه تست) به سقف تازه رسید.
- suite `Ran 101 tests OK`.
- commit تکی `889afe7`.
- rerun پایلوت Harrison صفحه 1: `http 200, bytes 121392, deltas 400, elapsed 43.4`.
- سه poll کاربر با پاسخ A / Supabase Edge / sub از env / تایید spec.

## Remaining
- تکمیل فایل‌های spec (02 تا 06) + validator + commit تکی رکورد.
- پیاده‌سازی pooler فقط بعد از توکن تازه Supabase (کار آینده، نه این تسک).
