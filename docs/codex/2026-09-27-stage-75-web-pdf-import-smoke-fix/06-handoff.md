# Handoff

## Outcome

Stage 75 closes the gap Stage 74 left open: the real Chrome web smoke now proves
native-chooser PDF and Markdown import, with exact original bytes surviving a
reload, on the Stage 74 web build.

## Changed Artifacts

- `tool/smoke_web_library.py` — import runs while the collection stays selected,
  clicks `Manage` then the format-specific import button at viewport-relative
  coordinates, performs exactly one reload after import, and closes Chrome over
  CDP before temp-profile cleanup.
- `tool/test_smoke_web_library.py` — new regression contract (3 tests).
- `docs/codex/2026-09-27-stage-75-web-pdf-import-smoke-fix/` — this task folder.
- `docs/codex/_index.md` — Stage 75 row.

## How To Continue

```text
python tool/serve_web_with_coop.py --port 8766
TRACE_SMOKE_IMPORT=1 python -u tool/smoke_web_library.py
TRACE_SMOKE_PDF=1 python -u tool/smoke_web_library.py
python -m unittest tool/test_smoke_web_library.py -v
```

## Done

- Root cause found and fixed in the harness only.
- Both import legs green against the real browser, with byte-level reload proof.
- Regression contract added and passing.

## Remaining

- None within Stage 75.
- Broader product backlog (not this stage): real source Vision fidelity proof and
  cross-device sync proof.

## Verification

- Harness contract 3/3, Markdown smoke exit 0, PDF smoke exit 0, gateway suite
  65/65, tool suite 11/11, `git diff --check` clean.
- Not re-run: Flutter tests and platform rebuilds, because no product code
  changed. See `05-verification.md`.
