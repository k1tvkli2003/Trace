# Plan

## Approach
اول catalog/admin/pool زنده و Vision مصنوعي `oc` + High/Xhigh را با شواهد جدا بررسي کن؛ بعد policy آفلاين را با RED/GREEN به هر دو effort مجاز محدود کن و با TDD قفل نگه دار.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | catalog زنده `/v1/models` + admin pool/strategy خوانده شد |
| 2 | done | Vision مصنوعي `oc` + High و `oc` + Xhigh هر دو `VISION:42` دادند |
| 3 | done | RED: تست `xhigh` صريح + رد effort نامعتبر نوشته شد |
| 4 | done | GREEN: `go_routing.py` فقط `high`/`xhigh` با پيشفرض `high` شد |
| 5 | done | مستندات قرارداد/README/matrix و ثبت شواهد کامل شد |

## Interfaces and Artifacts
- `services/ai_gateway/go_routing.py`, `services/ai_gateway/test_go_routing.py`
- `services/ai_gateway/README.md`, `docs/contracts/learning-ai-v1.md`
- `docs/qa/acceptance-matrix.md`, `docs/architecture/decision-log.md`
- `docs/codex/2026-09-28-stage-79-muse-spark-high-xhigh-vision-pool-proof/`

## Risks
- ادعاي High/Xhigh بدون پروب جداگانه — با پروب زنده هر دو effort مهار شد.
- effort نامعتبر ممکن بود ساکت قبول شود — با fail-closed `AI_ROUTE_NOT_ALLOWED` کنترل شد.
- چرخش پروکسي ممکن بود به کد نسبت داده شود — مالکيت با خود 9Router ماند.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` سبز (68 تست).
- همه capabilityها فقط `oc/muse-spark-1.3-contributor-free` با High/Xhigh برگردانند.
- docs قرارداد و matrix بهروزرساني و validator ساختار سبز باشد.
