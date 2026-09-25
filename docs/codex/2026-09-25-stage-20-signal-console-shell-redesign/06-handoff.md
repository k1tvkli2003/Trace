# Handoff

## Outcome

Stage 20 Signal Console shell slice implemented. Trace now uses graphite console surfaces, warm text, amber selection markers, sea-glass local/source status, responsive navigation drawer, truthful worktree list, source inspector rail, and offline AI state.

## Changed Artifacts

- `packages/trace_design/lib/src/tokens.dart`
- `packages/trace_design/test/quiet_index_tokens_test.dart`
- `apps/trace_flutter/lib/chat_workspace.dart`
- `apps/trace_flutter/lib/main.dart`
- `apps/trace_flutter/test/chat_shell_test.dart`
- `docs/design/previews/workbench-10/decision.md`
- `docs/design/previews/workbench-10/SELECT-ONE.md`
- `docs/codex/2026-09-25-stage-20-signal-console-shell-redesign/`

## How To Continue

1. Build visual screenshot matrix: mobile 375, narrow 320 at 200% text, tablet 834, desktop 1280/1440, selected/empty/source states.
2. Compare runtime captures against approved 05/06 Mock Previews; keep mismatch ledger.
3. Implement source-backed teaching stage renderer using existing typed Lesson AST; no raw HTML.
4. Add live server-only 9Router adapter only after route ID/provider/Vision compatibility evidence; keep `oc/mimo-v2.6-flash-free` and `ocz/mimo-v2.6-flash-free`, round-robin, no fallback.

## Done

- Signal Console approved decision recorded.
- Shared dark tokens and theme added.
- Chat shell reskinned without inventing progress, due counts, AI replies, or fake source readiness.
- Main app uses dark Signal Console theme.
- Responsive and source-flow tests remain green.
- Web build and Flutter analyze pass.

## Remaining

- Screenshot-based visual QA.
- Android/Windows/PWA runtime proof.
- Live AI gateway adapter and route verification.
- PDF Vision/review/lesson path.
- Sync, auth, release identity and packaging.

## Verification

35 Flutter tests pass, `flutter analyze --no-pub` passes, `flutter build web --no-pub` succeeds. Chrome integration is unavailable in installed Flutter (`Web devices are not supported for integration tests yet`). No release or live AI claim made.
