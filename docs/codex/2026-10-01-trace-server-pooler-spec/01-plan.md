# Plan

## Approach
اول سقف‌های کد را به کف اثبات‌شده برسان (بعد از دیدن RED واقعی)، بعد پایلوت Harrison را rerun کن، بعد spec معماری را با سه راه صادقانه بنویس و تایید poll بگیر. هیچ pool تازه‌ای در 9Router ساخته نمی‌شود و rotator دست نمی‌خورد. Supabase فقط probe read-only تا توکن تازه.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: `RunLimits(1,100,16384,300)` با `ValueError: Run policy exceeds hard safety ceiling` رد شد |
| 2 | done | GREEN: سقف‌ها در budget/transport/vision + تست‌ها به 16384/300 رسید؛ stream ceiling همان 262144 ماند چون دو تست مستقل آن را می‌خواست |
| 3 | done | suite `Ran 101 tests OK`؛ commit `889afe7` تکی |
| 4 | done | rerun پایلوت Harrison صفحه 1: `http 200, bytes 121392, deltas 400, elapsed 43.4` |
| 5 | done | سه poll کاربر: A pooler سروری، Supabase Edge، sub از env سرور، بعد تایید نوشتن spec |
| 6 | done | فایل‌های spec در commit `2815afe` ثبت شد؛ بررسی ساختار آن در همان نوبت `OK` بود |
| 7 | done | توکن تازه از HKCU خوانده شد؛ `GET /v1/projects` با `200` برگشت و پروژه `EveryThing` با ref `ayfhpbzuuuyraeveatrr` و وضعیت `ACTIVE_HEALTHY` تأیید شد |

## Interfaces and Artifacts
- `services/ai_gateway/budget.py` — سقف `max_output_tokens 16_384`، `max_elapsed_seconds 300`
- `services/ai_gateway/nine_router_transport.py` — همان سقف‌ها در validation + `elapsed <= 300`؛ stream ceiling بدون تغییر `262_144`
- `services/ai_gateway/page_vision.py` — `_POLICY_LIMITS (1, 4_194_304, 16_384)` + preflight `<= 16_384` و `<= 300`
- تست‌ها: `test_budget.py` (مرز `16_385/301`)، `test_nine_router_transport.py` (مرز `20000/400`)، `test_page_vision.py` (مرز `20000/400`)
- پایلوت: `C:/Users/K1/AppData/Local/Temp/harrison-pilot/raw-vision-16k.json` (بیرون repo، مثل بقیه receiptها)
- این spec: `docs/codex/2026-10-01-trace-server-pooler-spec/`

## Risks
- Edge نمی‌تواند xray نگه دارد؛ اگر egress جدا ساخته نشود pooler فقط control-plane بدون چرخش واقعی می‌ماند — spec همین را صریح می‌گوید، نه وعده چرخش.
- sub در env سرور امن می‌ماند؛ هر طرحی که sub را وارد کلاینت یا repo کند مردود است.
- free-tier ممکن است با وجود rotation هم 429 بدهد؛ gateway باید fail-closed بماند.

## Acceptance Checks
- `unittest discover` سبز `101 OK`
- `git diff --check` تمیز
- receipt پایلوت `http 200` با `terminal response.completed`
- validator `check_task_docs_structure.py --structure-only` سبز
- commit کد `889afe7` و commit spec `2815afe` جدا ثبت شده‌اند؛ بررسی توکن تازه در یک commit مستندات جدا ثبت می‌شود.
