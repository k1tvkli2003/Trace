# State

- Current status: `ready-for-review`
- Last updated: 2026-09-28T04:35 Asia/Tehran
- Owner: Codex

## Current State
Policy آفلاين به `oc/muse-spark-1.3-contributor-free` با `high` پيشفرض و `xhigh` صريح محدود شد. suite کامل سبز است و pool اشتراک OpenCode با چرخش round-robin زنده تأييد شد. Vision مصنوعي هر دو effort کامل شد. ثبت نهايي اين مرحله با commit جدا انجام مي‌شود.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-28 | فقط `oc/muse-spark-1.3-contributor-free` با `high` پيشفرض و `xhigh` صريح براي همه capabilityها | هر دو effort روي تصوير مصنوعي `VISION:42` کامل دادند؛ effort ديگر بايد fail-closed باشد | live SSE probes + TDD |
| 2026-09-28 | endpoint آفلاين `/v1/responses` ماند | مسير تأييدشده همان استریم Responses است | live probes |
| 2026-09-28 | بدون round-robin در کد؛ چرخش پروکسي با خود 9Router | کد نبايد ادعاي چرخش سراسري کند | code review |
| 2026-09-28 | استفاده از pool اشتراک موجود بدون ساخت pool جديد | همان pool فعال هر چند دقيقه بهروز ميشود | admin `/api/proxy-pools` + `refresh_cycle.py` |

## Blockers
- None

## Done
- catalog زنده: `TOTAL 24`؛ هر دو `oc` و `ocz` با `vision:true` و `pdf:false` ديده شدند.
- admin زنده: 37 pool فعال/strict و `providerStrategies.opencode.rotateStrategy=round-robin`.
- پروب Vision مصنوعي `oc` + High: `response.completed` و `VISION:42`.
- پروب Vision مصنوعي `oc` + Xhigh: `response.completed` و `VISION:42`.
- RED سپس GREEN: تست `xhigh` صريح + رد effort نامعتبر.
- suite کامل: `Ran 68 tests ... OK`.

## Remaining
- ثبت نهايي diff/commit اين مرحله.
