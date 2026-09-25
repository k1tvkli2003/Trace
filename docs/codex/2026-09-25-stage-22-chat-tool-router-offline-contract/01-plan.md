# Plan

## Approach
TDD vertical tracer: one failing test for a valid read-only receipt, then minimal router, then one cycle each for mutation receipt, unknown-tool rejection, malformed args, missing idempotency, duplicate replay, conflict reuse, unsafe payloads. Router is pure offline Python with no imports beyond stdlib; receipts carry validation outcome and never touch DB/network.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Fill task docs (brief/plan/state/progress) |
| 2 | planned | RED: `test_tool_router.py` with allowlist/validation/idempotency cases |
| 3 | planned | GREEN: `tool_router.py` minimal offline router |
| 4 | planned | Run gateway unit suite and docs validation; record evidence |
| 5 | planned | Update state/progress/verification/handoff/_index.md; commit |

## Interfaces and Artifacts
- `services/ai_gateway/tool_router.py` (new)
- `services/ai_gateway/test_tool_router.py` (new)
- `services/ai_gateway/README.md` (only if router contract needs one paragraph)
- `docs/codex/2026-09-25-stage-22-chat-tool-router-offline-contract/`

## Risks
- Scope creep into execution/auth/DB: router returns receipts only; execution stays out.
- Over-permissive args: strict per-tool schema checks with bounded sizes.
- Replay ambiguity: same key plus same canonical call replays; any difference conflicts.

## Acceptance Checks
- New tests fail before router exists and pass after.
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` passes.
- `validate_task_docs.py --structure-only` passes; docs status synchronized.
