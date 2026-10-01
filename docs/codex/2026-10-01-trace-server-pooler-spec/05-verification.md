# Verification

## Summary
- Result: passed (code + pilot + probes; spec record pending final validator + commit)
- Last verified: 2026-10-01

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| RED ceiling | `RunLimits(1,100,16384,300)` قبل از تغییر | passed (رد شد با `ValueError: Run policy exceeds hard safety ceiling`) | budget.py line 29-31 |
| suite | `unittest discover -s services/ai_gateway` | passed | `Ran 101 tests OK` |
| GREEN accept | `RunLimits(1,100,16384,300)` بعد از تغییر | passed | `ACCEPT` |
| pilot rerun | `raw_vision_16k.py` صفحه 1 Harrison با high و 16384 | passed | `http 200, bytes 121392, deltas 400, elapsed 43.4` + `response.completed` |
| pool live read-only | `refresh_cycle.api GET /api/proxy-pools` | passed | `http 200, total 36, active 36` |
| rotator untouched | `refresh.log` tail | passed | `preserving running pool` + `Last Result 0` |
| Supabase probe | `curl api.supabase.com/v1/projects` با توکن env | failed (قرمز موردانتظار) | `http 401 Unauthorized` |
| diff check | `git diff --check` | passed | `CHECK-EXIT:0` |

## Not Run
- validator ساختار task docs و commit نهایی رکورد (در ادامه همین تسک).
- هیچ پیاده‌سازی Supabase/Edge (منتظر توکن تازه + مشخصات پروژه).

## Known Issues
- توکن Supabase فعلی معتبر نیست (`401`)؛ بدون توکن تازه هیچ کدنویسی Edge مجاز نیست.
- Edge نمی‌تواند xray نگه دارد؛ egress جدا لازم است (در 06-handoff).
