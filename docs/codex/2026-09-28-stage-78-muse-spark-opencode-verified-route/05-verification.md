# Verification

## Summary
- Result: passed
- Last verified: 2026-09-28T03:20 Asia/Tehran

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| gateway suite کامل | `python -m unittest discover -s services/ai_gateway -p "test_*.py"` از ريشه ريپو | passed | `Ran 66 tests ... OK` |
| تست مسير واحد | `python -m unittest test_go_routing -v` از `services/ai_gateway` | passed | 6 تست `ok` (مسير واحد، رد `ocz`، High، image-not-pdf، fail-closed، رد override) |
| کار نکردن Stage77 | `git status --porcelain` براي مسيرهاي Stage77 | passed | فايلهاي Stage77 همان وضعيت قبلي‌اند؛ هيچ ويرايش جديدي روي آنها انجام نشد |
| کاتالوگ زنده | `GET http://127.0.0.1:20128/v1/models` | passed | `TOTAL 24`؛ هر دو `oc` و `ocz` با `vision:true` و `pdf:false` ديده شدند |
| pool/admin زنده | admin `/api/settings` + `/api/proxy-pools` با توکن CLI محلي | passed | `providerStrategies.opencode.rotateStrategy=round-robin`؛ `pool_count 33`، `active 33`، `strict_active 33` |
| پروب وظيفه زمانبندي pool | `schtasks /query /tn "9Router-Pool-Refresh"` | passed | وضعيت `Ready`؛ همان پروب هر چند دقيقه pool اشتراک را بهروز ميکند |
| Vision مصنوعي High | استریم SSE به `/v1/responses` با `oc` + `high` | passed | `http 200`، `response.completed`، متن دقيق `VISION:42` |
| Vision مصنوعي Xhigh | استریم SSE به `/v1/responses` با `oc` + `xhigh` | passed | `http 200`، `response.completed`، متن دقيق `VISION:42` (fallback زنده) |
| ساختار تسک | `validate_task_docs.py ... --structure-only` | passed | `OK` |

## Not Run
- استخراج واقعي PDF يا درس فارسي (خارج از scope؛ پروب فقط تصوير مصنوعي بود).
- smoke وب/Flutter و سوئيت Dart (تغييري در آن لايه‌ها داده نشد؛ آخرين وضعيت سبز در گزارش critic مانده است).
- پروب `ocz` جديد در همين دور (آخرين وضعيت: سقف مصرف آزاد؛ policy همان `oc` است).

## Known Issues
- کليد از `NINEROUTER_API_KEY` خوانده شد و مقدار آن چاپ/ذخيره نشد؛ پروبها بدون محتواي محلي/کتاب بودند.
- `ocz` قبلا سقف مصرف آزاد داده بود؛ به همين دليل allowlist فقط `oc` است و fallback ساکت ندارد.
- Vision فقط روي تصوير مصنوعي ثابت شد؛ دقت صفحه واقعي PDF فارسي اثبات نشده است.
