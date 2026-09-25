# Stage 21 Signal Console teaching stage

- Task ID: `2026-09-25-stage-21-signal-console-teaching-stage`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Continue the approved Signal Console direction into the teaching stage. The shell (Stage 20) is done; the lesson renderer still uses old light hardcoded colors and is not visually part of the console. Wire the existing typed Lesson AST renderer into Signal Console tokens without inventing lessons, AI output, or source readiness.

## Success Criteria
- `LessonDocumentView` renders validated Lesson AST on Signal Console graphite surfaces with warm text and readable citations.
- Offline preview page uses the shared dark console theme and keeps its honest "sample only / no source linked" banner.
- No raw HTML, no invented progress, no live AI call, no OCR.
- Widget tests prove dark surfaces, evidence honesty, RTL, and 200% text.

## Context
Monorepo `Trace`. Stage 20 closed the shell at `98f14da` with `TraceColors` + `TraceTheme.dark()`. `packages/trace_design/lib/src/lesson_document_view.dart` still uses light constants (`_ink 0xff18292d`, `_edge 0xffdbe5e0`, white blend). `TeachingPreviewPage` is a deliberate offline sample. Domain `LessonDocument` / `LessonBlock` contracts are frozen (Stage 18).

## In Scope
- Token-driven reskin of `LessonDocumentView` to Signal Console dark roles.
- `TeachingPreviewPage` dark theme alignment, banner honesty preserved.
- Widget tests: new Signal Console surface test (RED first) + existing evidence tests kept green.
- Task docs, verification, handoff.

## Out of Scope
- Live AI gateway adapter, route verification, Vision calls.
- PDF Vision/review flow, sync/auth, release identity, screenshot matrix.
- New lesson content, new block types, schema changes.

## Assumptions
- `TraceColors` / `TraceTheme.dark()` / `TraceRadius` / `TraceTypography` are the single source of truth.
- Sample lesson in preview page stays explicitly sample-only.
