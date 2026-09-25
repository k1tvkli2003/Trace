# Plan

## Approach
Inbox را روی endpoint دادهٔ موجود `listDueItems` و replay روی `readArtifact` سوار کن؛ شواهد ارجاع را از جدول‌های محلی بخوان؛ وضعیت نمایش را در presenter سادهٔ Flutter نگه دار؛ شروع را از shell همین حالا ممکن بگذار. بدون generated lesson، مدل یا mutation.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Boundary inspection finished; thin ViewModel plan chosen. |
| 2 | done | RED: missing inbox repository, fractional-clock empty due, citation dialog absent. |
| 3 | done | Inbox repository + ViewModel + cache-only page with citation evidence. |
| 4 | done | Shell entry plus app navigation/widget coverage. |
| 5 | active | Suites, analyzes, web build passed; docs validation and commit follow. |

## Interfaces and Artifacts
- Viewer input: UTC `nowUtc`, DB repositories; output: due rows, artifact, locators, failed-replay error.
- New: `apps/trace_flutter/lib/app/review_inbox_view_model.dart`, `apps/trace_flutter/lib/review_inbox_page.dart`, `test/review_inbox_view_model_test.dart`, گسترش app widget test.
- Changed: `MainApp`/`ChatWorkspace` برای بازکردن inbox محلی و تداوم DB.
- Untouched: `applyStateAction`, scheduler projection, `TeachingPreviewPage`.

## Risks
- نمایش مرور ناآماده به‌علت اختلاف clock/timezone: now UTC ورودی لازم؛ fallback نمایش local بدون ذخیره.
- نمایش غیرمستقیم preview sample: صفحهٔ مرور target ID را فقط با `lesson_box` + artifact هم‌hash باز می‌کند.
- Missing citations/figures: درس ذخیره‌شده معتبر است ولی evidence خاموش یا corrupt است؛ replay را fail-closed کن.

## Acceptance Checks
- Inbox فقط active due را مرتب‌شده نشان می‌دهد و refresh دارد.
- انتخاب due معتبر، همان artifact با citations و locator را بدون AI باز می‌کند.
- Unsupported/missing/fake lesson به‌جای replay خطای صریح نشان می‌دهد.
- `flutter test --no-pub`, analyze، `flutter build web --no-pub` و `validate_task_docs.py` تعیین‌تکلیف می‌شوند.
