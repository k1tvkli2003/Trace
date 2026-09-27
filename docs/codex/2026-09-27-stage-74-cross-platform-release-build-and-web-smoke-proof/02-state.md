# State

- Current status: `done`
- Last updated: 2026-09-27T03:10:00+03:30
- Owner: Codex

## Current State

Stage 74 is closed in commit `101b051`. Fresh web, APK, and Windows builds
passed on HEAD `58fe085`. Real Chrome smoke persisted the exact collection
across reload. This is local build proof, not a production release.

## Decisions

| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-27 | Keep web storage pinned to `sharedIndexedDb` | Prevent silent empty library/backend drift | `local_connection_web.dart`, matrix |
| 2026-09-27 | Retry smoke click only inside bounded test tool | WASM DB open delays first frame; product behavior unchanged | `tool/smoke_web_library.py` |
| 2026-09-27 | Do not claim PDF import smoke here | Existing leg uses obsolete fixed coordinates; semantics enable unavailable in headless release build | live Chrome probes |

## Blockers

- None for this stage. PDF chooser, device install, and production signing are
  separate follow-ups, not concealed release claims.

## Done

- Web served with COOP/COEP and `application/wasm`.
- Collection persisted in IndexedDB before and after reload.
- Gateway 65/65, data 160, domain 114, app 41 passed.
- Secret pattern checks clean; `.kotlin` compiler session ignored.
- Fresh three-target builds, smoke, validation and commit `101b051`.

## Remaining

- None within Stage 74. Device, PDF chooser, AI and sync proofs remain in the
  product backlog; see `06-handoff.md`.
