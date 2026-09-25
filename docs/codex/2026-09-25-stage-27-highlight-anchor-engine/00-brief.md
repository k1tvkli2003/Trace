# Stage 27 highlight anchor engine

- Task ID: `2026-09-25-stage-27-highlight-anchor-engine`
- Status: `ready-for-review`
- Created: 2026-09-25T10:27:13
- Language: fa

## Request
ادامهٔ Trace: موتور anchor هایلایت با rehydration صریح و repair بدون جابه‌جایی بی‌صدا؛ quote و prefix/suffix و sourceBlock و hash و bbox طبق قرارداد بخش ۹ پلن.

## Success Criteria
- انتخاب ذخیره‌شده با quote و prefix/suffix و sourceBlockId و pageId و offsets و bbox و `contentHashAtCreation` persist شود و regeneration آن را بی‌صدا جابه‌جا نکند.
- ترتیب rehydration رعایت شود: exact block+hash، سپس quote داخل block، سپس prefix/suffix، سپس fallback صفحه+bbox، و در پایان وضعیت `DETACHED` با repair صریح.
- متن فارسی فقط با whitespace normalization تطبیق داده شود؛ بازنویسی Yeh/Kaf یا حدس متن ممنوع.
- تست RED/GREEN و suite/analyze محدود اجرا و مرزهای اثبات ثبت شود.

## Context
HEAD اولیه `63927f7`؛ `LocalAnnotationRepository` موجود anchor/note و tombstone را نگه می‌دارد ولی evaluator مستقل rehydration و گذار صریح `DETACHED` ندارد. `putAnchor` هر تفاوت JSON را immutable خطا می‌دهد پس تغییر وضعیت هم فعلاً مسیری ندارد. `StudyHub-Web` فقط reference است.

## In Scope
- evaluator خالص دامنه برای rehydration و نتیجهٔ خوانا.
- متد repository برای `rehydrate` فقط‌خواندنی و `markDetached` صریح.
- آزمون SQLite برای exact و quote-moved و prefix/suffix و detached و Persian whitespace.

## Out of Scope
- UI انتخاب و repair در Flutter، drawing note، sync/auth، ingest واقعی و ادعای device.
- تغییر schema یا migration؛ جدول‌های `HighlightAnchors` و `StudyNotes` کافی‌اند.

## Assumptions
- rehydrate چیزی نمی‌نویسد؛ فقط `markDetached` وضعیت `attached` را به `detached` می‌برد.
- repair با anchor تازه (ID تازه) در گام بعدی می‌آید؛ این slice فقط تشخیص و detach صریح است.
