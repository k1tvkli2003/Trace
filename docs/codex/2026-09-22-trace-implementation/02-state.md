# State

- Current status: `active`
- Last updated: 2026-09-22
- Owner: Hermes (single model)

## Current State
Stages 1–2 baseline/scaffold and Stage 3 architecture seam closed with bounded evidence. `Trace` is final product/repo name; icon selected and installed. Flutter starter app still only shows `Hello World!`. Domain `LibraryRepository` contract and injected `LibraryViewModel` are tested with fake repository; no persistence or real library UI yet. Stages 4–30 and all learning pipeline features remain.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-22 | `Trace` final; `com.example.trace_flutter` development-only | User named product; release owner/identity unknown | User instruction / Android build |
| 2026-09-22 | Android, Windows and Web/PWA only | User platform contract | User instruction |
| 2026-09-22 | Selected icon fixed by SHA-256, derived for all targets | User chose exact image | `assets/brand/trace-icon-selected.webp`, `tool/verify_icons.py` |
| 2026-09-22 | Non-icon UI direction chosen autonomously at Stage 5 | User delegated visual decisions | User instruction |
| 2026-09-22 | No subagent invocation | Exact requested skill unavailable; own-model-only preference must hold | Runtime skill inventory/user preference |
| 2026-09-22 | Domain owns `LibraryRepository`; app ViewModel consumes injected contract | One-way dependency and testability; no real storage adapter claimed | `docs/architecture/layers.md`; `library_view_model_test.dart` |

## Blockers
- Android licenses incomplete; local SDK administrator must review/accept before release evidence. Debug build/install worked.
- Supabase project, authorized gateway route/credentials, production identity, signing, PWA origin and PDF renderer/license remain open gates for later stages; never invent them.

## Done
- Toolchain/Git and target matrix recorded; Flutter app scaffold and three packages created.
- Tests and analysis pass across packages and app; Web and Windows release builds and Android debug APK pass.
- Starter app rendered on Android emulator, Windows window and served Chrome headless; Windows window title `Trace`.
- User-selected icon source hash verified, platform assets installed and inspected. `StudyHub-Web` unchanged.
- Stage 3 dependency contract documented; fake repository → ViewModel ready/error tests and all package/app tests + analysis pass. Static import search found no direct storage/AI import in app or platform import in domain.

## Remaining
- Stage 4 dependency/license spike; Stages 5–30 product work and integrated release gate. Stage 3 only proves contract injection, not concrete persistence or real library UI.
- PWA offline/install/storage, auth/sync, Vision and Persian lesson flow not implemented or verified.
