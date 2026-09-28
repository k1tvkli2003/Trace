# Plan

## Approach
رفتار و invariantهاي موجود حفظ شد: routing در `go_routing.py` فقط selector آفلاين است؛ 9Router مالک transport و proxy rotation است. بعد يک PDF واقعي کوتاه رندوم انتخاب و صفحه فقط به raster تبديل شد. همان raster، بدون text layer و OCR، با route ثابت و دو effort live probe شد.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | catalog، admin pool و scheduler زنده بررسي شد |
| 2 | done | policy با RED/GREEN به model واحد و `high`/`xhigh` fail-closed محدود شد |
| 3 | done | PDF واقعي کوتاه انتخاب شد: 11 صفحه؛ صفحه 10؛ source hash و pixel hash ثبت شد |
| 4 | done | High با `max_output_tokens=1800`: `response.completed` و `PDFVISION:` |
| 5 | done | Xhigh با `max_output_tokens=4096`: `response.completed` و `PDFVISION:` |
| 6 | done | failure نخست با `max_output_tokens=1800` و `reason=max_output_tokens` ثبت و علت رفع شد |
| 7 | in_progress | همگام‌سازي docs/matrix، validator، suite و commit |

## Interfaces and Artifacts
- `services/ai_gateway/go_routing.py`, `services/ai_gateway/test_go_routing.py`
- `services/ai_gateway/README.md`, `docs/contracts/learning-ai-v1.md`
- `docs/qa/acceptance-matrix.md`, `docs/architecture/decision-log.md`
- `assets/real-pdf-page.png`, `assets/real-pdf-vision-proof.json`
- `logs/real-pdf-vision-high-1800.json`, `logs/real-pdf-vision-xhigh-4096.json`

## Risks
- يک catalog live در تکرار بعدي `oc` را نشان نداد، اما همان request به `oc` پاسخ کامل داد؛ اين drift بايد monitor شود و fallback همچنان ممنوع است.
- Xhigh با سقف 1800 ناقص شد؛ receipt نگه داشته شد و با سقف ايمن policy (`4096`) دوباره کامل شد.
- پاسخ فقط يک جمله بود؛ اين اثبات سلامت route و Vision است، نه accuracy کامل transcription.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` سبز.
- هر دو effort روي يک صفحه واقعي PDF پاسخ `response.completed` و متن قابل تشخيص بدهند.
- input فقط PNG raster باشد؛ `text_layer_read=false` و `ocr_used=false` ثبت شود.
- task validator و `git diff --check` سبز باشند.
