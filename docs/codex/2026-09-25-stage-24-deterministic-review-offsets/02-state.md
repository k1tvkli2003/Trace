# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
`fixed-offset-v2` implementation and behavior coverage are in the working tree. First study creates due A+1; on-time good reviews advance gap steps [2,4,8,15] for due A+3, A+7, A+15, A+30; late reviews keep one event and use actual review instant; again resets with a lapse, hard holds the gap, easy skips one milestone; after 30 days good moves 30/60/120 with a cap. Repository append checks projected due, version identity, event ordering, and stale chains before atomic insert. Existing v1 rows keep original policy; no DB migration. Verification evidence/logs still need completion, then commit.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Keep v1 rows under original v1 policy, never migrate schedules silently. | Avoid moving existing due dates. | repo tests, Stage 24 contract |
| 2026-09-25 | Use day = fixed 24h UTC; timezone stays display-only. | Deterministic scheduling across devices. | product contract |
| 2026-09-25 | No footer/sync/UI/network/AI in this slice. | Plan boundary and offline determinism. | user non-negotiables |

## Blockers
- None.

## Done
- Review model, event, repository, database, and existing test inspected.
- Task docs created; scope pinned to offset milestones.
- RED tests added for on-time milestones, first study, subsecond precision, event append/replay, late review, hard/again/easy, post-30 policy, invalid gap.
- `firstStudyItem`, `_projectNextOffset`, version-aware append, and repository validation implemented.
- Working implementation preserves v1 semantics without migration.
- Bounded verification done: data 93/93, domain 106/106, gateway 50/50; both data/domain analyze checks clean and data format unchanged.

## Remaining
- Record final verification output and validate task docs.
- Commit this bounded scheduler slice.
- Subsequent stage: wire Stage 23 state actions and UI/footer to review item creation in one transaction; no such flow exists yet.
