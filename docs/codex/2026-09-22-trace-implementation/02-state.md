# State

- Current status: `active`
- Last updated: 2026-09-25
- Owner: Hermes (single model)
- Provenance: stages 10-45 record-closed `done` on `master`; slices `98f14da` (20), `a434743` (21), outbox chain to `04ca2f7` (45); index clean `8e2af48`.

## Current State
Stages 1–45 record-closed `done` on `master` (`8e2af48` clean). Stage 20 shell (`98f14da`) and Stage 21 teaching renderer (`a434743`) are committed reskins over the earlier honest shell. Stages 22-30 are prior offline/deterministic/proof records. Stages 31-45 form the local-only outbox lifecycle chain, ending at `04ca2f7` health snapshot. Stage 46 truthful docs remain `done` as the release-gate doc record. Umbrella Trace implementation stays `active` because the full learning loop is NOT DONE: missing gates are `benchmarks/`, `test/e2e/`, `.github/workflows/ci.yml`, plus PDF render/Vision pilot, live AI route, sync/auth/Storage/RLS, background/device runtime, and release identity.

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
| 2026-09-23 | Stage 7 domain contracts remain partial | Source model has no Flutter/UI or provider dependency | `source_document_test.dart`; `domain-v1.json` |
| 2026-09-23 | Pin Drift Web to `sharedIndexedDb`; fail closed if unavailable | Auto-probe selected OPFS first and IndexedDB on reload, hiding newly written collection; live Chrome regression now passes | `local_connection_web.dart`; `tool/smoke_web_library.py` |
| 2026-09-23 | Keep `putEntry` and text-source insert outside batch transaction | Transactional batch path on Web did not durably flush single-entry write; SQLite one-row insert is atomic | Chrome RED→GREEN reload test; native tests |
| 2026-09-23 | Waive only imagegen-specific design mock gate; use code-native mocks plus app runtime | User requires own model only and instructed to solve/skip nonblocking problems without pauses | User directive; real Flutter widget + Chrome evidence |

## Blockers
- Android licenses incomplete; local SDK administrator must review/accept before release evidence. Debug build/install worked.
- Windows optional plugins: host MSVC lacks ATL; install documented `Microsoft.VisualStudio.Component.VC.ATL` only with appropriate system authority, or prove replacement adapters before feature integration. This does not block independent Stage 5 design.
- Imagegen-specific mock requirement waived under newer own-model-only and skip-nonblocking-problems instructions. HTML mock is not imagegen proof; real Flutter library UI is implemented, full lesson/RTL visual gate remains open.
- Supabase project, authorized gateway route/credentials, production identity, signing, PWA origin and PDFium redistribution notices/fidelity remain open gates for later stages; never invent them.

## Done
- Toolchain/Git and target matrix recorded; Flutter app scaffold and three packages created.
- Tests and analysis pass across packages and app; Web and Windows release builds and Android debug APK pass.
- Starter app rendered on Android emulator, Windows window and served Chrome headless; Windows window title `Trace`.
- User-selected icon source hash verified, platform assets installed and inspected. `StudyHub-Web` unchanged.
- Stage 3 dependency contract documented; fake repository → ViewModel ready/error tests and all package/app tests + analysis pass. Static import search found no direct storage/AI import in app or platform import in domain.
- Stage 4 candidate/license/platform matrix documented; independent core Windows, combined Web and Android scratch builds passed; combined Windows blocked on ATL and explicitly deferred.
- Stage 7 partial source contracts: `SourceDocument`, `SourcePage`, `PageVisionCacheKey`; 12 domain tests/analyzer and partial JSON Schema checks pass.
- Drift v3 local library and source-original repositories; v2→v3 migration preserves duplicate filenames as distinct revisions; strict UTF-8, SHA-256, 8 MiB TXT/Markdown limit, duplicate replay, failed-batch rollback, file reopen and v1→v3 migration tested.
- Flutter collection/source UI and real browser file picker; widget tests include narrow-screen back navigation. Chrome CDP tests exact collection and Markdown source bytes in IndexedDB before/after reload with and without COOP/COEP headers. Web/Windows/Android compile passes.

## Remaining
- PDF render and Vision-only extraction/caching, lesson AST renderer, chat/agent, review, annotations, sync, auth, full domain contracts/codegen, release pipeline. TXT/Markdown text is stored and hash-verified in a capped RAW SOURCE preview; no AI lesson renderer yet. Large binaries need dedicated content-addressed storage; text import intentionally limited to 8 MiB.
- PWA offline/install/update, optional ATL-bound Windows secure-storage/notification plugins, Android license acceptance, browser portability beyond Chrome, device runtime import on Android/Windows remain unverified. No Supabase/gateway project details exist yet.
