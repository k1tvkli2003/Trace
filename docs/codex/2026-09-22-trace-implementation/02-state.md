# State

- Current status: `active`
- Last updated: 2026-09-23
- Owner: Hermes (single model)

## Current State
Stages 1–3 closed with bounded evidence. Stage 4 dependency discovery conditionally accepted: isolated Web/Android and core Windows sample builds passed; optional Windows notification and secure-storage plugins fail on missing ATL headers and must use a verified remedy/adapter at feature integration. `Trace` is final product/repo name; icon installed. Flutter starter app still only shows `Hello World!`. Domain `LibraryRepository` and injected `LibraryViewModel` tested with fake repository; no persistence or real library UI. Stage 5 onward and all learning pipeline features remain.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-22 | `Trace` final; `com.example.trace_flutter` development-only | User named product; release owner/identity unknown | User instruction / Android build |
| 2026-09-22 | Android, Windows and Web/PWA only | User platform contract | User instruction |
| 2026-09-22 | Selected icon fixed by SHA-256, derived for all targets | User chose exact image | `assets/brand/trace-icon-selected.webp`, `tool/verify_icons.py` |
| 2026-09-22 | Non-icon UI direction chosen autonomously at Stage 5 | User delegated visual decisions | User instruction |
| 2026-09-22 | No subagent invocation | Exact requested skill unavailable; own-model-only preference must hold | Runtime skill inventory/user preference |
| 2026-09-22 | Domain owns `LibraryRepository`; app ViewModel consumes injected contract | One-way dependency and testability; no real storage adapter claimed | `docs/architecture/layers.md`; `library_view_model_test.dart` |
| 2026-09-23 | Select core Stage 4 candidates without adding to Trace; defer ATL-bound optional plugins | Isolated sample builds and plugin-specific Windows failure | `docs/architecture/dependency-decisions.md` |

## Blockers
- Android licenses incomplete; local SDK administrator must review/accept before release evidence. Debug build/install worked.
- Windows optional plugins: host MSVC lacks ATL; install documented `Microsoft.VisualStudio.Component.VC.ATL` only with appropriate system authority, or prove replacement adapters before feature integration. This does not block independent Stage 5 design.
- Supabase project, authorized gateway route/credentials, production identity, signing, PWA origin and PDFium redistribution notices/fidelity remain open gates for later stages; never invent them.

## Done
- Toolchain/Git and target matrix recorded; Flutter app scaffold and three packages created.
- Tests and analysis pass across packages and app; Web and Windows release builds and Android debug APK pass.
- Starter app rendered on Android emulator, Windows window and served Chrome headless; Windows window title `Trace`.
- User-selected icon source hash verified, platform assets installed and inspected. `StudyHub-Web` unchanged.
- Stage 3 dependency contract documented; fake repository → ViewModel ready/error tests and all package/app tests + analysis pass. Static import search found no direct storage/AI import in app or platform import in domain.
- Stage 4 candidate/license/platform matrix documented; independent core Windows, combined Web and Android scratch builds passed; combined Windows blocked on ATL and explicitly deferred.

## Remaining
- Stage 5–30 product work and integrated release gate. Stage 4 accepted only as dependency discovery/compile spike; Windows optional plugin and runtime capability proofs remain gated. Stage 3 only proves contract injection, not concrete persistence or real library UI.
- PWA offline/install/storage, auth/sync, Vision and Persian lesson flow not implemented or verified.
