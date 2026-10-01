# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-10-01T08:53:07 | active | Task docs created. | docs/codex/2026-10-01-trace-server-pooler-spec/ |
| 2026-10-01 | active | RED دیده شد: `RunLimits(1,100,16384,300)` با `ValueError: Run policy exceeds hard safety ceiling` رد شد. | budget.py line 29-31 |
| 2026-10-01 | active | GREEN: سقف‌ها در budget/transport/vision + تست‌ها به 16384/300 رسید؛ stream ceiling همان 262144 ماند. | git diff 6 files |
| 2026-10-01 | active | suite سبز `Ran 101 tests OK`؛ commit تکی `889afe7`. | unittest + git log |
| 2026-10-01 | active | rerun پایلوت Harrison صفحه 1: `http 200, bytes 121392, deltas 400, elapsed 43.4`. | raw-vision-16k.json |
| 2026-10-01 | active | pool زنده خوانده شد: `total 36 / active 36`؛ rotator دست نخورد. | /api/proxy-pools + refresh.log |
| 2026-10-01 | active | سه poll: A pooler سروری، Supabase Edge، sub از env سرور، تایید نوشتن spec. | clarify |
| 2026-10-01 | active | Supabase probe: `http 401 Unauthorized`؛ پیاده‌سازی منتظر توکن تازه. | curl api.supabase.com/v1/projects |
| 2026-10-01 | ready-for-review | env ویندوز به‌روز شد؛ registry جدا از process env خوانده شد و توکن تازه با Management API `200` معتبر شد؛ project=`ayfhpbzuuuyraeveatrr`, `EveryThing`, `eu-west-1`, `ACTIVE_HEALTHY`. مقدار secret ذخیره/نمایش داده نشد. | `logs/supabase-token-health.json` |

## Done So Far
- سقف‌های Vision به کف اثبات‌شده رسید + suite سبز + commit.
- پایلوت Harrison rerun شد با receipt زنده.
- جهت معماری با poll کاربر قفل شد.
- بررسی توکن تازه و وضعیت پروژه انجام شد؛ فقط read-only، بدون deploy یا migration.

## Next
- تسک بعد: ساخت control-plane Supabase Edge + egress worker مستقل؛ انتخاب هاست egress هنوز لازم است.
