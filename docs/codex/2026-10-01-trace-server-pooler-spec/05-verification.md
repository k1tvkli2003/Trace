# Verification

## Summary
- Result: passed (code + pilot + Supabase credential recheck + spec record)
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
| Supabase old process env | inherited process metadata + management probe | failed/stale | old process had `len=47`, `http 401` |
| Supabase refreshed Windows env | read HKCU `Environment` + metadata-only live management request | passed | `http 200`, 1 project: `ayfhpbzuuuyraeveatrr` / `EveryThing` / `eu-west-1` / `ACTIVE_HEALTHY`; receipt: `logs/supabase-token-health.json` |
| diff check | `git diff --check` | passed | `CHECK-EXIT:0` |

## Not Run
- Supabase URL REST probe and database migration/application: project URL still needs confirmation from project details; implementation belongs to next task.
- No Edge/egress implementation in this spec task.

## Known Issues
- Existing process inherited old env; this probe read fresh HKCU value directly. No Hermes configuration was changed. No secret was echoed or stored.
- Edge نمی‌تواند xray نگه دارد؛ egress جدا لازم است (در 06-handoff).
