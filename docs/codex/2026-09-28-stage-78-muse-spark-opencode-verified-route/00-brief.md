# Stage 78 Muse Spark OpenCode verified route

- Task ID: `2026-09-28-stage-78-muse-spark-opencode-verified-route`
- Status: `ready-for-review`
- Created: 2026-09-28T03:02:20
- Language: fa

## Request
Trace فقط از 9Router و provider OpenCode با proxy pool اشتراک موجود استفاده کند؛ بدون استخراج اطلاعات محلي. مدل Muse Spark 1.3 با reasoning High/Xhigh و Vision سالم. اطلاعات Stage77 دست نخورده بماند.

## Success Criteria
- همه capabilityهاي Trace (`structure_scan`، `page_vision_extract`، `slice_planner`، `teacher_fa`، `coach`) فقط به `oc/muse-spark-1.3-contributor-free` با reasoning `high` (پيشفرض) از endpoint `http://127.0.0.1:20128/v1/responses` مسير شوند؛ `xhigh` فقط fallback تأييدشده زنده است.
- مدل/route ديگر و fallback ضمني رد شود.
- Vision صفحه ساختهشده مصنوعي در دو درخواست زنده با `oc` + High مقدار دقيق `VISION:42` بدهد؛ يک پروب `oc` + Xhigh هم `VISION:42` داد.
- Suite کامل `services/ai_gateway` سبز بماند (66 تست).

## Context
Pool فعال OpenCode با `rotateStrategy=round-robin` و 33 pool فعال/strict روي لوپبک زنده است؛ پروب هر چند دقيقه pool را با پروکسيهاي فعال بهروز ميکند (`9Router-Pool-Refresh` آماده، `refresh_cycle.py` موجود). مرحله Chat غيراستریم براي همين مدل پاسخ 200 ولي خالي/`in_progress` داد؛ مسير تأييدشده Responses استريم SSE است. `ocz` سقف مصرف آزاد داشت؛ پس فقط `oc` در policy ماند. هر دو High و Xhigh روي تصوير مصنوعي `VISION:42` کامل دادند، ولي پيشفرض policy همان High است.

## In Scope
- تغيير policy آفلاين `go_routing.py` و پوشش تست `test_go_routing.py`.
- مستندسازي قرارداد و ثبت شواهد زنده در همين تسک.

## Out of Scope
- اتصال شبکهاي Trace يا آداپتر provider جديد.
- تغييرات Stage77 يا بقيه محصول.
- ادعاي استخراج واقعي PDF يا درس فارسي.

## Assumptions
- کليد درخواست از `NINEROUTER_API_KEY` ذخierهشده محيط خوانده شد و مقدار آن چاپ/ذخيره نشد.
- تصوير پروب مصنوعي و موقت بود؛ براي محتواي کتاب/کاربر استفاده نشد.
