# Plan

## Approach
ابتدا evaluator خالص در `trace_domain` برای ترتیب rehydration بخش ۹؛ سپس فقط‌خواندنی `rehydrateAnchor` و گذار صریح `markDetached` در `LocalAnnotationRepository` بدون تغییر متن ذخیره‌شده.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | ثبت brief/state/progress و مرز no-schema-change |
| 2 | done | RED: تست exact و quote-moved و prefix/suffix و detached و Persian whitespace |
| 3 | done | GREEN: `rehydrateHighlight` در دامنه با enum نتیجه و reason |
| 4 | done | GREEN: `rehydrateAnchor` و `markDetached` در repository با tombstone/locator check |
| 5 | done | suite داده/دامنه و analyze و format و docs validation پاس؛ committed in e52a638. |

## Interfaces and Artifacts
- `packages/trace_domain/lib/src/models/highlight_rehydration.dart`
- `packages/trace_domain/lib/trace_domain.dart` (export تازه)
- `packages/trace_data/lib/src/local/local_annotation_repository.dart`
- `packages/trace_data/test/highlight_rehydration_test.dart`
- `docs/codex/2026-09-25-stage-27-highlight-anchor-engine/`

## Risks
- تطبیق رشته‌ای فارسی با فاصله/نیم‌فاصله ناپایدار شود؛ فقط whitespace collapse مجاز است.
- offset به‌تنهایی identity شود؛ quote/block/hash/bbox باید داور بمانند.

## Acceptance Checks
- `rehydrateAnchor` برای anchor موجود: attached با reason دقیق یا detached-candidate بدون write.
- `markDetached` فقط attached را به detached می‌برد؛ tombstoned یا detached دوباره خطا می‌دهد.
- suite داده و دامنه و analyze/format پاس.
