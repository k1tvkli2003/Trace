# Verification

## Summary
- Result: passed (release builds + web persistence smoke on current HEAD)
- Last verified: 2026-09-27T03:10+03:30

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| Web release build | `flutter build web --release --no-pub` | passed | `√ Built build\web`, `WEB_EXIT=0` |
| APK release build | `flutter build apk --release --no-pub` | passed | `√ Built build\app\outputs\flutter-apk\app-release.apk (71.9MB)`, `APK_EXIT=0` |
| Windows release build | `flutter build windows --release --no-pub` | passed | `√ Built build\windows\x64\runner\Release\trace_flutter.exe`, `WIN_EXIT=0` |
| Web smoke persistence | `python tool/smoke_web_library.py` against COOP/COEP server on `127.0.0.1:8766` | passed | `STORAGE: {"hit":true,...} -> {"hit":true,...}` then `PASS: exact collection persisted in IndexedDB across Chrome reload`, `SMOKE_EXIT=0` |
| APK signature (debug lineage) | `apksigner verify --print-certs` | passed | V2 signer `CN=Android Debug`, SHA-256 `33c955a5...` |
| Tracked secret patterns | `git grep -nIE '(sk-...|AKIA...|PRIVATE KEY|AVALAI_API_KEY|OPENHUB)'` over apps/packages/services | passed | exit 1 (no matches) |
| Web bundle secret scan | substring check of `main.dart.js` + `flutter_bootstrap.js` | passed | all `False` |
| Kotlin session ignored | `git check-ignore -v .../kotlin-compiler-*.salive` | passed | matched `apps/trace_flutter/.gitignore:46:/android/.kotlin/` |
| Gateway suite | `python -m unittest discover -s services/ai_gateway -p 'test_*.py'` | passed | `Ran 65 tests OK` |
| Data suite | `dart test` in `packages/trace_data` | passed | `+160: All tests passed!` |
| Domain suite | `dart test` in `packages/trace_domain` | passed | `+114: All tests passed!` |
| App suite | `flutter test --no-pub` in `apps/trace_flutter` | passed | `+41: All tests passed!` |

## Artifact identities (sha256 prefix / bytes)
- `build/web/main.dart.js` `a816869446836b23` 2929928 (rebuild emitted fresh
  `index.html` 03:01; `main.dart.js` bytes are deterministic Dart compile of
  unchanged Dart sources since 2026-09-25 — hash equals prior build, no app
  Dart change landed in between, verified via `git log --since=2026-09-25 -- '*.dart'`)
- `build/web/index.html` `3011c55dbd62f38d` 1561
- `app-release.apk` `25b05e7cb2612dc7` 75443505
- `Release/data/app.so` `71d50c07754a13df` 7029648
- `Release/trace_flutter.exe` `76bedadfa0ae833e` 132608 (unchanged native runner;
  rebuilt `app.so` carries the Dart side)

## Not Run
- Store/publish signing, install-upgrade matrix (no user-owned release identity).
- `TRACE_SMOKE_PDF` chooser leg (obsolete fixed-coordinate tooling; follow-up).
- no-OPFS browser, private mode, quota eviction, multi-tab write.
- Real device smoke; emulator install.

## Known Issues
- APK identity remains `com.example.trace_flutter` debug-signed v0.1.0 —
  direct-install artifact only, not a store artifact.
- `flutter build web` keeps a content-identical `main.dart.js` (deterministic
  compile); timestamp on `index.html` marks the fresh build.
