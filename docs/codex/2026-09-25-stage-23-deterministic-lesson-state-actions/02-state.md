# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Stage 23 local action contract and transactional repository method are implemented. Seven targeted tests and full suites pass. No scheduler, UI binding, sync push, or device runtime proof is claimed.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Keep actions local-first and scheduler-free | Stage 23 owns learner projection; Stage 24 owns deterministic review scheduling | stage plan |
| 2026-09-25 | Caller-provided action ID is idempotency key | Footer action must survive retry without duplicate mutation | product contract |
| 2026-09-25 | Preserve old learner-state rows and create new projection versions | Existing data contract treats state IDs/payloads as immutable | repository evidence |

## Blockers
- None.

## Done
- Task docs created and existing learner-state/oplog contracts inspected.
- Tests added before implementation; transaction, replay, conflicts, stale time, and identity checked.
- Local-first learner-state actions and versioned projection implemented.
- Independent state rows in one slice remain separate; replay returns the original receipt after a later action.
- Data 84, domain 106, design 12, app 35, and gateway 50 tests passed; data/domain analysis clean.

## Remaining
- Stage 23 slice committed in a1ad434 (ancestor of HEAD). HEAD also contains Stage25 extension 9c33f6c on the same repository/test files; Stage23 scheduler-free claim applies to a1ad434, not to current HEAD files.
- UI/chat binding, review scheduling, sync push, and device runtime proof are later work.
