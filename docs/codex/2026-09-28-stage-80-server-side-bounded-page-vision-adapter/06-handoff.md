# Handoff

## Outcome
سرور اکنون adapter محدود و تایپ شده برای Vision یک صفحه دارد: scope صفحه، hash تصویر، route ثابت و مدل مجاز، budget، SSE، schema و replay در حافظه. تست محلی سبز است. پروب زنده با همان raster Stage79 دو بار به نتیجه قابل ذخیره نرسید؛ هر دو fail-closed شدند. این مرحله را با proof محصول اشتباه نگیرید.

## Changed Artifacts
- `services/ai_gateway/page_vision.py`, `test_page_vision.py`
- `services/ai_gateway/nine_router_transport.py`, `test_nine_router_transport.py`
- همین work docs و ردیف `docs/codex/_index.md`

## How To Continue
- ابتدا review code/security را ببندید؛ سپس با تصمیم مشخص برای حفاظت raw response، mismatch schema زنده را تشخیص دهید. قبل از رفع آن، هیچ `SourceBlock` از صفحه واقعی ادعا نکنید.
- مرحله بعد باید adapter را پشت auth مالکیت و job/cache/ledger پایدار قرار دهد؛ API عمومی فعلا وجود ندارد.

## Done
- local adapter/transport، 20 تست هدفمند و 88 تست کامل سبز، validator `OK`.

## Remaining
- live schema-valid page extraction، fidelity review، persistence و Flutter wiring باز هستند.

## Verification
- live max1800: `AI_INCOMPLETE_RESPONSE`; max4096: `AI_SCHEMA_REJECTED`. هیچ کدام source پذیرفته نساختند.
