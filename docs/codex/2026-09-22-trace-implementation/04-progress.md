# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-22 22:53 | active | Git initialized, toolchain audited | `flutter doctor -v`; `git init` |
| 2026-09-22 | active | Repo moved/renamed to final `Trace`; user icon selected and compiled for targets | `docs/architecture/decision-log.md`; `tool/verify_icons.py` |
| 2026-09-22 | active | Stage 1–2 development baseline closed; packages/app tests/analyze and target builds pass | `tool/target-matrix.md`, `05-verification.md` |
| 2026-09-22 | active | Android 15 emulator install/render; Windows runner window; served Chrome headless render | `assets/android-stage2.png`, `assets/web-stage2.png`; Win32 visible title `Trace` |
| 2026-09-22 | active | Stage 3 repository→ViewModel seam implemented test-first; safe failed-read state; all package/app tests and analysis passed | `docs/architecture/layers.md`, `test/library_view_model_test.dart`, `05-verification.md` |
| 2026-09-23 | active | Stage 4 conditional discovery gate: scratch Android APK, Web bundle and separate core Windows EXE exist; combined Windows plugins blocked by missing ATL; runtime capability tests remain at feature gates | `docs/architecture/dependency-decisions.md`; scratch build artifacts and native error |
| 2026-09-23 | active | Stage 5: 24 raw recipes, two HTML mock directions, four Chrome screenshots; fixed 5px mobile overflow; provisional Evidence Atelier choice, no imagegen or Flutter runtime claim | `docs/design/opinion-ledger.md`, `docs/design/interaction-map.md`, `tool/capture_design_mocks.py`, screenshots |
| 2026-09-23 01:57 | active | Stage 7 second independent tracer: SourcePage rendered identity/status and PageVisionCacheKey structured identity; RED→GREEN, domain suite/analyzer and partial JSON Schema validation passed | `test/source_page_test.dart`, `test/page_vision_cache_key_test.dart`, `docs/contracts/domain-v1.json` |
| 2026-09-23 03:29 | active | Fixed local persistence: Drift v3, native reopen, v1 migration, hash-bound UTF-8 originals and idempotent import. Chrome exposed auto storage switch and single-row transaction durability issue; pinned Web storage and direct single-row insert; picker+reload passes. Implemented real Flutter library/source UI; narrow back-navigation test passes. | `packages/trace_data/`; `apps/trace_flutter/`; `tool/smoke_web_library.py`; `05-verification.md` |
| 2026-09-25 | active | Record-closed stages 10-45 `done` on `master` (`8e2af48` clean): Stage 20 shell `98f14da`, Stage 21 teaching `a434743`, Stages 22-30 prior records, Stages 31-45 local-only outbox chain ending `04ca2f7`, Stage 46 truthful release docs. Umbrella stays active; missing gates `benchmarks/`, `test/e2e/`, `.github/workflows/ci.yml` plus Vision/live-AI/sync/device/release remain. | `docs/codex/_index.md`; `git log --oneline`; `ls` gate check |
| 2026-09-23 | active | Added RAW SOURCE preview after hash-verified read; Persian RTL/ASCII display digits without mutating source. Corrupted DB bytes rejected by injected failure test. | `apps/trace_flutter/test/app_smoke_test.dart`; `packages/trace_data/test/text_import_test.dart` |
| 2026-09-23 | active | Concurrency RED exposed duplicate insert race; Drift v3 unique (library, filename, revision) and insert-ignore retry preserve concurrent replay and revised originals. v2→v3 migration assigned revisions to existing duplicate names without data loss. | `test/text_import_test.dart`, `test/source_migration_test.dart` |

## Done So Far
- Stage 1: environment/target baseline with Android license warning.
- Stage 2: monorepo starter builds and runs on three selected development targets; no product features claimed.
- Icon: exact user selection installed and source hash recorded.
- Stage 3: contract and fake-repository ViewModel smoke tests; real local adapter now added in follow-on slice.
- Stage 4: candidate matrix and isolated compile evidence recorded; conditional gate permits independent design, but not false native/runtime claims.
- Stage 5: two browser-rendered design directions remain mocks; real Flutter library/source UI now executed in widget tests and Chrome. Imagegen mock gate waived, not fulfilled.

- Typography tracer: bundled OFL Inter/Vazirmatn and display-only ASCII numeral mapping; `trace_design` and app tests/analyze plus Web/Windows/Android builds passed. Persian lesson/font coverage still open.
- Stage 7 partial source contracts remain; TXT/Markdown original-byte import and real Drift persistence now exist, but PDF/Vision/caches do not.

## Next
- Trace implementation NOT DONE: missing gates `benchmarks/`, `test/e2e/`, `.github/workflows/ci.yml` plus PDF immutable binary store/page render/authorized Vision pilot, live AI route, source lesson renderer, review/annotations, auth/private Supabase sync, PWA/device runtime, and release identity. Implement PDF immutable binary store, page rendering, and authorized Vision pilot without OCR; connect evidence cache only after real model capability is proven. Maintain user-only model constraint. Defer ATL-bound optional plugins until actually needed.
