# Plan

## Approach
RED-first, narrow ownership. Preserve `BudgetedRun` and existing stable
error mapping. Move only socket timeout refresh into transport helper, using
one monotonic deadline per call.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Freeze current code and select F20 deadline slice |
| 2 | done | RED regression test failed on old behavior: `[5.0, 5.0]` |
| 3 | done | GREEN helper refreshes remaining timeout; targeted/full suites pass |
| 4 | active | Docs validated; staged check and commit remain |

## Interfaces and Artifacts
- `services/ai_gateway/nine_router_transport.py`
- `services/ai_gateway/test_nine_router_transport.py`
- `docs/codex/2026-09-29-stage83-transport-remaining-deadline/`
- `docs/codex/_index.md`

## Risks
- A timeout of zero at a phase boundary must fail closed. The helper uses a
  minimal positive socket timeout, while the loop's monotonic check remains the
  authority for `AI_DEADLINE_EXCEEDED`.
- Socket mocks may not expose `sock.settimeout`; helper has a bounded fallback
  to `connection.timeout`.

## Acceptance Checks
- `python -B -m unittest test_nine_router_transport -v` in
  `services/ai_gateway`: 13/13 OK.
- `python -B -m unittest discover -s services/ai_gateway -p "test_*.py"`:
  96/96 OK.
- `validate_task_docs.py` task folder: OK.
- `git diff --check` and cached check: clean.
