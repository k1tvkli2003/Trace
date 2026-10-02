# Handoff

## Outcome
slice محلی on-demand کامل و سبز است: handler، wire، receipt durable، adapter Vercel و client بدون secret. اجرای cloud عمدا انجام نشد.

## Changed Artifacts
- `services/ai_gateway/on_demand_run.py` + `test_on_demand_run.py`
- `services/ai_gateway/cloud_gateway.py` + `test_cloud_gateway.py`
- `services/ai_gateway/supabase_backend.py` + `test_supabase_backend.py`
- `api/trace-ai-run.py` + `vercel.json`
- `supabase/migrations/20261002_trace_ai_receipts.sql`
- `apps/trace_flutter/lib/services/trace_gateway_client.dart` + `apps/trace_flutter/test/trace_gateway_client_test.dart`
- docs همین تسک: `01-plan.md`، `02-state.md`، `04-progress.md`، `05-verification.md`، `06-handoff.md`

## How To Continue
- review نهایی diff و سپس commit همین slice محلی.
- migration/deploy/JWT واقعی فقط با credential و دستور صریح جداگانه.
- smoke ابری را بعد از deploy با endpoint واقعی و payload bounded اجرا کن.

## Done
- قرارداد frozen، handler، wire، receipt durable، adapter، client، migration به‌صورت فایل، و verification محلی.

## Remaining
- اجرای migration/RLS روی Supabase واقعی.
- deploy/preview و smoke ابری.
- cleanup تایپ `authorization: object` جدا از behavior.

## Verification
- `125 tests OK`، `flutter test ... All tests passed`، `flutter analyze No issues found`، `py_compile OK`، `git diff --check` clean؛ cloud اجرا نشده و ریسک‌ها در `05-verification.md` ثبت است.
