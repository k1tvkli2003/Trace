# State

- Current status: `ready-for-review`
- Last updated: 2026-10-01 (Supabase token refresh rechecked)
- Owner: Codex

## Current State
سقف‌ها بالا رفت و commit شد (`889afe7`). پایلوت Harrison صفحه 1 با high و 16384 دوباره `http 200` داد. کاربر سه poll را جواب داد: pooler سروری Trace، اجرا روی Supabase Edge، sub از env سرور، و تایید نوشتن spec. فایل‌های spec در commit `2815afe` ثبت شد؛ طرح هنوز پیاده‌سازی یا deploy نشده است. توکن تازه در Windows user env دیده شد و Management API با آن `200` برگشت؛ پروژه `EveryThing` با ref `ayfhpbzuuuyraeveatrr`، region `eu-west-1`، status `ACTIVE_HEALTHY`.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-10-01 | سقف‌ها به 16384 توکن و 300 ثانیه رسید؛ stream ceiling همان 262144 ماند | کف اثبات‌شده پایلوت همین بود؛ دو تست مستقل stream ceiling را جدا نگه داشت | raw-vision-16k.json + suite 101 OK |
| 2026-10-01 | هیچ pool تازه در 9Router ساخته نشد؛ rotator دست نخورد | pool زنده 36/36 بود و لاگ `preserving running pool` گارد را نشان داد | admin /api/proxy-pools + refresh.log |
| 2026-10-01 | A pooler سروری Trace | کاربر می‌خواهد سرور داخل اپ باشد نه وابسته به این سیستم | poll |
| 2026-10-01 | محل اجرا Supabase Edge؛ sub از env سرور | انتخاب کاربر در poll دوم | poll |
| 2026-10-01 | تایید نوشتن spec با control روی Supabase و egress جدا | انتخاب کاربر در poll سوم؛ Edge نمی‌تواند xray نگه دارد پس egress جدا صادقانه ثبت می‌شود | poll + ماهیت Edge |
| 2026-10-01 | توکن تازه Supabase سالم است | Windows user env مقدار تازه دارد؛ API مدیریت پروژه `200` برگشت | registry read + `GET https://api.supabase.com/v1/projects` |

## Blockers
- برای بررسی توکن بلاکری باقی نمانده است؛ Management API `200` و پروژه سالم تأیید شد.
- برای پیاده‌سازی آینده، میزبان egress مستقل هنوز انتخاب نشده است. Edge به تنهایی xray چند-inbound را نگه نمی‌دارد؛ URL پروژه و مجوزهای runtime باید در همان مرحله بررسی شوند.

## Done
- RED واقعی دیده شد (`ValueError: Run policy exceeds hard safety ceiling` برای 16384/300).
- GREEN: شش فایل (سه سورس + سه تست) به سقف تازه رسید.
- suite `Ran 101 tests OK`.
- commit تکی `889afe7`.
- rerun پایلوت Harrison صفحه 1: `http 200, bytes 121392, deltas 400, elapsed 43.4`.
- سه poll کاربر با پاسخ A / Supabase Edge / sub از env / تایید spec.
- توکن تازه در registry خوانده شد؛ Management API `200` و project `ACTIVE_HEALTHY`.

## Remaining
- پیاده‌سازی control-plane Edge و egress worker در تسک بعدی، با project ref تاییدشده و secretهای server-side.
- انتخاب/provision هاست egress مستقل؛ Supabase Edge به‌تنهایی کافی نیست.
