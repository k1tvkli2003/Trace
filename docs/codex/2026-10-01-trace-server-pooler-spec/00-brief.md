# Trace server pooler spec

- Task ID: `2026-10-01-trace-server-pooler-spec`
- Status: `ready-for-review`
- Created: 2026-10-01T08:53:07
- Language: fa

## Request
سرور pooler مستقل Trace ساخته شود که وابسته به این PC نباشد. همان منطق `refresh_cycle.py` (sub موجود v2rayn، همیشه لایو و آپدیت‌شونده، چرخش round-robin) داخل اکوسیستم Trace بیاید و مسیر AI همان `oc/muse-spark-1.3-contributor-free` با reasoning high بماند. پایلوت روی `Harrison Part 03 - Pharmacology.pdf` در حد 2 صفحه با همان منطق برنامه‌ریزی‌شده. کاربر گزینه A (pooler سروری Trace)، محل اجرا Supabase Edge، و منبع نود (sub از env سرور) را انتخاب کرد و تایید کرد spec نوشته شود.

## Success Criteria
- سقف‌های Vision به کف اثبات‌شده (16384 توکن، 300 ثانیه) رسیده و suite سبز است (commit `889afe7`).
- پایلوت Harrison صفحه 1 با raster کامل و high و 16384 دوباره `http 200` داده و receipt دارد.
- spec معماری pooler سروری Trace با control روی Supabase و egress جدا نوشته شده و trade-off صادقانه Edge ثبت شده است.
- بررسی اولیه با توکن قدیمی `401` بود؛ توکن تازه از Windows user env با Management API `200` تأیید شد. مقدار secret نمایش داده یا ذخیره نشد و هیچ منبع ابری تغییر نکرد.

## Context
- Repo: `C:/Users/K1/Desktop/Projects/Trace`، HEAD پس از `889afe7`.
- منطق مرجع: `C:/Users/K1/Desktop/9router-rotator/refresh_cycle.py` (736 خط): خواندن read-only sub فعال از `guiNDB.db`، پارس `vless/vmess/trojan/ss/hysteria2/socks/http`، بیلد xray چند-inbound از `21101`، تست کانفیگ قبل از restart، probe هر پورت، reconcile poolهای 9Router، تضمین `providerStrategies.opencode.rotateStrategy=round-robin`، fail-safe (pool کوچک‌تر جایگزین pool سالم نمی‌شود).
- وضعیت زنده 2026-10-01: pool `total 36 / active 36`، تسک `9Router-Pool-Refresh` سالم (`Last Result 0`)، لاگ `preserving running pool` یعنی گارد کوچک‌سازی کار می‌کند.
- Gateway: `services/ai_gateway/` آفلاین و fail-closed؛ `go_routing.py` فقط selector است؛ rotation مال 9Router است نه کد Trace.
- پایلوت: `C:/Users/K1/AppData/Local/Temp/harrison-pilot/raw-vision-16k.json` با `http 200, bytes 121392, deltas 400, elapsed 43.4`.

## In Scope
- بالا بردن سقف‌ها به کف اثبات‌شده در `budget.py`، `nine_router_transport.py`، `page_vision.py` + تست‌ها (انجام شد).
- rerun پایلوت Harrison صفحه 1 (انجام شد).
- نوشتن همین spec (control-plane روی Supabase Edge + egress جدا، sub از env سرور).
- رکورد docs/codex با validator و تک‌commit.

## Out of Scope
- پیاده‌سازی pooler، کدنویسی Edge Function، ساخت egress worker، تغییر Flutter، دست‌زدن به 9Router/rotator، استخراج متن با OCR/text-layer، هرگونه ذخیره secret در repo/log/DB.
- اجرای migration یا deploy روی Supabase؛ این مرحله فقط خواندن وضعیت پروژه و تأیید توکن است.

## Assumptions
- sub کاربر در env سمت سرور می‌ماند و هرگز وارد باندل Flutter یا repo نمی‌شود.
- Edge Functions کوتاه‌عمر و stateless است و نمی‌تواند xray چند-port را میزبانی کند؛ egress باید جدا باشد (تصمیم صادقانه همین spec).
- free-tier سقف IP دارد؛ rotation کمک است نه تضمین.
