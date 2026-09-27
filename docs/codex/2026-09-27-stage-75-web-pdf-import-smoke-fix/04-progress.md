# Progress

## Log

| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-27T02:20+03:30 | active | Re-ran PDF smoke on the Stage 74 build; it failed with `Real file picker did not open` | headless Chrome run |
| 2026-09-27T02:35+03:30 | active | Traced the failure: the harness reloaded after collection creation, and `main.dart` clears `_selectedId` on reload, so the old Manage click opened nothing | `main.dart`, `chat_workspace.dart` |
| 2026-09-27T02:50+03:30 | active | Moved the import block before the reload; added one post-import reload that re-checks imported bytes | `tool/smoke_web_library.py` |
| 2026-09-27T03:05+03:30 | active | PDF leg still missed the chooser; measured a fresh 768x480 screenshot — Sources panel `Import PDF` at about x 460, y 137 | screenshot analysis |
| 2026-09-27T03:20+03:30 | active | Replaced fixed coordinates with viewport-relative math; PDF leg green | smoke output |
| 2026-09-27T03:35+03:30 | active | Shared coordinate would have clicked PDF in Markdown mode too; split x per format (0.60 vs 0.40 of width) | smoke run + test |
| 2026-09-27T03:50+03:30 | active | Markdown run passed but temp-profile cleanup hit `WinError 32`; added `Browser.close` before terminate | smoke output |
| 2026-09-27T04:10+03:30 | ready-for-review | Contract tests 3/3, MD + PDF legs green, gateway 65/65, tool suite 11/11 | `05-verification.md` |

## Done So Far

- Root cause identified and fixed in the harness only.
- Native-chooser import proven for both `.md` and `.pdf`, before and after reload.
- Regression contract test added.

## Next

- Reviewer approval, then the next product gate needs real source Vision fidelity
  evidence, not harness work.
