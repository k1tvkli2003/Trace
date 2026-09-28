# Stage 80 server-side bounded page Vision adapter

- Task ID: `2026-09-28-stage-80-server-side-bounded-page-vision-adapter`
- Status: `ready-for-review`
- Created: 2026-09-28T11:41:02
- Language: fa

## Request
ادامه مسیر Trace: اتصال واقعی Vision به قرارداد موجود، بدون OCR، تغییر مدل، fallback یا کلید در Flutter.

## Success Criteria
- یک عملیات سروری فقط صفحه PNG مجاز و hash-bound را بپذیرد؛ منبع و pageRef خارج از scope قبل از شبکه رد شوند.
- `NineRouterRouting` مالک route، `BudgetedRun` مالک سقف و replay، و `validate_page_extract` مالک نتیجه باقی بمانند.
- stream ناقص، JSON خراب، schema غلط، timeout و HTTP failure خروجی پذیرفته نسازند.
- usage، request ID، hash و latency ثبت شوند؛ کتاب، کلید و raw provider error وارد telemetry نشوند.
- تست هدفمند و کامل سبز؛ پروب زنده محدود با همان raster Stage79 و همان route انجام شود.

## Context
HEAD پایه `846a94f`؛ 68 تست gateway سبز. Stage79 فقط تشخیص یک جمله روی raster واقعی را اثبات کرد، نه transcription کامل. adapter فعلی وجود ندارد.

## In Scope
- یک adapter درون فرایند سرور برای یک page-extract-v1؛ stdlib HTTP و SSE.
- scope صریح از caller قابل اعتماد؛ credential فقط از محیط سرور.
- deadline واقعی، سقف byte/token، خطاهای امن، replay همان عملیات.
- تست، live receipt، docs و commit.

## Out of Scope
- HTTP API عمومی، ورود کاربر، deploy، Flutter wiring، DB/cache/ledger پایدار.
- ادعای fidelity کامل، lesson generation، sync یا release.

## Assumptions
- caller سرور page scope مجاز را پس از ownership check می دهد؛ این adapter جایگزین auth API نیست.
- مجوز پروب کوتاه با صفحه موجود برقرار است؛ route ثابت قبلی حفظ می شود.
