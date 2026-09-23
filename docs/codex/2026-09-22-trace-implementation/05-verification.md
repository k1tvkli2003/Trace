# Verification

## Summary
- Result: partial
- Scope: Stage 1–3 baseline and bounded real Drift/library/TXT/Markdown import slice PASS. Full Trace learning product NOT DONE.
- Last verified: 2026-09-23

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| Host and toolchain | `flutter --version`, `flutter doctor -v`, native audit | passed with warning | Flutter 3.44.0/Dart 3.12.0; Android SDK licenses unaccepted |
| Package/app quality | `dart test && dart analyze` for domain/data; `flutter test && flutter analyze` for design/app | passed | all four suites passed, no analyze issues |
| Stage 3 seam | `flutter test test/library_view_model_test.dart` | passed | fake repository ready and safe failed-read tests; initial RED was missing contract/ViewModel, second RED missing `errorMessage` |
| Dependency direction | package manifests and targeted import search | passed | domain exports repository contract; data/design/app depend on domain; zero direct storage/AI import matches in Flutter `lib`, zero Flutter/data imports in domain `lib`. This is static/manual only. |
| Three builds | `flutter build web && flutter build windows && flutter build apk --debug` | passed | `build/web`, `build/windows/x64/runner/Release/trace_flutter.exe`, `build/app/outputs/flutter-apk/app-debug.apk` |
| Android launch | `adb install -r`, `am start`, screenshot | passed | installed on Android 15 emulator; actual starter image `assets/android-stage2.png` |
| Windows launch | start built EXE, Win32 EnumWindows | passed | visible window title `Trace`; process terminated after check |
| Web render | serve build, Chrome headless screenshot | passed | actual starter image `assets/web-stage2.png`; server stopped |
| Icon lineage | `python tool/verify_icons.py`, APK/EXE resource inspection | passed | source hash; APK xxxhdpi equals generated PNG; EXE group icon resource has 7 sizes; web icon matches build |
| Stage 4 scratch package resolution/analyze/test | `flutter pub add` exact pins, `flutter analyze`, `flutter test` in `trace_dependency_spike` | passed earlier; not production tests | `docs/architecture/dependency-decisions.md` |
| Stage 4 isolated builds | `flutter build web`, `flutter build apk --debug` with Android desugaring, separate core `flutter build windows` | passed compile only | On-disk scratch `index.html` 1,578 bytes, APK 186,282,059 bytes, core EXE 91,648 bytes; verified 2026-09-23. Web PDFium WASM 5,231,809 bytes. |
| Stage 4 full Windows plugin set | `flutter build windows` in `trace_dependency_spike` | blocked on host | Missing `atlbase.h`/`atlstr.h` from Build Tools ATL component; not a core Windows failure |
| Stage 5 browser design mock | `python tool/capture_design_mocks.py` | passed bounded mock checks | Isolated Chrome CDP captured 4 desktop/phone PNGs; checked icon, Persian RTL, bundled Inter/Vazirmatn load, ASCII numerals, overflow at 320/375/768/1440, mobile drawer open/close. Not imagegen nor Flutter proof. |
| Typography tracer | `flutter test && flutter analyze` in `trace_design` and app; `flutter build web`, `flutter build windows`, `flutter build apk --debug` in app | passed bounded slice | Two OFL font assets bundled; display-digit mapping and Persian RTL widget tested; Inter app theme test; Web FontManifest has both fonts; platform builds pass. No PDF/lesson renderer exists yet. |
| Stage 7 source tracer | `dart format lib test/source_document_test.dart && dart test test/source_document_test.dart && dart test && dart analyze` in `trace_domain` | passed | 5 SourceDocument behavior tests; 6 total domain tests; no analyzer issues. RED observed for missing type, malformed SHA-256, traversal path, invalid metadata. |
| Partial canonical schema | `jsonschema.Draft202012Validator.check_schema` and sample validation of `docs/contracts/domain-v1.json` | passed partial | SourceDocument previously: valid example accepted and 6 invalid cases rejected. SourcePage and PageVisionCacheKey: valid examples accepted, invalid page number/hash rejected. Schema not complete/code-generated. |
| Stage 7 page/cache key tracers | `dart format lib test && dart test && dart analyze` in `trace_domain` | passed | 12 domain tests, no analyzer issues; RED observed for missing types and invalid page metadata. Key varies on each extraction input and uses structured JSON encoding to avoid delimiter collision. |
| Drift v3 native data | `dart test && dart analyze` in `trace_data` | passed | Collection create/replay/rollback, real SQLite file reopen, TXT original hash/idempotent concurrent replay, immutable revised originals and corruption injection, invalid UTF-8/path/PDF rejection, v1→v3 and v2→v3 migrations preserving prior collection, duplicate-name versions and bytes. |
| App behavior | `flutter analyze && flutter test` in app | passed | Real SQLite collection create/list; injected text picker imports and lists source; 375px navigation back; hash-verified RAW SOURCE preview displays Persian digits as ASCII; ViewModel baseline tests. |
| Web storage/browser picker | `python tool/smoke_web_library.py`, `TRACE_SMOKE_IMPORT=1 python tool/smoke_web_library.py` on local COOP/COEP server, plus baseline non-COOP port | passed in headless Chrome | CDP created a collection, opened actual file chooser, loaded Markdown bytes; exact SQLite page content persisted to IndexedDB before/after reload; pin `sharedIndexedDb` and direct single-row write fixed RED reload loss. Chrome only, not PWA offline proof. |
| Production target builds | `flutter build web && flutter build windows && flutter build apk --debug` after real Drift/file-picker integration | passed | Web build, Windows release EXE, Android debug APK; optional ATL-bound secure storage/notification plugins still absent. |
| Work-doc structure | `validate_task_docs.py` | passed | `OK` 2026-09-23 |

## Not Run
- PWA offline/install/update/browser portability and deployment; live Chrome persistence is verified but not an offline-install proof.
- Production signing/install upgrades and full learning workflows; absent implementation and user-owned release facts.
- Real Chrome CDP smoke ran via `tool/smoke_web_library.py` rather than Browser Use CLI; widget build alone not used as proof.
- PDF render fidelity, Vision-only extraction, secure-storage session, notifications, cross-browser/mobile runtime picker and PWA offline/install/update not exercised. Core Web Drift/file picker runtime now passed Chrome.
- Stage 5 HTML visual previews remain mocks; imagegen-specific gate waived under later user direction, not fulfilled. No 200% text/screen-reader, Persian lesson Flutter UI or native visual parity audit yet.
- Stage 7 remaining entities, PDF page rendering, Vision extraction, cache persistence/hit-miss, filesystem symlink containment and cross-language generated types not implemented/tested. TXT/Markdown hashing, Drift persistence and v1→v3 migration are implemented/tested.

## Known Issues
- Android licenses incomplete; development `com.example.trace_flutter` must never ship as release ID.
- First Flutter library/source UI is functional, but import has an 8 MiB TXT/Markdown limit; PDF/Vision, teaching and sync are not yet implemented.
- Windows full optional-plugin combination needs ATL headers or proved replacement; independent core Windows build passes. Do not treat Stage 4 conditional discovery acceptance as complete feature parity.
