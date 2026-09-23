# Architecture decisions

| Date | Decision | Reason | Status |
|---|---|---|---|
| 2026-09-22 | Product and repo name `Trace`; development slug `trace` | User selected final name; signing/publisher still unassigned | Accepted |
| 2026-09-22 | Flutter 3.44.0 stable, Dart 3.12.0 on this host | Verified via `flutter --version`; CI pin pending | Development baseline |
| 2026-09-22 | Only Android, Windows and Web platform folders | Explicit product scope | Accepted |
| 2026-09-22 | MVVM; domain contracts owned by `trace_domain`, implemented by `trace_data`, consumed by Flutter ViewModels; Views never call storage/AI directly | Flutter architecture guide and fake-repository tracer test | Stage 3 seam implemented; concrete persistence pending |
| 2026-09-22 | UI direction autonomously chosen with preview/runtime QA; final app icon selected | User delegated other design decisions | Accepted |
| 2026-09-22 | Selected icon is `assets/brand/trace-icon-selected.webp` (SHA-256 `08e7164d43c3b37f4622f8c001f24eb555c20334ea252153be93fb775232c942`); Android, Windows and Web variants generated from this unchanged source by `tool/generate_icons.py` | User supplied and selected exact image; no further image generation required | Accepted |
| 2026-09-22 | English-only product chrome; Persian chat and lesson content with RTL islands | Explicit language contract | Accepted |
| 2026-09-22 | Local-first Drift plus mandatory private Supabase Auth/Postgres/Storage and RLS | User's cross-device sync requirement | Accepted |
| 2026-09-22 | No OCR; PDF transcription via page-image Vision only; no client-held provider key | User constraints | Accepted |
| 2026-09-22 | StudyHub-Web remains untouched | Separate user project, reference only | Accepted |
| 2026-09-22 | No alternative worker/model selected | User-only model preference; exact subagent-driven-development skill unavailable | Current execution constraint |
| 2026-09-23 | Stage 4 candidate set selected; defer optional ATL-bound Windows plugins behind adapters | Isolated spike passed Web/Android/core-Windows builds; combined Windows plugins fail missing ATL; runtime storage/render/notification not yet proved | Conditional discovery gate; see `dependency-decisions.md` |
| 2026-09-23 | Stage 5 provisional Evidence Atelier direction, NOT approved Flutter UI | 24 raw recipes and two code-native/browser-rendered mocks; own-model-only restriction blocks the plan's different-model imagegen requirement; no PDF or medical source used | `docs/design/opinion-ledger.md`; `docs/design/interaction-map.md` |
| 2026-09-23 | Typography: Inter English, Vazirmatn Persian, visible digits ASCII `0-9` | User clarified modern minimal English font, not exact Codex reproduction; OFL assets bundled; display normalization leaves source bytes untouched | `packages/trace_design/`; `docs/design/responsive-contract.md` |
| 2026-09-23 | Drift v3 stores collection entries and ≤8 MiB UTF-8 TXT/Markdown originals + hash-bound versioned manifests; file picker is UI only | First real local-first slice. Original bytes immutable on duplicate replay; foreign key, SHA-256 verification on read; future PDF binary/rendered-page store separate | Native reopen/migration and Chrome picker/reload tests |
| 2026-09-23 | Web storage pinned `sharedIndexedDb`, fails closed otherwise | Drift auto-probe switched OPFS→IndexedDB on reload, hiding written record; fixed storage identity. Not yet cross-browser or PWA proof | Chrome RED→GREEN `tool/smoke_web_library.py` |
| 2026-09-23 | Imagegen-specific Stage 5 preview gate bypassed; code-native mocks explicitly labeled; real Flutter library/source UI now exercised | Later user-directed own-model-only restriction and skip nonblocking gates; do not substitute another image model or claim imagegen proof | User directive, widget + Chrome runtime checks |

Development-only generated `com.example` IDs must not be treated as release identifiers. No Supabase project, production credentials, or authorized gateway endpoint has been selected.
