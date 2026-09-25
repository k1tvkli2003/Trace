# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Data-only first-STUDIED atomic wiring implemented. Verification partial: data, domain, gateway pass; no app, browser or device run.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Use `lesson_box` target on immutable lesson artifact ID. | Cache replay links to a specific artifact version. | Stage 24 handoff |
| 2026-09-25 | Only first transition to `STUDIED` creates review. | Later schedule is owned by append-only review events, not state replay. | Data tests |
| 2026-09-25 | Stable review identity derives from origin state ID. | Replays and later state versions retain one review. | Repository contract |
| 2026-09-25 | Conflicting pre-existing review aborts initial studied action. | Never attach new learner-state mutation to a forged/reused review. | Red conflict test |

## Blockers
- None for this data-only slice. UI review inbox and real sync remain separate work.

## Done
- RED/GREEN proof; first study due +1 day; non-study and replay tests.
- Nested Drift transaction and injected review-write failure rollback.
- Data 99, domain 106, gateway 50 tests pass; data analyze and format clean.

## Remaining
- Documentation validation and commit.
- Next task: Review Inbox and cached replay, real action footer, sync/event outbox, device tests.
