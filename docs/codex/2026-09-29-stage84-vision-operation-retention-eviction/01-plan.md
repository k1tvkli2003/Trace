# Plan

## Approach
Keep ownership in `VisionAdapter`: count active users per entry under the
adapter lock only (no new lock ordering), and on insert-at-capacity evict
the oldest terminal entry with zero active users. Never evict pending
entries. One RED/GREEN cycle per behavior: eviction first, in-flight
safety second.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED test1: oldest completed entry evicts at bound; semantic fixed to resubmit-with-fresh-id per brief |
| 2 | done | GREEN: `active` counter + `_evict_oldest_terminal_locked` |
| 3 | done | RED test2: in-flight entry never evicted at bound (`_MAX_OPERATIONS = 1`) |
| 4 | done | GREEN confirm + targeted and full suites: `101/101 OK` |
| 5 | done | Docs, validator, diff-check, review, commit staging (commit runs next) |

## Interfaces and Artifacts
- `services/ai_gateway/page_vision.py`: `_Operation.active`,
  `_evict_oldest_terminal_locked`, `extract` acquire/release accounting.
- `services/ai_gateway/test_page_vision.py`: 2 new tests.
- Task docs `docs/codex/2026-09-29-stage84-.../` + `_index.md` row.
- No change to transport, budget, routing, retry, or provider route.

## Risks
- Evicted entry resubmits with fresh `request_id`: accepted RAM-only
  retention semantic, documented in brief/state/handoff; replay-while-retained stays exact.
- Lock-ordering deadlock: `active` touched only under adapter `_lock`;
  per-operation locks never acquired while holding it. Eviction skips
  `active > 0` and non-terminal entries without touching their locks.
- Test-only bound shrink via module constant monkeypatch, restored in
  `finally`; default 1024 untouched.

## Acceptance Checks
- New test1 fails with `AI_OPERATION_LIMIT_EXCEEDED` before GREEN.
- New test2 fails before GREEN (in-flight evicted or duplicate submit).
- After GREEN: `test_page_vision` targeted green, full gateway discover
  green, validator `OK`, `git diff --check` clean.
