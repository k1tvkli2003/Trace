# Trace on-demand gateway

- Task ID: `2026-10-01-trace-on-demand-gateway`
- Status: `active`
- Created: 2026-10-01
- Language: fa

## Request
ساخت ساده‌ترین مسیر کامل برای AI gateway ابری Trace: هر بار کاربر نیاز داشت، درخواست authenticated به یک serverless endpoint فرستاده شود؛ کلید مدل فقط سمت سرور بماند؛ نتیجه و وضعیت اجرا در Supabase receipt شود؛ بدون VPS، sub، proxy pool، xray، local-port dependency یا fallback پنهان.

## Success Criteria
- endpoint on-demand در Vercel/Node با route ثابت، auth، validation، budget، idempotency و receipt contract ساخته شود.
- فقط route/model مجاز شخصی کاربر استفاده شود؛ endpoint ابری به `127.0.0.1` این PC وابسته نباشد.
- secretهای upstream و Supabase service role هرگز در Flutter، log، receipt یا response خروجی نشوند.
- migration حداقلی Supabase برای receipt با RLS مالکیت‌محور آماده باشد؛ deploy واقعی فقط با credential و دستور صریح جداگانه.
- تست RED→GREEN برای موفقیت، تکرار idempotent، auth/ownership، invalid input، duplicate conflict و upstream failure وجود داشته باشد.
- Flutter فقط از یک client boundary بدون secret استفاده کند؛ در صورت نبود client موجود، قرارداد و adapter حداقلی تست‌شده اضافه شود.

## Context
- repo: `C:/Users/K1/Desktop/Projects/Trace`، branch `master`، HEAD `ae53c4c`.
- gateway فعلی در `services/ai_gateway/` Python و آفلاین است؛ `budget.py`, `page_vision.py`, `nine_router_transport.py` قراردادهای fail-closed و Vision سقف `16384`/`300` دارند.
- `supabase/` فقط README دارد و `api/` یا `vercel.json` هنوز وجود ندارد.
- Supabase Management API با Windows user token تازه برای project `EveryThing` / ref `ayfhpbzuuuyraeveatrr`، status `ACTIVE_HEALTHY`، `HTTP 200` تأیید شده؛ این DB/RLS/Edge execution proof نیست.
- `StudyHub-Web` reference-only و immutable است.

## In Scope
- frozen API/data/auth/error/idempotency/observability contract.
- tests first برای boundary و pure handler/service.
- minimal Vercel-compatible endpoint and server service.
- Supabase migration and local/test adapter.
- minimal Flutter-facing gateway client boundary without credential handling.
- focused suite, static checks, local smoke proof, durable docs.

## Out of Scope
- deploy/migration اجرا روی cloud بدون دستور صریح.
- ساخت یا نگهداری sub، proxy rotation، xray، VPS، Edge egress یا round-robin.
- تغییر model/provider route بدون دستور جدید کاربر.
- OAuth/auth UI کامل، multi-user/social/public sharing، long-running ingestion worker.
- OCR یا PDF text-layer transcription.
- تغییر `StudyHub-Web`.

## Assumptions
- Vercel access token اگر برای metadata/deploy لازم نشود، استفاده نمی‌شود.
- upstream model credential یک env سروریِ مستقل است؛ نام env و endpoint از contract پنهان/قابل‌تنظیم server-only هستند، نه Flutter.
- receipt metadata hash/id/status/usage-safe fields نگه می‌دارد، نه prompt، image، token یا raw provider response.
