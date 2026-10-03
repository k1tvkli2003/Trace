# Plan

## Approach
رفتار از trusted caller به page authorization، PNG/hash validation، prompt موجود، route ثابت، BudgetedRun، stream کامل، JSON/schema validation و receipt امن می رسد. هیچ mutation یا ذخیره سازی منبع در adapter نیست.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | audit، HEAD، guard و validator؛ 68 تست پایه |
| 2 | done | قرارداد پذیرش و ownership تثبیت شد |
| 3 | done | RED/GREEN برای استخراج، replay و concurrency؛ 12 تست adapter |
| 4 | done | scope، PNG/hash، budget، stream، schema، HTTP و deadline guards |
| 5 | done | final suite و docs آماده؛ live route محدود fail-closed؛ commit f9c0e89 ثبت شد، verdict ریویو باقی است |

## Live Proof Policy
پروب فقط با همان raster واقعی Stage79، همان مدل و همان endpoint انجام شد. سقف `1800` به `AI_INCOMPLETE_RESPONSE` رسید؛ سقف `4096` به `AI_SCHEMA_REJECTED` رسید. این شکست‌ها source نساختند و adapter رفتار fail-closed نشان داد. تلاش بیشتر بدون raw response مجاز نیست.

## Interfaces and Artifacts
- `services/ai_gateway/page_vision.py`, `test_page_vision.py`
- همین task docs و safe logs؛ README و acceptance matrix

## Risks
- scope از caller قابل اعتماد است؛ public auth endpoint ساخته نمی شود.
- مدل ممکن است سقف 4096 را برای صفحه متراکم پر کند؛ incomplete رد و retry خودکار ممنوع.
- schema-valid با fidelity برابر نیست؛ source review مستقل لازم است.

## Acceptance Checks
- unauthorized/hash mismatch/invalid PNG پیش از spend رد شوند.
- duplicate همان operation از cache RAM replay، conflict و concurrent call رد شوند.
- stream فقط completed، usage معتبر، JSON strict و page-extract-v1 معتبر پذیرفته شود.
- HTTP/deadline/oversize/malformed paths امن؛ credential/raw body چاپ نشود.
- full suite، docs validator، diff-check و opt-in live receipt.
