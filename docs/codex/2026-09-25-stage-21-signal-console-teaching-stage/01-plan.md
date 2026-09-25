# Plan

## Approach
Token-driven reskin only. Keep `LessonDocumentView` API and honesty contracts identical; replace hardcoded light colors with Signal Console dark roles (`TraceColors.panel/canvas/edge/onCanvas/muted/accent/seaGlass`, `TraceRadius.panel`). Align `TeachingPreviewPage` scaffold/banner with `TraceTheme.dark()`. TDD: add one failing widget test for dark console surfaces first, then implement, then run full gates.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Fill task docs (brief/plan/state/previews/progress) |
| 2 | planned | RED: widget test asserting Signal Console surfaces on lesson blocks |
| 3 | planned | GREEN: reskin `LessonDocumentView` to tokens; align preview page theme |
| 4 | planned | Run design + app suites, analyze, web build; record evidence |
| 5 | planned | Update state/progress/verification/handoff/_index.md; validate docs; commit |

## Interfaces and Artifacts
- `packages/trace_design/lib/src/lesson_document_view.dart`
- `packages/trace_design/test/lesson_document_view_test.dart`
- `apps/trace_flutter/lib/teaching_preview_page.dart`
- `packages/trace_design/lib/src/tokens.dart` (read-only reference)
- `docs/codex/2026-09-25-stage-21-signal-console-teaching-stage/`

## Risks
- Contrast loss on dark surfaces: verify muted/label text against canvas/panel; keep citation buttons readable.
- Scope creep into live AI/Vision: blocked; preview stays sample-only with banner.
- Persian RTL/200% text regressions: covered by existing narrow-viewport test; keep green.

## Acceptance Checks
- New test `Signal Console lesson blocks render on graphite with warm ink` fails before, passes after.
- `flutter test --no-pub` passes in `packages/trace_design` and `apps/trace_flutter`.
- `flutter analyze --no-pub` passes; `flutter build web --no-pub` succeeds.
- `validate_task_docs.py --structure-only` passes; docs status synchronized.
