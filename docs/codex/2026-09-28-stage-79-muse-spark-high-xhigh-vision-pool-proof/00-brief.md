# Stage 79 muse spark high xhigh vision pool proof

- Task ID: `2026-09-28-stage-79-muse-spark-high-xhigh-vision-pool-proof`
- Status: `ready-for-review`
- Created: 2026-09-28T04:26:53
- Language: fa

## Request
AI فقط از 9Router با provider OpenCode و proxy pool اشتراک موجود باشد؛ بدون استخراج محلي. مدل Muse Spark 1.3 با reasoning High يا Xhigh و Vision سالم. سپس Vision با يک PDF واقعي کوتاه از ويندوز اثبات شود.

## Success Criteria
- همه capabilityهاي Trace فقط به `oc/muse-spark-1.3-contributor-free` با reasoning `high` (پيشفرض) يا `xhigh` (صريح) از endpoint `http://127.0.0.1:20128/v1/responses` مسير شوند.
- effort ديگر، مدل/route ديگر و fallback ضمني رد شود.
- يک صفحه از PDF واقعي رندوم، فقط پس از rasterization، با High و Xhigh پاسخ `response.completed` و متن قابل تشخيص بدهد.
- suite کامل `services/ai_gateway` سبز بماند (68 تست).

## Context
Pool فعال OpenCode با `rotateStrategy=round-robin` روي لوپبک زنده است؛ تسک `9Router-Pool-Refresh` هر چند دقيقه pool اشتراک را بهروز ميکند. در شروع probe، catalog `oc` را داشت؛ هنگام تکرار بعدي catalog live موقتا بدون `oc` بود، اما همان endpoint و مدل policy در SSE با موفقيت پاسخ داد. اين تغيير drift runtime است، نه مجوز fallback.

## In Scope
- گسترش آفلاين `go_routing.py` براي `high`/`xhigh` صريح با fail-closed.
- پوشش تست `test_go_routing.py` براي هر دو effort و رد effort نامعتبر.
- رندر يک PDF واقعي کوتاه به PNG؛ بدون خواندن text layer و بدون OCR.
- پروب زنده همان raster با `oc` + High و Xhigh.
- ثبت hash، صفحه، render profile، usage، latency و پاسخ خام محدودشده.

## Out of Scope
- فعالسازي AI در Flutter يا ادعاي استخراج کامل PDF/درس فارسي.
- fallback به `ocz`، `cl/*`، provider ديگر يا استخراج محلي.

## Assumptions
- کليد درخواست فقط از `NINEROUTER_API_KEY` محيط خوانده شد و مقدار آن چاپ/ذخيره نشد.
- PDF از دسکتاپ، حداکثر 20 صفحه و 35 MB، با انتخاب تصادفي سيستمي انتخاب شد.
- ورودي مدل فقط raster صفحه بود؛ PDF خام به provider ارسال نشد.
