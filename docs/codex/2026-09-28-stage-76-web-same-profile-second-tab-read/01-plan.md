# Plan

## Approach

Prove only read-only same-profile tab reading with real Chrome. Keep product code untouched and selection outside the claim. Failure must be loud.

## Steps

| Step | Status | Notes |
|---|---|---|
| 1 | done | Read Web connection, smoke harness, matrix status |
| 2 | done | Add optional tab-2 read probe after reload proof |
| 3 | done | Run PDF+multi-tab real Chrome proof and preserve screenshot/log |
| 4 | done | Update docs/matrix and commit bounded slice |

## Interfaces and Artifacts

- `tool/smoke_web_library.py`
- `tool/test_smoke_web_library.py`
- `docs/qa/acceptance-matrix.md`
- `docs/codex/2026-09-28-stage-76-web-same-profile-second-tab-read/`

## Risks

- Tab 2 UI state can mislead: record it as presentation limit, not data failure.

## Acceptance Checks

- Second tab reads exact committed bytes.
- Suites green.
- Matrix says read-only verified and simultaneous writes untested.