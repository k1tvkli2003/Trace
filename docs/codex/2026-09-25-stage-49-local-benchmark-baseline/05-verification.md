# Verification

## Summary
- Result: passed (local-only baseline; no release/perf-budget claim)
- Last verified: 2026-09-25

## Checks
| Check | Command/Method | Result | Evidence |
|---|---|---|---|
| RED contract fails without baseline | `python -m unittest tool.test_benchmark_baseline_contract -v` | passed (failed 2/2 as expected) | missing `benchmarks/baseline-*.json` assertion |
| Runner writes baseline | `python benchmarks/run_local_baseline.py` | passed | `benchmarks/baseline-Keyvan-20260925.json`, medians 0.025-0.052 ms, N=20 |
| GREEN contract | `python -m unittest tool.test_benchmark_baseline_contract -v` | passed | 2/2 OK |

## Not Run
- Flutter/Dart benchmarks, device/browser perf, CI timing, release builds — out of scope for this baseline.

## Known Issues
- Timings are host-clock-specific (Keyvan, Windows) and not portable; recorded as min/median/max, never a budget.
