# Stage 79 muse spark high xhigh vision pool proof

- Task ID: `2026-09-28-stage-79-muse-spark-high-xhigh-vision-pool-proof`
- Status: `ready-for-review`
- Created: 2026-09-28T04:26:53
- Language: fa

## Request
AI فقط از 9Router با provider OpenCode و proxy pool اشتراک موجود باشد؛ بدون استخراج محلي. مدل Muse Spark 1.3 با reasoning High يا Xhigh و Vision سالم.

## Success Criteria
- همه capabilityهاي Trace فقط به `oc/muse-spark-1.3-contributor-free` با reasoning `high` (پيشفرض) يا `xhigh` (صريح) از endpoint `http://127.0.0.1:20128/v1/responses` مسير شوند.
- effort ديگر، مدل/route ديگر و fallback ضمني رد شود.
- Vision صفحه مصنوعي با `oc` + High و `oc` + Xhigh مقدار دقيق `VISION:42` بدهد.
- Suite کامل `services/ai_gateway` سبز بماند (68 تست).

## Context
Pool فعال OpenCode با `rotateStrategy=round-robin` روي لوپبک زنده است؛ تسک زمانبندي `9Router-Pool-Refresh` هر چند دقيقه pool اشتراک را بهروز ميکند. catalog زنده `TOTAL 24` با `oc` و `ocz` هر دو `vision:true` و `pdf:false` است. policy فقط `oc` است چون Stage78 براي `ocz` سقف مصرف آزاد ديد. ورودي تأييدشده فقط raster صفحه است، نه PDF خام.

## In Scope
- گسترش آفلاين `go_routing.py` براي `high`/`xhigh` صريح با fail-closed.
- پوشش تست `test_go_routing.py` براي هر دو effort و رد effort نامعتبر.
- مستندسازي قرارداد و ثبت شواهد زنده در همين تسک.

## Out of Scope
- اتصال شبکهاي Trace يا آداپتر provider جديد.
- تغيير provider/model يا فعالسازي AI در Flutter.
- ادعاي استخراج واقعي PDF يا درس فارسي.

## Assumptions
- کليد درخواست از `NINEROUTER_API_KEY` محيط خوانده شد و مقدار آن چاپ/ذخيره نشد.
- تصوير پروب مصنوعي و موقت بود؛ براي محتواي کتاب/کاربر استفاده نشد.
