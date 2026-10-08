# Trace

Trace is a personal, local-first learning agent for long books. The goal is a Flutter app on Android, Windows, and Web/PWA that ingests book-length material and supports sustained study over it.

No OCR, no raw LLM HTML, no client-side API secrets, no direct AI-to-database writes: the model route belongs behind a server gateway. No production deployment is configured.

## What's inside

- `apps/trace_flutter` — Flutter app shell (early scaffold, version 0.1.0+1).
- `packages/trace_domain` — plain Dart contracts; no Flutter, network, or DB imports.
- `packages/trace_data` — local/remote repositories; depends on domain.
- `packages/trace_design` — Flutter semantic presentation; depends on domain.
- `services/ai_gateway` — server-side model route.
- `services/ingestion_worker` — book ingestion service.
- `supabase/` — migrations and notes for future durable storage.
- `api/trace-ai-run.py` — local AI run helper.
- `docs/` — architecture, decision log, contracts, platform notes, QA.
- `tool/` — target matrix, icon generation, smoke/contract test scripts.
- `benchmarks/` — local baseline runner and fixture.

Dependency direction is enforced: domain at the bottom, data and design above it, app composition on top.

## Tech stack

Flutter 3.44.0 stable / Dart 3.12.0 (development baseline), Supabase (planned), Python helpers, Vercel config present but unused for production.

## Getting started

Nothing product-facing runs yet. Scaffold builds are verified on all three targets: `flutter build apk --debug` (installed and launched on an Android 15 emulator), a Windows release runner showing the `Trace` window, and `flutter build web` served locally with a Chrome headless smoke screenshot. These prove the scaffold only — no learning flow exists. Android SDK licenses are unaccepted and the application ID is still the `com.example` placeholder, so signing and release identity remain open work.

## Status

In progress, early. Planning, contracts, package skeleton, and scaffold builds exist; the learning pipeline itself has not shipped.
