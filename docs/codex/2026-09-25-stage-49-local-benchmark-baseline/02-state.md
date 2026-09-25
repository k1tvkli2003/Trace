# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
RED->GREEN complete locally. `benchmarks/run_local_baseline.py` (stdlib only, N=20) wrote `benchmarks/baseline-Keyvan-20260925.json`; contract `tool/test_benchmark_baseline_contract.py` passes 2/2. Medians on this host: manifest_read_json 0.0337 ms, sha256_pdf 0.0285 ms, sha256_markdown 0.0254 ms, pdf_byte_scan 0.0515 ms. Local-only baseline, never a budget or release claim.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Clock manifest/SHA-256/PDF-byte-scan only, N=20, stdlib | Smallest honest baseline over synthetic fixture; no Flutter/device/CI timing | plan scope |
| 2026-09-25 | Commit generated baseline JSON as evidence | Contract pins provenance + ranges; reproducible artifact | contract test |

## Blockers
- None

## Done
- RED contract failed 2/2 as expected (no baseline file)
- Runner + baseline artifact + GREEN 2/2

## Remaining
- None (committed `9890d47`)
