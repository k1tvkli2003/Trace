# Handoff

## Outcome
Stages 1–2 development scaffolding verified on Android emulator, Windows runner and served Web build. Stage 3 domain repository contract and fake-repository ViewModel tracer pass. Stage 4 dependency discovery accepted conditionally with isolated Web/Android/core-Windows builds; optional Windows plugins need ATL or proven adapters before feature integration. Stage 5 now includes two browser-rendered HTML mock directions, 24 recipes and bounded responsive checks; Evidence Atelier is provisional. These mocks are not imagegen and not Flutter. No real library UI/storage yet. Full product remains unimplemented. Final Trace icon selected and installed; source unchanged.

Stage 7 independent tracer added: `SourceDocument` serializes validated source identity with a partial JSON Schema; no real import, source hashing, persistence or other domain entities yet.

## Changed Artifacts
- `apps/trace_flutter/`, `packages/trace_{domain,data,design}/` — initial monorepo.
- `assets/brand/trace-icon-selected.webp`, `tool/generate_icons.py`, `tool/verify_icons.py` — selected icon provenance and platform variants.
- `tool/target-matrix.md`, `docs/architecture/decision-log.md`, task record and local stage-2 screenshots.
- `docs/architecture/layers.md`, `packages/trace_domain/lib/src/contracts/library_repository.dart`, `apps/trace_flutter/lib/app/library_view_model.dart`, `test/library_view_model_test.dart` — Stage 3 seam.
- `docs/architecture/dependency-decisions.md` — Stage 4 scratch pins, license/target matrix, conditional decisions and deferred runtime gates.
- `docs/design/opinion-ledger.md`, `docs/design/interaction-map.md`, `docs/design/responsive-contract.md`, `docs/design/previews/{evidence-atelier,signal-console}*.{html,png}` and `tool/capture_design_mocks.py` — Stage 5 mock exploration and browser QA, not app UI.
- `packages/trace_domain/lib/src/models/source_document.dart`, `test/source_document_test.dart`, `docs/contracts/domain-v1.json` — partial Stage 7 contract and test-first source tracer.

## How To Continue
- Stage 5: evaluate two existing mock directions and own-model-only versus imagegen contract; browser screenshots are not imagegen. No broad Flutter visual implementation until gate resolved. Continue independent product/domain contracts. Keep Windows optional plugins behind adapters until ATL or substitute proven. Do not connect real provider or Supabase without user-owned project facts.
- Stage 7: extend canonical model entities one verified vertical slice at a time; complete schema/codegen alignment. `SourceDocument.fromJson` validates metadata only; compute and verify bytes' hash and resolve symlinks safely in the later import boundary.

## Done
- Stage 1/2 development gate, Stage 3 architecture tracer, Stage 4 conditional discovery gate, and icon installation; not release gate.

## Remaining
- Stage 5 imagegen/approval/runtime conversion gate; Stages 6–30 real UI, source ingestion, Vision, teaching, review, auth/sync, CI and end-to-end verification.
- Stage 7 remaining entities/schema/codegen; current tracer alone does not close Stage 7.
- Android SDK license, permanent identifiers, signing/publisher, PWA host and Supabase project/authorized gateway route still require owner decisions at their respective gates.

## Verification
- Four package/app test and analyze suites pass, including two Stage 3 fake-repository cases; Web/Windows/Android scaffold builds pass from Stage 2, not rebuilt after Stage 3 (no runtime entrypoint changed). Stage 4 scratch APK/Web and core Windows EXE existence rechecked; plugin runtime behavior not tested. Starter launch/render previously verified on each. See `05-verification.md` for strict limits.
- Source tracer: domain focused/full tests and analyzer passed; partial JSON Schema compiled, valid example passed, six invalid examples rejected. No app build needed for domain-only change; see `05-verification.md`.
