# Stage 30 vertical slice proof and release gate

- Task ID: `2026-09-25-stage-30-vertical-slice-proof-and-release-gate`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Continue Trace implementation through Stage 30. Build one offline, source-backed vertical-slice proof and establish release-gate evidence without claiming unverified Supabase, native, device, browser, or production behavior.

## Success Criteria
- One executable test proves: local text import -> source page/block/citation -> validated Persian Lesson AST artifact -> learner state -> deterministic due review -> cached replay -> highlight/note source backlink.
- Test is written and run RED before production changes, then GREEN.
- Lesson replay performs no AI/network call; source hash and citation remain verified.
- Stage30 docs record exact evidence and honest limitations.
- Missing release-gate surfaces are added only when required by the coherent slice; no fake CI, deployment, auth, or platform claims.

## Context
- Repository: `C:/Users/K1/Desktop/Projects/Trace`
- HEAD at start: `e18f516 feat: add platform capability contract and foreground resume`
- Stages 16-29 supply source normalization, lesson AST validation, cached review replay, annotations, deterministic review, and foreground-only platform contracts.
- `StudyHub-Web` remains reference-only and must not change.

## In Scope
- Offline vertical-slice integration test and the smallest missing wiring needed for it.
- Stage30 work docs, verification receipt, handoff, and index status.
- Release-gate inventory based on actual repository evidence.

## Out of Scope
- Supabase project/auth/deployment or production schema migration.
- Native background jobs, system notifications, device/browser E2E, AI live calls, OCR, or provider/model changes.
- Changes to `C:/Users/K1/Desktop/Projects/StudyHub-Web`.
- Fake CI/build/deployment evidence.

## Assumptions
- Existing repository APIs are the canonical contracts.
- Text fixture is accepted through direct Markdown/TXT parsing; PDF vision remains a separate unverified boundary.
- Current environment requires Flutter commands with `--no-pub` or `--offline` where dependency resolution would access Pub.
