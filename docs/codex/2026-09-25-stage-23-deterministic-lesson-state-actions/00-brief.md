# Stage 23 deterministic lesson state actions

- Task ID: `2026-09-25-stage-23-deterministic-lesson-state-actions`
- Status: `active`
- Created: 2026-09-25
- Language: en

## Request
Continue Trace toward Stage 23: implement deterministic lesson footer actions behind a local-first domain/data boundary. Actions must produce durable learner-state evidence and remain safe for replay. Keep review scheduling out of this slice; Stage 24 owns scheduler behavior.

## Success Criteria
- `STUDIED`, `NOT_LEARNED`, `MASTERED`, `SKIPPED`, and `IN_PROGRESS` transitions are explicit and deterministic.
- Repeating the same action with the same idempotency/event ID is safe; conflicting reuse fails closed.
- State timestamps are UTC and action time is recorded without model/network calls.
- A state action appends an auditable local sync operation, while the learner projection remains readable after restart.
- Invalid transitions, unsupported status values, mismatched slice/artifact identity, and malformed payloads fail without partial writes.

## Context
Trace already has versioned `LearnerState`, `SyncOperation`, Drift tables, `LocalLessonRepository`, and Stage 22 typed tool validation. Current `LocalLessonRepository` persists immutable lesson/state rows but has no state-action API. The product contract requires footer actions to update local state immediately and queue sync later. Review items/events already exist; no scheduler changes belong here.

## In Scope
- Domain action enum/request/receipt contract.
- Local repository/service method for replay-safe learner state action.
- Sync operation creation for the state mutation.
- Focused Dart tests, migration-free if existing tables suffice.
- Work docs and truthful verification.

## Out of Scope
- Supabase/network sync worker or auth/RLS.
- AI/model calls, live gateway, or chat UI streaming.
- Review scheduler implementation.
- Changes to protected `StudyHub-Web`.
- New Flutter visual surface beyond existing stage contracts.

## Assumptions
- Existing `learner_states` row is the local projection source of truth.
- State action ID is caller-provided and acts as idempotency key.
- `SyncOperation` can carry the complete next state payload.
- First action may move `not_started` directly to `studied`, `not_learned`, `mastered`, or `skipped`; `in_progress` is a non-terminal reading signal.
