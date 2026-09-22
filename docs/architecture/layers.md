# Stage 3 — dependency and state ownership contract

Trace uses a small MVVM seam for the library. This document is an architecture contract, not a claim that ingestion, sync, or AI exists.

## Direction

```text
apps/trace_flutter: View → ViewModel → trace_domain contracts
                                      ↑
packages/trace_data: local repository implementation → trace_domain contracts
packages/trace_design: semantic renderer → trace_domain models
services/ai_gateway, services/ingestion_worker: separate server/worker runtimes
```

- `trace_domain` owns immutable value types, repository interfaces, rules, and typed tool contracts. No Flutter, SQL, platform, network, or provider dependency belongs here.
- `trace_data` depends on `trace_domain` and later owns Drift/local repositories and sync adapters. A repository is the state source; it never imports a ViewModel or another repository.
- `trace_flutter` owns View/ViewModel pairs. Views render state and call commands; ViewModels use domain contracts, not direct SQL, Supabase, raw HTTP, AI, or filesystem APIs. Composition root alone will inject concrete adapters when they exist. Platform capabilities require narrow adapters, not platform branching in Views.
- `trace_design` may depend on Flutter and domain semantic types. It cannot own persistence, scheduler, tool authorization, or extraction.
- `ai_gateway` validates/authorizes typed capability and tool calls server-side; no private model key in Flutter or public storage. Worker can produce versioned evidence but cannot silently mutate originals.

## Implemented seam

`LibraryRepository.listEntries()` returns immutable `LibraryEntrySummary` values. `LibraryViewModel.load()` owns library loading state and consumes only the repository interface. Test injects a fake repository; no database or network call is needed. This is a tracer bullet for layering, **not** a working library feature. Current main View remains the scaffold until design gate.

## State and failure boundaries

- The repository will be local-first once Stage 8 lands; failed remote sync must not erase local truth.
- ViewModel exposes `idle/loading/ready/failed`; no direct provider error text or raw book payload appears in UI state.
- File/Vision/storage work is not implemented. Future mutations need idempotency, local atomic writes and authorization; model output is data, not authority.

## Verification scope

`flutter test test/library_view_model_test.dart` proves fake repository → ViewModel state; `flutter analyze` checks types. Dependency manifests and source imports need manual inspection now; CI architecture lint and concrete data adapter remain later work. Nothing here proves persistence, sync, OCR-free ingestion, PWA storage, or real teaching.
