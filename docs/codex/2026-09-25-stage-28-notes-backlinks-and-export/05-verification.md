# Verification

## Summary
- Result: partial
- Last verified: 2026-09-25

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| RED proof | `flutter test --no-pub test/notes_backlinks_test.dart` پیش از پیاده‌سازی | passed (RED دیده شد: `listNotesForAnchor` و `exportNote` ناموجود بودند) | خروجی ترمینال: خطای `isn't defined` برای هر دو متد |
| GREEN backlinks | `flutter test --no-pub test/notes_backlinks_test.dart` | passed | `00:00 +2: All tests passed!` |
| Data suite | `flutter test --no-pub` در `packages/trace_data` | passed | `00:02 +107: All tests passed!` |
| Domain suite | `flutter test --no-pub` در `packages/trace_domain` | passed | `00:02 +112: All tests passed!` |
| App suite | `flutter test --no-pub` در `apps/trace_flutter` | passed | `00:05 +39: All tests passed!` |
| Analyze | `flutter analyze --no-pub` در `packages/trace_data` | passed | `No issues found!` |
| Format scope | `dart format` روی ۴ فایل slice و `--set-exit-if-changed` | passed | `0 changed` روی scope؛ کل `lib test` داده ۶ فایل قدیمی را touch می‌کند پس commit فقط scope |
| Docs validation | `validate_task_docs.py <stage-28>` + `git diff --check` | passed | `Task docs ... OK` و بدون whitespace error |

## Not Run
- Gateway python tests این slice را لمس نمی‌کند؛ آخرین بار ۵۰ تست در Stage 27 پاس بود.
- UI/device/browser/E2E و sync واقعی؛ مطابق مرز slice آفلاین.

## Known Issues
- `dart format` روی کل `lib test` داده چند فایل قدیمی را تغییر می‌دهد؛ در commit فقط فایل‌های slice.
