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
| 4 | done | Initial commit `e5a1802`; correction checks in progress |

## Interfaces and Artifacts
- `services/ai_gateway/nine_router_transport.py`
- `services/ai_gateway/test_nine_router_transport.py`
- `docs/codex/2026-09-29-stage83-transport-remaining-deadline/`
- `docs/codex/_index.md`

## Risks
- A deadline at or past a phase boundary must fail closed without another
  network wait. The helper raises `AI_DEADLINE_EXCEEDED` when remaining time
  is zero or negative; the stream loop also rejects late frames after read.
- Real `HTTPConnection` may detach the socket into `response.fp.raw._sock`
  after headers; the helper now refreshes that socket when `connection.sock`
  is absent.

## Acceptance Checks
- Initial commit `e5a1802`: transport 13/13, gateway 96/96.
- Correction proof: transport 16/16, gateway 99/99.
- Local loopback HTTP: healthy SSE completed; delayed headers hit timeout
  near 1.00s with a 1s budget. No provider call.
- `validate_task_docs.py` task folder: OK.
- `git diff --check` and cached check: clean before correction commit.
