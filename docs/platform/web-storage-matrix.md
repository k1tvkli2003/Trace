# Web storage matrix (Stage 9)

Date: 2026-09-24. Host: Windows. Flutter 3.44.0 / Dart 3.12.0. Drift 2.35.0.

Storage identity: database name `trace_local_v1`, pinned backend
`sharedIndexedDb` (`apps/trace_flutter/lib/local_connection_web.dart`).
The web connection probes for `sharedIndexedDb` and fails closed with
`StateError` when the browser cannot provide it — no silent fallback to a
different backend, no silent empty library.

## Results

| Check | Result | Evidence |
|---|---|---|
| Persistence after reload | VERIFIED | `probe_stage9_facts.py`: `trace_local_v1`, IndexedDB hit before and after reload; `tool/smoke_web_library.py` PASS |
| Behavior with no OPFS | CONFIGURED—HOST UNVERIFIABLE | Chrome probe reports OPFS available; code pins `sharedIndexedDb`, but no-OPFS browser profile was not available on this host |
| Single-tab guard | CONFIGURED—HOST UNVERIFIABLE | SharedWorker is present; no dedicated lock/contention test run yet |
| Stale storage recovery | CONFIGURED—HOST UNVERIFIABLE | Existing OPFS migration path is not exercised; code fails closed instead of silently opening another backend |
| Multi-tab write | NOT CLAIMED | no concurrent multi-tab write test; Drift docs warn unsafe IndexedDB can race |

## Notes

- Multi-tab write claim requires dedicated evidence; until then it stays
  NOT CLAIMED.
- COOP/COEP headers served by `tool/serve_web_with_coop.py` (`same-origin` /
  `require-corp`); `sqlite3.wasm` served as `application/wasm`.
- Prior Chrome RED→GREEN note in `docs/architecture/decision-log.md`
  (sharedIndexedDb pin) is superseded by this matrix once the run below passes.

## Verified run evidence

- Build: `flutter build web --release --no-pub` — PASS.
- Headers: `Cross-Origin-Opener-Policy: same-origin`;
  `Cross-Origin-Embedder-Policy: require-corp` — PASS.
- WASM: `sqlite3.wasm` served as `application/wasm` — PASS.
- Chrome probe: `crossOriginIsolated=true`, `SharedWorker=function`,
  `indexedDB=object`, `navigator.storage.getDirectory=true`.
- IndexedDB inventory before/after: `trace_local_v1`. Stored collection probe
  returned `hit:true` before reload and after reload. Object stores observed:
  `blocks`, `files`.
- `tool/smoke_web_library.py` — PASS: exact collection persisted in
  IndexedDB across Chrome reload.

The evidence proves this host's Chrome release path with COOP/COEP and the
pinned IndexedDB backend. It does not prove no-OPFS browser behavior,
private-mode behavior, quota eviction recovery, or multi-tab write safety.
