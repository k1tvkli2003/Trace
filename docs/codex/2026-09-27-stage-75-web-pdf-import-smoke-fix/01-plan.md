# Plan

## Approach

Keep the product untouched and repair only the smoke harness so it drives the real
control path in one page lifetime: create collection -> `Manage` opens Sources ->
`Import PDF` opens the native chooser -> verify bytes -> one reload -> verify again.

## Steps

| Step | Status | Notes |
|---|---|---|
| 1 | done | Reproduce `Real file picker did not open` against COOP/COEP port 8766 |
| 2 | done | Read `chat_workspace.dart` context bar and vision-read the fresh screenshot to locate real controls |
| 3 | done | Move the import block before the reload; selection is UI-only memory |
| 4 | done | Replace stale fixed coordinates with viewport-relative positions per format |
| 5 | done | Add one post-import reload that re-verifies imported original bytes |
| 6 | done | Close Chrome over CDP before temp-profile cleanup |
| 7 | done | Add `tool/test_smoke_web_library.py` as the regression contract |

## Interfaces and Artifacts

- `tool/smoke_web_library.py` — env contract unchanged: `TRACE_SMOKE_PDF`, `TRACE_SMOKE_IMPORT`, `TRACE_SMOKE_SCREENSHOT`, `TRACE_WEB_URL`.
- `tool/test_smoke_web_library.py` — new unittest contract.
- `docs/codex/2026-09-27-stage-75-web-pdf-import-smoke-fix/`.

## Risks

- Pixel coordinates can drift with layout or viewport size; mitigation is viewport-relative math plus a contract test that fails if the ordering regresses.
- A reload placed between selection and the picker silently loses selection; mitigation is an explicit `assertNotIn('Page.reload', import_block)`.

## Acceptance Checks

- `python -m unittest tool/test_smoke_web_library.py -v` passes.
- `TRACE_SMOKE_PDF=1` and `TRACE_SMOKE_IMPORT=1` runs both print the import PASS and the reload persistence PASS with exit 0.
