# Verification

## Summary
- Result: partial
- Last verified: 2026-10-02
- Scope: local slice only (cloud execution intentionally not run)

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| Gateway focused suite | `venv/Scripts/python -m unittest discover -s services/ai_gateway -p 'test_*.py'` | passed | `Ran 125 tests` / `OK` |
| Flutter gateway client | `flutter test test/trace_gateway_client_test.dart` | passed | `00:00 +4: All tests passed!` |
| Flutter analyze | `flutter analyze lib/services/trace_gateway_client.dart test/trace_gateway_client_test.dart` | passed | `No issues found!` |
| Python compile | `venv python -m py_compile supabase_backend/on_demand_run/cloud_gateway/api-trace-ai-run` | passed | `COMPILE_OK` |
| Diff whitespace | `git diff --check` | passed | clean به‌جز warning قدیمی CRLF در `docs/codex/_index.md` |
| Receipt/secret scan | `grep -RIn secret patterns in new gateway files` | passed-local | فقط نام banned داخل assertion تست‌ها؛ هیچ credential واقعی نیست |

## Not Run
- اجرای migration روی Supabase واقعی (بدون دستور صریح ممنوع بود).
- `supabase` و `vercel` در این محیط نصب نیستند (`command not found`).
- deploy/preview و smoke ابری با env/JWT واقعی.

## Known Issues
- ورودی `on_demand_run.py` در annotation از `object` به‌جای تایپ دقیق استفاده می‌کند و نمایش `***` فقط artifact نمایشی است؛ behavior/compile سالم است ولی cleanup تایپ جدا می‌خواهد.
- migration نوشته شد ولی RLS/claim روی Postgres واقعی اثبات نشده است.
- بسته‌بندی `sys.path` در adapter روی Vercel بدون deploy واقعی verify نشده است.
