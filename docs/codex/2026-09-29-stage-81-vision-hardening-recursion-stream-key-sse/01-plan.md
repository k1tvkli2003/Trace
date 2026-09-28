# Plan

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | audit: critic findings `deleg_84e1109a`, Stage80 HEAD `f9c0e89`, suite baseline `88/88` |
| 2 | done | RED: nested-JSON, stream-aggregate, hostile-key, final-cap, SSE-prefix tests |
| 3 | done | GREEN: RecursionError mapping, aggregate counter, key charset, final cap, SSE prefix |
| 4 | done | full suite `92/92`, docs ready, commit pending |

## Acceptance Gates
| Gate | Command/Proof | Expected |
|---|---|---|
| Targeted adapter/transport | `python -m unittest test_page_vision test_nine_router_transport` from `services/ai_gateway` | `24/24 OK` |
| Full gateway suite | `python -m unittest discover -s services/ai_gateway -p "test_*.py"` | `92/92 OK` |
| Task docs | `validate_task_docs.py <this-task-dir>` | `OK` |
| Diff hygiene | `git diff --check` | clean |
| Live product pilot | none this stage | `NOT VERIFIED` |
