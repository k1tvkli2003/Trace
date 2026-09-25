# Stage 59 figure low confidence rejected

- Task ID: `2026-09-26-stage-59-figure-low-confidence-rejected`
- Status: `done`
- Created: 2026-09-26
- Language: en

## Request
Blocks reject transcription below 0.5 unless quarantined as `unknown`. Figures accept any confidence, including 0.0. Close that gap: a figure below the same floor fails closed.

## Scope
- New fail-closed check inside figure loop, after confidence shape check.
- New rejection test: `fig-1` confidence 0.0 rejected.
- Happy fixture confidence 0.7 stays green.

## Non-Goals
- No figure uncertainty/quarantine encoding (contract has no figure `uncertain` field).
- No contract schema change.
- No threshold tuning; reuse existing `0.5` floor.

## Acceptance
- New test fails before fix, passes after.
- Page-extract + gateway suites green.
- Task docs validate; `git diff --check` clean; low-confidence figure rejected with explicit code.
