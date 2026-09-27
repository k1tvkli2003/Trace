# Stage 74 cross platform release build and web smoke proof

- Task ID: `2026-09-27-stage-74-cross-platform-release-build-and-web-smoke-proof`
- Status: `done`
- Created: 2026-09-27T01:25:13
- Language: en

## Request

Standing goal continued after Stage 73 close (`ca6f9e7`). Prove the same
release commit builds for all three Trace targets and that the web build
actually runs: collection creation, IndexedDB persistence across reload in a
real Chrome profile, with secrets/Bundle hygiene verified.

## Success Criteria

1. `flutter build web --release --no-pub` artifact timestamps fresh on this commit.
2. `flutter build apk --release --no-pub` artifact timestamp fresh on this commit.
3. `flutter build windows --release --no-pub` artifact timestamps fresh on this commit.
4. `tool/smoke_web_library.py` PASS against the fresh web build with COOP/COEP.
5. Tracked-secret grep clean; web bundle secret-pattern check clean; StudyForge
   codename absent from tracked code; `.kotlin` session file ignored.
6. Full suites green: gateway 65/65, trace_data, trace_domain, app widget tests.

## Context

Stage 73 validator change is the release candidate. Earlier Stage 74 work
(sequential web/apk/windows + browser smoke) pre-dated the fix, so artifacts
must be rebuilt on the new HEAD before claims. Smoke was flaky twice: dialog
missed on first click during WASM open, CDP execution-context race. Both are
script races, not product bugs; bounded retry in tooling is the fix.

## In Scope

- Release builds on current HEAD.
- Web smoke proof via `tool/serve_web_with_coop.py` + `tool/smoke_web_library.py`.
- Secret/bundle/codename/ignore hygiene checks.
- Suite runs + docs update + commit.

## Out of Scope

- Signed/published artifacts, store uploads, deploy (no user-owned identity).
- PDF-import smoke leg (`TRACE_SMOKE_PDF`): blocked on hardcoded pixel
  coordinates from an older layout; semantics path unavailable in release web
  build. Tracked as follow-up, not part of this proof.
- no-OPFS, multi-tab write, quota eviction claims (stay HOST UNVERIFIABLE).

## Assumptions

- Flutter 3.44.0 stable on this host; `--no-pub` uses locked deps.
- Chrome present at `C:\Program Files\Google\Chrome\Application\chrome.exe`.
