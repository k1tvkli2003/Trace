# Stage 76 — Web same-profile second-tab read proof

- Task ID: `2026-09-28-stage-76-web-same-profile-second-tab-read`
- Status: `done`
- Created: 2026-09-28
- Language: en

## Request

Close only the Stage 9 evidence gap that can be proven safely now: read committed local data from a fresh second live Chrome tab using the same temporary profile.

## Success Criteria

- Existing persistence and native import smoke remains green.
- Optional multi-tab mode opens a second tab in the same Chrome profile.
- Second tab reads exact collection bytes from `trace_local_v1`.
- Failure is loud; no silent skip.
- Matrix and handoff state exact limits.

## Context

Stage75 proved single-tab import and reload. Drift Web remains single-client for writes. Stage76 only proves committed-byte visibility in a fresh same-profile tab.

## In Scope

- `tool/smoke_web_library.py` optional multi-tab read path.
- `tool/test_smoke_web_library.py` contract.
- Acceptance matrix and task docs.

## Out of Scope

- Simultaneous writes.
- Product database changes.
- `StudyHub-Web`.
- Secrets in source, logs, or artifacts.
- Untracked critic workspace.

## Assumptions

- None beyond the recorded run evidence.