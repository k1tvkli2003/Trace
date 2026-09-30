# Handoff

## Outcome
Stage84 eviction semantic frozen and implemented: bounded map at 1024,
FIFO terminal-first eviction, in-flight entries never evicted, evicted
entries resubmit once with a fresh `request_id`, retained entries replay
exactly. Suite `101/101 OK`.

## Changed Artifacts
- `services/ai_gateway/page_vision.py`: `_Operation.active`, `_evict_oldest_terminal_locked`, `extract` acquire/release accounting.
- `services/ai_gateway/test_page_vision.py`: 2 new tests (`test_bounded_map_evicts_oldest_completed_for_new_operation`, `test_in_flight_entry_never_evicted_at_bound`).
- `docs/codex/2026-09-29-stage84-vision-operation-retention-eviction/`: brief/plan/state/progress/verification/handoff current; previews marked not required.
- `docs/codex/_index.md`: one Stage84 row (already present).

## How To Continue
- Run one commit.

## Done
- RED/GREEN for eviction and in-flight guard; semantic aligned to brief.
- Docs current; state `ready-for-review`.

## Remaining
- One commit.

## Verification
- Green: full gateway suite `101/101 OK`; validator `OK`; `diff --check` clean; review `No findings`. Open: one commit.
