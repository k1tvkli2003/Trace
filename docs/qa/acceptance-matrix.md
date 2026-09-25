# Acceptance matrix (Stage30 vertical slice)

Scope: offline local-first vertical-slice proof only. Every `passed` below traces to the recorded Stage30 verification run (`docs/codex/2026-09-25-stage-30-vertical-slice-proof-and-release-gate/05-verification.md`). Anything without such a run is marked `NOT VERIFIED` or `MISSING` with its reason. No CI, benchmark, E2E, device, browser, deploy, or live-AI claim is made here.

## Offline learning loop (verified local)

| Check | Result | Evidence |
|---|---|---|
| Local text import -> source page/block/citation | passed | Stage30 verification: targeted slice `dart test test/offline_vertical_slice_test.dart` from `packages/trace_data`, `TERMINAL_EXIT=0`; wrong-ID mutation failed with `TERMINAL_EXIT=1`, then restored |
| Validated Persian Lesson AST artifact | passed | Same targeted slice run; no production files changed (RED required no new wiring) |
| Learner state + deterministic due review + cached replay (no AI/network on replay) | passed | Same targeted slice run |
| Highlight/note source backlink | passed | Same targeted slice run |
| Full data suite | passed | Stage30 verification: `dart test` from `packages/trace_data`, `TERMINAL_EXIT=0` |
| Full domain suite | passed | Stage30 verification: `dart test` from `packages/trace_domain`, `TERMINAL_EXIT=0` |
| Gateway suite (offline routing) | passed | Stage63 verification: `python -m unittest discover -s services/ai_gateway -p 'test_*.py'`, 58 tests OK (was 50 at Stage30; Stage51 added the figure-ownership rejection case, Stage53 added the single-owner rejection case, Stage55 split the ownership error into three codes and added the lonely-block case, Stage57 added the textless figure-block rejection case, Stage59 added the low-confidence figure rejection case, Stage61 added the certain-empty-text rejection case, Stage63 added the boolean order/confidence and boolean figure-confidence rejection cases) |
| App tests | passed | Stage30 verification: `flutter test --no-pub` from `apps/trace_flutter`, `TERMINAL_EXIT=0` |
| App analyzer | passed | Stage30 verification: `flutter analyze --no-pub` from `apps/trace_flutter`, no issues found |
| Data analyzer | passed | Stage30 verification: `dart analyze` from `packages/trace_data`, no issues found |
| Targeted format check | passed | Stage30 verification: `dart format --output=none --set-exit-if-changed test/offline_vertical_slice_test.dart`, 0 changed |
| Task docs structure | passed | Stage30 verification: `validate_task_docs.py ... --structure-only`, OK |
| Working tree | passed | Stage30 verification: `git diff --check`, clean |

## Explicitly not verified (no claim)

| Surface | Status | Reason |
|---|---|---|
| Android/Windows/Web release builds | NOT VERIFIED | Stage30 `Not Run`: no release builds in the verification run |
| Browser persistence and multi-tab behavior | NOT VERIFIED | Stage30 `Not Run` |
| Device/emulator smoke | NOT VERIFIED | Stage30 `Not Run` |
| Supabase / auth / RLS / storage | NOT VERIFIED | Stage30 `Not Run`; no Supabase project exists in this slice |
| Live AI Vision / cost pilot | NOT VERIFIED | Stage30 `Not Run`; Vision compatibility and cost of the personal route remain unproven |
| PDF renderer / license spike beyond scaffold | NOT VERIFIED | Stage30 `Not Run` |
| CI workflow | SCAFFOLD (unrun) | `.github/workflows/ci.yml` exists as CI-only intent (Stage47 `fcbecdd`); no pipeline has ever run — local-only validation |
| Benchmarks | SCAFFOLD (local-only baseline) | `benchmarks/run_local_baseline.py` + `baseline-Keyvan-20260925.json` clock manifest/SHA-256/PDF-byte-scan on this host (N=20, medians 0.025-0.052 ms); machine-specific, never a release budget |
| E2E (device/browser) | SCAFFOLD (unrun) | `test/e2e/README.md` lists the §18 flows as `NOT RUN` (Stage50); no device, browser, Playwright, or Flutter integration run |
| Test fixtures beyond placeholder | SCAFFOLD | `test/fixtures/synthetic/` holds one original PDF, Markdown twin, and SHA-256 manifest (Stage48); no ingestion or Vision run |

## Baseline references (not release proof)

- `tool/target-matrix.md` (2026-09-22): scaffold build + starter-app smoke only; all three targets `BLOCKED` for product/release readiness. Must not be read as release evidence.
- App `dart format` drift noted in Stage30 known issues: unrelated pre-existing PDF files under the installed Dart SDK; reverted and left unchanged.
- `StudyHub-Web` is reference-only and untouched.
