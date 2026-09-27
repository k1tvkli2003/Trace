# Verification

## Summary

- Result: passed
- Last verified: 2026-09-27T04:10:00+03:30
- Server under test: `python tool/serve_web_with_coop.py --port 8766` serving the
  Stage 74 `build/web` artifact, confirmed `HTTP=200`.

## Checks

| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| Harness regression contract | `python -m unittest tool/test_smoke_web_library.py -v` | passed | `Ran 3 tests ... OK` |
| Markdown import + reload | `TRACE_SMOKE_IMPORT=1 python -u tool/smoke_web_library.py` | passed | `PASS: native Chrome chooser imported .md and original survived reload`, `MD_EXIT=0` |
| PDF import + reload | `TRACE_SMOKE_PDF=1 python -u tool/smoke_web_library.py` | passed | `PASS: native Chrome chooser imported .pdf and original survived reload`, `PDF_EXIT=0` |
| Storage probe identity | same runs, `STORAGE:` line | passed | `{"hit":true,"names":["blocks","files"],"storeMode":"raw"}` before and after reload |
| Gateway suite | `python -m unittest discover -s services/ai_gateway -p "test_*.py"` | passed | `Ran 65 tests ... OK` |
| Tool suite | `python -m unittest discover -s tool -p "test_*.py"` | passed | `Ran 11 tests ... OK` |
| Whitespace hygiene | `git diff --check` | passed | exit 0 |

## Not Run

- `flutter test` and web/APK/Windows rebuilds: no product code changed in this
  stage, so the Stage 74 build evidence remains the applicable baseline.
- Supabase, RLS, and second-device sync: outside this stage's scope.
- PDF Vision extraction fidelity: this stage proves the original bytes are stored
  and reloaded, not that a page was transcribed.

## Known Issues

- Coordinates are viewport-relative but calibrated for the current Sources panel
  layout; a layout change will fail loudly in the contract test rather than
  silently skip.
- The Stage 74 critic note about multi-reload persistence remains an open
  product-side question, untouched here.
