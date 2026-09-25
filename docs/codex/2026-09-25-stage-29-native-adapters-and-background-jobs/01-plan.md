# Plan

## Approach
اول قرارداد خالص دامنه (`PlatformCapabilities` + `DueNoticePolicy`)؛ بعد آداپتر نازک اپ (`TracePlatformNotifier` با foreground-only صادقانه)؛ بعد کمک‌تابع خالص resume صفحات (`remainingRenderPages`)؛ هر تکه با RED→GREEN عمودی tracer.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | ثبت brief/state/progress و مرز no-native-plugin/no-schema-change |
| 2 | done | RED: capability gate + due-notice policy + resume-set؛ خروج غیرصفر به‌علت نبود API ثبت شد |
| 3 | done | GREEN: قرارداد دامنه `platform_capabilities.dart` خالص |
| 4 | done | GREEN: آداپتر اپ `platform_notifier.dart` و helper `render_resume.dart` با delivery صادقانه |
| 5 | done | suite کامل، docs validation و commit باقی است؛ committed slice `e18f516` |

## Interfaces and Artifacts
- `packages/trace_domain/lib/src/models/platform_capabilities.dart`
- `apps/trace_flutter/lib/platform_notifier.dart`
- `apps/trace_flutter/lib/render_resume.dart`
- `packages/trace_domain/test/platform_capabilities_test.dart`
- `apps/trace_flutter/test/platform_notifier_test.dart`
- `docs/codex/2026-09-25-stage-29-native-adapters-and-background-jobs/`

## Risks
- ادعای background delivery بدون شاهد: mitigation قرارداد صریح `deliverAfterRestart` و fallback نمایشی.
- قاطی‌شدن locator نمایشی با identity: locator فقط display-only است.
- بک‌گراند واقعی OS خارج از تست: فقط decision خالص تست می‌شود، نه ارسال OS.

## Acceptance Checks
- هر request پلتفرم بدون `supported=true` همان capability رد fail-closed می‌شود.
- نامزد notification فقط از due فعال و رسیده می‌آید و در برابر تکرار idempotent است.
- مجموعهٔ resume فقط صفحات درخواستیِ ناتمام با order قطعی است؛ checkpoint ناسازگار خروجی تهی می‌دهد نه حدس.
- suite محدود و analyze پاس.
