# Plan

## Approach
اول route زنده catalog/admin + Vision مصنوعي `oc` + High/Xhigh و `ocz` را با شواهد جدا بررسي کن؛ بعد policy آفلاين را فقط به مسير تأييدشده محدود کن و با TDD قفل نگه دار.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | catalog زنده `/v1/models` + admin pool/strategy خوانده شد |
| 2 | done | پروب متن/استریم نشان داد Responses SSE مسير درست است، نه Chat |
| 3 | done | Vision مصنوعي `oc` + High دو بار `VISION:42`؛ `oc` + Xhigh يک بار `VISION:42`؛ `ocz` سقف مصرف |
| 4 | done | RED: تست مسير واحد تأييدشده + رد `ocz`/MiMo/override نوشته شد |
| 5 | done | GREEN: `go_routing.py` فقط `oc` + High + endpoint `/v1/responses` شد (Xhigh فقط fallback زنده، نه پيشفرض) |
| 6 | active | مستندات قرارداد/README/acceptance و ثبت شواهد کامل شود |

## Interfaces and Artifacts
- `services/ai_gateway/go_routing.py`, `services/ai_gateway/test_go_routing.py`
- `services/ai_gateway/README.md`, `docs/contracts/learning-ai-v1.md`
- `docs/qa/acceptance-matrix.md`, `docs/architecture/decision-log.md`
- `docs/codex/2026-09-28-stage-78-muse-spark-opencode-verified-route/`

## Risks
- ادعاي High/Xhigh براي هر دو provider بدون پروب جداگانه — با محدودسازي به `oc` + High مهار شد.
- پاسخ خالي Chat ممکن بود بهاشتباه Vision ناسالم تلقي شود — با استریم کامل Responses جدا شد.
- سقف موقت مصرف آزاد `ocz` — با تست رد ساکت کنترل شد، نه fallback.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` سبز (66 تست).
- همه capabilityها فقط `oc/muse-spark-1.3-contributor-free` با High برگردانند.
- docs قرارداد و matrix بهروزرساني و validator ساختار سبز باشد.
