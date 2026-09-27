# State

- Current status: `done`
- Last updated: 2026-09-28
- Owner: Codex

## Current State

The same-profile second live tab reads the same committed collection bytes from `trace_local_v1`. Collective selection across tabs is intentionally out of scope: tab 2 displays the welcome/new-collection state while item `Trace browser persistence` remains visible in its sidebar.

## Decisions

| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-28 | Verify read-only same-profile tab reading, not concurrent writes | Drift Web single-tab contract remains authoritative | matrix and run output |
| 2026-09-28 | Keep selection out of claim | Screenshot shows selection is per-tab UI state | vision evidence |

## Blockers

- None

## Done

- Import remains while selected; reload verifies bytes.
- Optional multi-tab mode opens second live tab in the same Chrome profile and reads exact bytes (`hit:true`).
- Tab-2 screenshot preserved as real-app UI verification asset.

## Remaining

- None