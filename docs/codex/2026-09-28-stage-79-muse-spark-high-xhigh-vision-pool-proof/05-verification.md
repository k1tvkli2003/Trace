# Verification

## Summary
- Result: passed
- Last verified: 2026-09-28T11:35 Asia/Tehran

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| gateway suite کامل | `python -m unittest discover -s services/ai_gateway -p "test_*.py"` از ريشه ريپو | passed | `Ran 68 tests ... OK` |
| کاتالوگ زنده | `GET http://127.0.0.1:20128/v1/models` | passed with drift note | Stage79 ابتدا `oc` را ديد؛ يک snapshot بعدي `oc` نداشت، اما همان request کامل شد |
| pool/admin زنده | admin `/api/settings` + `/api/proxy-pools` با توکن CLI محلي | passed | `providerStrategies.opencode.rotateStrategy=round-robin`؛ pool 37/37 active |
| پروب وظيفه زمانبندي pool | `schtasks /query /tn "9Router-Pool-Refresh"` | passed | وضعيت `Ready`؛ همان پروب هر چند دقيقه pool اشتراک را بهروز ميکند |
| Vision مصنوعي High/Xhigh | استریم SSE به `/v1/responses` با `oc` | passed | `http 200`، `response.completed`، متن دقيق `VISION:42` |
| Vision صفحه واقعي High | همان raster واقعي، `max_output_tokens=1800` | passed | `http 200`، `response.completed`، `elapsed_s=21.06`، متن `PDFVISION:Dark page lists items 11-20 with Persian explanations.` |
| Vision صفحه واقعي Xhigh | همان raster واقعي، `max_output_tokens=4096` | passed | `http 200`، `response.completed`، `elapsed_s=26.62`، متن `PDFVISION: Dark page shows numbered Persian entries 11-20 with answer badges.` |
| failure نخست ثبت و علت مشخص شد | `max_output_tokens=500` | passed as explained failure | هر دو effort `response.incomplete`؛ تکرار با `1800` علت را به `reason=max_output_tokens` محدود کرد |
| بدون text layer و بدون OCR | script فقط `get_pixmap` داشت | passed | `text_layer_read=false`، `ocr_used=false`، pixel hash ثابت در receiptها |
| ساختار تسک | `validate_task_docs.py ...` | passed | `OK`؛ هشدار فقط براي asset raster واقعي بود و Preview Policy اضافه شد |

## Not Run
- smoke وب/Flutter و سوئيت Dart (تغييري در آن لايه‌ها داده نشد).
- cost accounting سراسري، اتصال محصول، استخراج کامل PDF/درس فارسي.
- پروب `ocz` جديد در همين دور (policy همان `oc` است).

## Known Issues
- Xhigh براي همين صفحه به `4096` نياز داشت؛ سقف 1800 آن را ناقص کرد. اين نشان ميدهد سقف بايد per-effort از policy بيايد، نه ثابت.
- کاتالوگ live در يک تکرار `oc` را نشان نداد. اين drift است، نه مجوز fallback.
- اثبات فقط تشخيص يک‌جمله‌اي است، نه accuracy کامل transcription، شکل، فرمول يا review-source.
