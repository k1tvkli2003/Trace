# Handoff

## Outcome
سقف‌های Vision به کف اثبات‌شده رسید و commit شد. پایلوت Harrison rerun شد. جهت pooler سروری با سه poll قفل شد و spec نوشته شد. Supabase قرمز ماند و پیاده‌سازی‌اش به توکن تازه موکول شد.

## سه راه صادقانه (فقط A تایید شد)

### A) pooler سروری Trace — تایید شد
- control-plane روی Supabase (Edge Function کوتاه‌عمر + cron): خواندن sub از env سرور، پارس نودها، probe، تصمیم reconcile، صدور لیست egress فعال.
- egress جدا (نه Edge): یک هاست همیشه‌روشن که xray چند-inbound را مثل `refresh_cycle.py` نگه می‌دارد و gateway Trace از آن با round-robin عبور می‌کند.
- چرا دو تکه؟ چون Edge stateless و کوتاه‌عمر است و نمی‌تواند 36 پورت xray را زنده نگه دارد. هر طرحی که بگوید «همه‌چیز داخل Edge می‌چرخد» دروغ است.
- sub فقط در env سرور؛ هرگز در باندل Flutter، repo، لاگ یا DB client-visible.

### B) بسته‌بندی 9Router در ops — رد شد
- یعنی همین rotator فعلی را به‌عنوان وابستگی ops نگه داریم. مشکل: وابسته به همین PC می‌ماند و خواسته کاربر (سرور داخل اکوسیستم Trace) را نمی‌دهد.

### C) pool داخل اپ Flutter — رد شد
- نگه‌داری xray/sub در کلاینت یعنی لو رفتن secret، مصرف باتری، و نقض «API key هیچ‌وقت وارد Flutter bundle نمی‌شود». مردود معماری.

## طرح فازبندی A (کار آینده، نه این تسک)
1. control-plane: Edge Function `pool-refresh` + cron هر 5 دقیقه؛ ورودی فقط sub از env؛ خروجی لیست egress فعال در جدول `pool_state` (بدون secret).
2. egress: یک سرویس جدا (VPS یا هاست کاربر) با همان چرخه fetch→parse→build→test→restart→probe→reconcile.
3. gateway Trace فقط از لیست `pool_state` می‌خواند و round-robin می‌کند؛ هیچ‌وقت مستقیم به sub دست نمی‌زند.
4. گارد fail-safe مثل امروز: pool کوچک‌تر جایگزین pool سالم نمی‌شود.
5. پیش‌نیاز: توکن تازه Supabase + مشخصات پروژه (URL/ref). بدون آن هیچ‌کدام شروع نمی‌شود.

## Changed Artifacts
- `services/ai_gateway/budget.py`, `nine_router_transport.py`, `page_vision.py` + سه تست (commit `889afe7`).
- `docs/codex/2026-10-01-trace-server-pooler-spec/` (این رکورد).
- پایلوت بیرون repo: `C:/Users/K1/AppData/Local/Temp/harrison-pilot/raw-vision-16k.json`.

## How To Continue
- validator ساختار + commit تکی رکورد (باقی‌مانده همین تسک).
- بعد: با توکن تازه Supabase، تسک جدا برای control-plane؛ egress جدا را هم باید هاستش مشخص شود.

## Done
- سقف‌ها + suite + commit + rerun پایلوت + سه poll + نوشتن spec.

## Remaining
- validator + commit نهایی همین رکورد.
- پیاده‌سازی pooler (تسک آینده، مشروط به توکن تازه).

## Verification
- suite `101 OK`، پایلوت `http 200`، pool `36/36`، Supabase `401` (قرمز موردانتظار)، `diff --check` تمیز.
