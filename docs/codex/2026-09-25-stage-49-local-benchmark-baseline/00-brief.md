# Stage 49 local benchmark baseline

- Task ID: `2026-09-25-stage-49-local-benchmark-baseline`
- Status: `done`
- Created: 2026-09-25T23:41:06
- Language: en

## Request
Close the `Benchmarks: MISSING` row in `docs/qa/acceptance-matrix.md` by adding one clocked, host-local baseline over the original synthetic fixture — not a release perf budget or device claim.

## Success Criteria
- `benchmarks/` holds one small clocked runner plus a timestamped JSON baseline produced on this Windows host.
- `tool/test_benchmark_baseline_contract.py` (2 tests) passes locally: baseline file exists, is well-formed, and its provenance fields pin this host, fixture SHA-256, and measured ranges.
- Matrix row moves `MISSING` -> `SCAFFOLD (local-only baseline)`.

## Context
Repo root `C:/Users/K1/Desktop/Projects/Trace`, branch `master`. Offline local-first scope. Original synthetic fixture at `test/fixtures/synthetic/` (Stage48: one PDF page + Markdown twin + SHA-256 manifest). No `benchmarks/` directory exists yet. No OCR, no live AI, no device/browser claim.

## In Scope
- TDD RED contract for the baseline artifact.
- `benchmarks/run_local_baseline.py`: times manifest read + SHA-256 rehash + PDF page-count + text-length over the synthetic fixture, N=20 iterations, stdlib only.
- One generated `benchmarks/baseline-<host>-<date>.json` artifact with provenance (host, fixture hashes, timings, not-a-budget note).
- Contract test + docs + matrix row update.

## Out of Scope
- Flutter/Dart benchmarks, device or browser perf, CI timing, release budgets, p95/SLO claims.
- Any ingestion, Vision run, OCR, provider call, or `StudyHub-Web` touch.

## Assumptions
- This host clock is sufficient for a local-only baseline; results are machine-specific and not portable.
