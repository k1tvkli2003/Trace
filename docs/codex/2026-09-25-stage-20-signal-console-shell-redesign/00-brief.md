# Stage 20 — Trace Signal Console shell redesign

- Task ID: `2026-09-25-stage-20-signal-console-shell-redesign`
- Status: `active`
- Created: 2026-09-25
- Language: English

## Request
User selected Signal Console as approved visual direction for Trace and authorized autonomous continuation. Improve it during implementation without pausing for routine confirmation.

## Success Criteria
- Trace Flutter shell visibly follows Signal Console: matte graphite navigation, warm-white reading stage, controlled amber/sea-glass status accents, precise worktree hierarchy.
- Existing truthful behavior remains: local sources, offline state, disabled AI send, source rail only when real context exists, no fake lessons or data.
- Responsive desktop/tablet/mobile behavior passes existing and new tests.
- RTL Persian content remains isolated and readable; displayed numbers remain ASCII.
- No raw HTML, OCR, provider call, credential exposure, or StudyHub-Web change.

## Context
Stage 19 contracts and Stage 17 planner safety are complete. Existing `ChatWorkspace` already has responsive navigation, source context, source rail, composer, and honest offline behavior. Signal Console is a visual system choice, not permission to invent backend state.

## In Scope
- Shared Trace design tokens and typography polish.
- ChatWorkspace shell visual redesign and honest state presentation.
- Focused widget tests, golden-style structural checks, analyze and available runtime verification.
- Durable work docs and commit.

## Out of Scope
- New ingestion/Vision/provider adapter.
- Supabase sync/auth/deployment.
- Raw HTML lesson rendering.
- Changes to `StudyHub-Web`.
- Production release identity or signing.

## Assumptions
- Approved reference: `docs/design/previews/workbench-10/05-signal-console-worktree.webp` and `06-signal-console-review-pocket.webp` as Mock Previews, not runtime proof.
- User-selected product name is `Trace`.
- Trace AI route remains 9Router MiMo 2.6 Flash through `oc/mimo-v2.6-flash-free` and `ocz/mimo-v2.6-flash-free`, round-robin, but no live adapter is enabled in this stage.
