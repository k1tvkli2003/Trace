# Plan

## Approach

Rebuild all three release targets on the current HEAD (post-Stage73
validator close), serve the web build with COOP/COEP, run the real Chrome
smoke, then record honest evidence. No claim without a fresh artifact
timestamp.

## Steps

| Step | Status | Notes |
|---|---|---|
| 1 | done | Diagnose smoke flake: first click before WASM library frame; CDP context race |
| 2 | done | Patch `tool/smoke_web_library.py`: bounded retry + execution-context tolerance |
| 3 | done | Smoke PASS on pre-rebuild build (baseline); suites green |
| 4 | active | Rebuild web, apk, windows on current HEAD |
| 5 | planned | Re-run smoke against fresh web build |
| 6 | planned | Secret/bundle/codename/ignore checks, docs, commit |

## Interfaces and Artifacts

- `tool/smoke_web_library.py` — collection persistence smoke.
- `tool/serve_web_with_coop.py` — local COOP/COEP server on `127.0.0.1:8766`.
- `apps/trace_flutter/build/web`, `build/app/outputs/flutter-apk/app-release.apk`,
  `build/windows/x64/runner/Release/trace_flutter.exe`.

## Risks

- Web build stale (`main.dart.js` 2026-09-25) until rebuild lands.
- APK identity still `com.example.trace_flutter` versionCode 1 — not a store
  artifact; report honestly, do not rename without user identity decision.
- PDF import smoke path uses fixed pixels; out of scope this stage.

## Acceptance Checks

- Smoke prints `PASS: exact collection persisted in IndexedDB across Chrome reload`.
- Artifact timestamps newer than `58fe085` commit time.
- Suites: gateway 65, data 160, domain 114, app 41.
