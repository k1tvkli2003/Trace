# Handoff

## Outcome

Same-profile second live Chrome tab reads the exact committed collection bytes in IndexedDB `trace_local_v1`, after tab 1 imported a real PDF and survived reload. Tab 2 renders saved collection in sidebar but does not auto-open tab 1's selected collection. No concurrent-write safety claim.

## Changed Artifacts

- `tool/smoke_web_library.py`: optional `TRACE_SMOKE_MULTITAB=1` tab-2 read probe and optional screenshot.
- `tool/test_smoke_web_library.py`: bounded contract test.
- `docs/qa/acceptance-matrix.md`: scoped read-only evidence.
- `assets/trace-stage76.tab2.png` and `logs/trace-stage76-run.log`: real proof.

## How To Continue

Run `python tool/serve_web_with_coop.py --port 8766` from repo root, then `TRACE_SMOKE_MULTITAB=1 TRACE_SMOKE_PDF=1 python -u tool/smoke_web_library.py`. A future safety gate must test two simultaneous writes and conflict behavior separately before changing the matrix claim.

## Done

- Second-tab read-only visibility proven; data and domain suites remain green.

## Remaining

- None in Stage76. Simultaneous-write safety, no-OPFS, private mode, and eviction remain outside this scope.

## Verification

- Tool 12/12, gateway 65/65, data 160/160, domain 114/114. Real Chrome run exit 0. No app product code changed.