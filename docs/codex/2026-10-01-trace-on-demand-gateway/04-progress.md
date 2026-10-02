# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-10-01 | active | Task docs created. | docs/codex/2026-10-01-trace-on-demand-gateway/ |
| 2026-10-01 | active | Brief/plan/state مسیر on-demand به‌روز شد. | `00-brief.md`, `01-plan.md`, `02-state.md` |
| 2026-10-01 | active | baseline و مرز آفلاین/ابری خوانده شد. | `python -m unittest discover -s services/ai_gateway` → `101 tests OK`; `supabase/` فقط README؛ بدون `api/` یا `vercel.json` |
| 2026-10-01 | active | GREEN: tests on-demand `6 OK`؛ focused suite با venv سالم `107 OK`. | `test_on_demand_run.py`, `on_demand_run.py` |
| 2026-10-01 | active | RED دیده شد: `ModuleNotFoundError: No module named 'on_demand_run'`. | `test_on_demand_run.py` |
| 2026-10-01 | active | قرارداد frozen ثبت شد؛ t1 بسته شد و t2 شروع شد. | `01-plan.md`, `02-state.md` |
| 2026-10-02 | active | slice A بسته شد: handler خالص on-demand با idempotency مالک‌محور. | `services/ai_gateway/on_demand_run.py` + `test_on_demand_run.py` → `6 OK` |
| 2026-10-02 | active | slice B محلی کامل شد: wire یازده‌فیلدی، receipt durable، adapter نازک Vercel، client بدون secret. | `cloud_gateway.py` (`7 OK`) + `supabase_backend.py` (`6 OK`) + `api/trace-ai-run.py` (`5 OK`) + Flutter client (`4 OK`) |
| 2026-10-02 | active | suite کامل محلی و smoke مستقیم Flutter سبز ماند. | `125 tests OK` + `flutter test ... → All tests passed` + `flutter analyze → No issues found` |
| 2026-10-02 | active | entrypoint adapter به شکل معتبر `handler(BaseHTTPRequestHandler)` اصلاح شد. | `api/trace-ai-run.py` + `py_compile OK` + `125 tests OK` |

## Done So Far
- اسکلت docs و brief/plan/state اولیه.
- قرارداد frozen برای boundary و receipt.
- slice A و slice B محلی با تست‌های focused سبز.
- migration append-only و RLS مالک‌محور به‌صورت فایل آماده شد (اجرا نشده).

## Next
- اجرای migration/RLS و smoke ابری فقط با دستور صریح جداگانه.
- commit slice محلی پس از review نهایی diff.
