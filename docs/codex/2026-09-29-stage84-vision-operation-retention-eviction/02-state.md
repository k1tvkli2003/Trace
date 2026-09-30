# State

- Current status: `done`
- Last updated: 2026-09-30
- Owner: Codex

## Current State
Implementation is complete and both suites are green: targeted
`test_page_vision` plus full gateway `discover` report `101/101 OK`.
Evicted entries resubmit with a fresh `request_id` per the RAM-only
retention semantic in the brief; retained entries keep exact replay.
Remaining: validator, `git diff --check`, independent review, one commit.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-29 | Keep `active` counting under the adapter lock only; no new lock ordering. | Avoid deadlock and keep ownership simple. | repo/test |
| 2026-09-29 | FIFO evict oldest terminal entry at capacity; never evict in-flight (`active > 0` or lock held). | Close Stage82 bound debt with smallest change. | repo/test |
| 2026-09-30 | Evicted entry resubmits once with fresh `request_id` on next use (no tombstone, no `AI_OPERATION_REPLAY_EXPIRED`). | RAM-only retention semantic already in brief lines 38-41; implementation never had a replay-expired path, so the test was aligned to the brief. | brief/test |

## Blockers
- None.

## Done
- RED test1 + GREEN eviction (`_evict_oldest_terminal_locked`, `active` accounting).
- RED test2 + GREEN in-flight guard (`_MAX_OPERATIONS = 1` scenario).
- Test1 semantic fix: evicted `op-a` resubmits with fresh `request_id`, `4` transport calls.
- Targeted suite `101/101 OK`, full gateway `discover` `101/101 OK`.

## Remaining
- None. Committed as `9dbd008`.
