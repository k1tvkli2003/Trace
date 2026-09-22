# Target matrix (development baseline)

Source: `flutter --version`, `flutter doctor -v`, native audit and actual builds/launch on Windows host, 2026-09-22. `VERIFIED` here is limited to **scaffold build and starter-app smoke**, never product parity or release readiness.

| Target | Development scaffold evidence | Product/release readiness | Remaining proof |
|---|---|---|---|
| Android | VERIFIED — `flutter build apk --debug`; APK installed with `adb` on Android 15 emulator; `com.example.trace_flutter/.MainActivity` launched; captured `Hello World!` screenshot | BLOCKED — learning features absent; development `com.example` ID; no signing lineage; Android licenses incomplete | Real learning flow, accepted SDK licenses, signed package/install/upgrade and physical device smoke |
| Windows | VERIFIED — Visual Studio Build Tools 2022 + SDK 10.0.26100.0; release runner built; process launched, visible window title `Trace` | BLOCKED — learning features absent; no publisher/distribution identity or installer | Real learning flow, package, install/upgrade and identity |
| Web | VERIFIED — `flutter build web`; served at `127.0.0.1`; Chrome headless screenshot shows `Hello World!`; manifest/icon fetched | BLOCKED — learning features absent; PWA install/offline/update/storage unverified; no hosting origin | Offline/reload/installation/storage/browser matrix, deployment and real learning flow |

Flutter 3.44.0 stable (revision `559ffa3f75`), Dart 3.12.0. App `version: 0.1.0+1` remains development-only. `flutter doctor -v` reports unaccepted Android SDK licenses. Builds passed despite warning; never interpret this as license acceptance. No iOS/macOS/Linux targets requested or claimed. Source reference `StudyHub-Web` was not changed.

Evidence: `docs/codex/2026-09-22-trace-implementation/assets/android-stage2.png`, `web-stage2.png`; Windows window enumerated via Win32; build output under `apps/trace_flutter/build/` (ignored, local only). CI and production identifiers remain pending.
