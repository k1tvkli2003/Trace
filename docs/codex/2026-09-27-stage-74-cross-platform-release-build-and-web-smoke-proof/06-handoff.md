# Handoff

## Outcome

Stage 74 release-proof slice passes locally. Flutter 3.44.0 built Web, APK,
Windows on HEAD `58fe085`; real Chrome collection creation persisted exact
SQLite page bytes in IndexedDB across reload. It is **not** a production
release, signed store artifact, or complete Trace §18 flow.

## Changed Artifacts

- `tool/smoke_web_library.py` — bounded retry for the WASM library frame and
  transient CDP execution context; no product behavior change.
- `apps/trace_flutter/.gitignore` — ignores generated Android Kotlin session.
- `docs/codex/2026-09-27-stage-74-cross-platform-release-build-and-web-smoke-proof/`
  — evidence and honest limits.
- `docs/qa/acceptance-matrix.md` — Stage74 release-build and persistence rows.
- `docs/codex/_index.md` — Stage74 row.

## How To Continue

1. Repair `TRACE_SMOKE_PDF` path in the smoke tool: fixed coords no longer match
   responsive Sources panel. Prefer Flutter test integration finder or a CDP
   accessible-control locator; do not use the nonfunctional headless
   semantics placeholder (`flt-semantics-placeholder` is offscreen at -0.5).
2. Prove native Android install/upgrade and Windows launch on real targets.
3. Run personal-route Vision/cost pilot and second-device sync before marking
   §18 done. No substitute fabricated evidence.

## Done

- Local three-target builds + Chrome persistence smoke + all four suites.
- Secret scan, debug-signed APK identity, `.kotlin` ignore check.

## Remaining

- User-owned production package identity/signing; do not use debug cert.
- Browser no-OPFS/multi-tab/quota behavior, device smoke, CI run, live AI,
  second-device sync.

## Verification

See `05-verification.md` for commands, outputs, hashes and limitations.
