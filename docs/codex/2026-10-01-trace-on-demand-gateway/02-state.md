# State

- Current status: `done`
- Last updated: 2026-10-02
- Owner: Codex

## Current State
slice محلی کامل است: handler خالص on-demand با idempotency مالک‌محور، wire validation یازده‌فیلدی، adapter نازک Vercel (`api/trace-ai-run.py` با `handler(BaseHTTPRequestHandler)`)، مرز durable receipt در `SupabaseReceiptStore` با migration append-only و RLS مالک‌محور، و client بدون secret در Flutter. cleanup تایپ `authorization` (`str | None`) در `557e6af` commit شد. اجرای cloud (migration/deploy/JWT واقعی) انجام نشده و جزو scope این turn نیست.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-10-01 | مسیر on-demand روی Vercel + Supabase receipt؛ بدون VPS، sub، proxy، xray | خواست صریح کاربر و task کوچک هر بار نیاز | user message |
| 2026-10-01 | route/model مجاز فقط شخصی کاربر؛ بدون fallback پنهان | محدودیت ثابت محصول | plan non-negotiables |
| 2026-10-01 | secret upstream و service role server-only؛ receipt بدون secret | مرز امنیتی Backend/Trace | backend skill |
| 2026-10-01 | TDD با RED→GREEN قبل از implementation | قرارداد skill test-driven | test-driven-development |
| 2026-10-01 | `VERCEL_ACCESS_TOKEN` اگر برای metadata/deploy لازم نشود، استفاده نمی‌شود | دستور کاربر | user message |

## Blockers
- نبود endpoint exact/live برای route شخصی: design secret/upstream را abstract نگه می‌دارد؛ deploy/live اثبات جدا است.
- migration/deploy/JWT واقعی روی cloud بدون دستور صریح ممنوع است؛ این turn فقط slice محلی را verify می‌کند.

## Done
- تسک docs ساخته شد.
- brief و plan مسیر on-demand نوشته شد.
- baseline gateway خوانده شد.
- قرارداد frozen برای endpoint، auth، budget، idempotency و receipt در `01-plan.md` ثبت شد.
- slice A: handler خالص on-demand با `6 tests OK`.
- slice B: wire validation با `7 tests OK`؛ durable receipt با `6 tests OK`؛ adapter نازک Vercel با `5 tests OK`؛ client Flutter با `4 tests OK`.
- suite کامل محلی با `125 tests OK`؛ smoke مستقیم Flutter با `All tests passed`؛ analyze بدون issue.
- migration `trace_ai_receipts` با PK مالک‌محور و RLS owner-only و index پشتیبان نوشته شد (اجرا نشده).
- adapter `api/trace-ai-run.py` به `handler(BaseHTTPRequestHandler)` اصلاح شد تا شکل entrypoint معتبر بماند.

## Remaining
- اجرای migration/RLS روی Supabase واقعی با دستور صریح جداگانه (follow-up جدا).
- deploy/preview و smoke روی cloud با env واقعی و JWT واقعی (follow-up جدا).
- رکورد نهایی docs همین close در commit همین turn.
