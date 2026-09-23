# Execution plan

## Approach
پلن اصلی ۳۰ مرحله ای مبنا است: [Trace plan](../../../.hermes/plans/2026-09-22_223024-trace-learning-agent.md). هر مرحله پس از test/runtime evidence بسته می شود. جهت Stage 5 با شواهد تصویری و بررسی خودکار انتخاب می‌شود؛ فقط آیکون به انتخاب کاربر نیاز داشت و انتخاب شده است.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 baseline | done | version/doctor/Git/target matrix; Android license warning explicit |
| 2 skeleton | done | Flutter app + three packages + analyze, tests, builds, Android/Windows/Web starter smoke |
| 3 architecture | done | domain repository contract; injected ViewModel; fake ready/error tests; dependency direction static review |
| 4 dependencies | conditional gate | core file-picker + Drift Web/Windows/Android integrated and exercised; optional ATL-bound plugins and PDF rendering/notifications not proved |
| 5–6 design | active | Evidence Atelier-informed real Flutter library and source list; HTML mocks still mock, imagegen-specific gate superseded by user own-model-only constraint, lesson/workbench UI not yet built |
| 7 domain | active | source contracts plus hash-bound original TXT/Markdown import and Drift v1→v3 and v2→v3 migrations exercised; other entities/codegen, PDF/Vision absent |
| 8–30 vertical slice and release QA | active partial | real library/import slice verified; remaining journey per main plan |

## Interfaces and Artifacts
`apps/trace_flutter`, `packages/trace_domain`, `packages/trace_data`, `packages/trace_design`, `services`, `supabase`, `docs`.

## Risks
Android SDK licenses; design approval; provider Vision capability and credentials; no release identity. Do not silently select substitute models or providers.

## Acceptance Checks
`flutter doctor -v`, generated folders limited to three targets, `flutter analyze`, package resolution, launch/build on supported host; every future gate requires its own tests.
