# Plan

## Approach
RED-first: add one failing test per behavior (transient non-cache, in-flight
third caller, duplicate during slow validation, Content-Type reject), watch them
fail, then make the minimal adapter/transport change. Keep `BudgetedRun` as the
second submit gate; the adapter owns first-gate locking and failure caching.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | in_progress | RED: transient + concurrency + content-type tests |
| 2 | planned | GREEN: adapter transient guard + locked writes; transport Content-Type |
| 3 | planned | Full suite + validator + diffcheck |
| 4 | planned | Docs to ready-for-review + commit |

## Interfaces and Artifacts
- `services/ai_gateway/page_vision.py` (`extract`, `_perform`, failure cache)
- `services/ai_gateway/nine_router_transport.py` (`_read_sse` / response check)
- `services/ai_gateway/test_page_vision.py`, `test_nine_router_transport.py`
- Task docs under `docs/codex/2026-09-29-stage-82-.../`

## Risks
- Over-locking causing deadlock: mitigate by holding `_lock` only for
  state assignment, never across transport/validation.
- Changing failure replay semantics: mitigate with the existing
  `test_failed_operation_replays_same_safe_code` staying green.

## Acceptance Checks
- `python -B -m unittest test_page_vision test_nine_router_transport -v` targeted OK
- `python -B -m unittest discover -s services/ai_gateway -p "test_*.py"` full OK
- `validate_task_docs.py` for this task OK; `git diff --check` clean
