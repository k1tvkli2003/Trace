# Handoff

## Outcome
Trace now has a bounded, **working** local-first library/import slice, not a completed learning product. Flutter Web, Windows, and Android builds pass. Chrome created a collection, imported Markdown through the real file picker, and proved exact SQLite page content survives reload. Native SQLite file reopen and v1→v3 and v2→v3 migrations preserve earlier collections, duplicate-name revisions, and source originals. No OCR, PDF transcription, provider call, or sync was claimed.

## Changed Artifacts
- `packages/trace_data/lib/src/local/{trace_database,local_library_repository,local_text_source_repository}.dart` plus generated Drift schema and tests: two tables, atomic one-row versioned source manifest+original, SHA-256, strict UTF-8, idempotent concurrent replay, native persistence and v1/v2→v3 migration.
- `apps/trace_flutter/lib/{main,local_connection*,text_picker}.dart`: English library UI, real collection creation and text import, narrow-screen return path, hash-verified RAW SOURCE preview with Persian RTL/ASCII display digits, safe errors, injected picker/DB for tests.
- `apps/trace_flutter/web/{sqlite3.wasm,drift_worker.js}`: matched Drift 2.35.0 release assets. SHA-256: WASM `13d3f11d05b39ba0618a7115fb41640a5d48b6300f5d3f325f554b42bd6688a4`; worker `df0066e75363a9bed59a14eedbbded421c1f5910f8379812df164716aa2e6eed`. Downloaded from `https://github.com/simolus3/drift/releases/tag/drift-2.35.0`; MIT notices are bundled in `web/THIRD_PARTY_NOTICES.txt`; broader release-license audit remains.
- `tool/smoke_web_library.py` and `tool/serve_web_with_coop.py`: real Chrome CDP persistence/picker checks; no test screenshots committed.
- Product/architecture/work docs record conditional design decision and remaining gates.

## How To Continue
- Execute Vision-only PDF ingestion next: content-addressed original binary, page renderer producing pixel hashes, authorized user-model pilot, then keyed evidence cache. Never accept PDF text layer as transcription or run OCR.
- Add source reader/lesson AST and Persian RTL UI, then review/annotations and private sync. Keep imagegen-specific design mock skipped, not falsely fulfilled. Optional ATL-bound Windows plugins remain deferred until their capability is needed.
- For Web smoke: build app, run `python tool/serve_web_with_coop.py` in repo root, then `TRACE_SMOKE_IMPORT=1 python tool/smoke_web_library.py` in another terminal. Chrome-only; test more browsers and PWA offline separately.

## Done
- Drift v3 source/library slice, real Flutter UI, native migration/reopen, Web storage pin and actual browser import/reload.

## Remaining
- Full domain/schema/codegen; PDF/Vision/cache, source lesson renderer, agent, review, notes, auth/private Supabase sync, PWA/install/offline, production identity/signing and device-level app/runtime parity. TXT/Markdown importer currently limits each file to 8 MiB; large books need streaming/content-addressed binary store.

## Verification
- `dart test && dart analyze` in data/domain, `flutter analyze && flutter test`, Web/Windows/APK builds; Chrome CDP both with and without COOP/COEP. See `05-verification.md`. Stage 5 code-native previews not imagegen; no user model switched.
