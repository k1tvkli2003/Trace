# Stage 75 web pdf import smoke fix

- Task ID: `2026-09-27-stage-75-web-pdf-import-smoke-fix`
- Status: `ready-for-review`
- Created: 2026-09-27T04:20:00+03:30
- Language: en

## Request

Continue the standing Trace plan after Stage 74 closed: make the real Chrome web
smoke actually exercise PDF import, which Stage 74 explicitly recorded as not
proven because its fixed click coordinates were obsolete.

## Success Criteria

- Fresh headless Chrome creates a collection, opens the Sources panel through the
  real `Manage` control, opens the native file chooser through `Import PDF`, and
  stores the picked bytes.
- The imported original and the exact collection title both survive a Chrome
  reload, verified from the Drift IndexedDB stores.
- The Markdown import leg keeps passing.
- A repeatable regression test guards the ordering, coordinates, and cleanup.

## Context

`tool/smoke_web_library.py` is the only web runtime smoke. Stage 74 proved
collection persistence but recorded "Do not claim PDF import smoke here" because
the chooser never opened. The Sources panel is reached through the context-bar
`Manage` button (`chat_workspace.dart` -> `onOpenSources`), and collection
selection is in-memory UI state.

## In Scope

- `tool/smoke_web_library.py`
- `tool/test_smoke_web_library.py`
- this task folder and `docs/codex/_index.md`

## Out of Scope

- OCR, provider calls, API keys, Supabase/RLS, sync.
- Product schema, UI layout, or data migrations.
- Rebuilding web/APK/Windows artifacts (no product code changed).

## Assumptions

- The Stage 74 release build in `build/web` is the artifact under test.
- 768x480 is a sufficient headless viewport for this harness.
