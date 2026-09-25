# Stage 43 local outbox due requeue

- Task ID: `2026-09-25-stage-43-local-outbox-due-requeue`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Continue the local outbox progression after Stage42. Add a deterministic, bounded transition that requeues only failed rows within retry budget whose caller-supplied due time has arrived, reusing the Stage42 due filter and Stage33 budget semantics.

## Success Criteria
- A repository method requeues only `failed` rows within budget with supplied due `<=` supplied `nowUtc`, returning them in `createdAt` then `operationId` order.
- Future, missing-due, non-failed, and over-budget rows stay untouched.
- Invalid budget, non-UTC timestamps, and malformed due input fail closed before any transition.
- TDD RED is observed before production code; focused and full suites pass.
- Docs, validator, scans, and commit are complete.

## Context
Stage41 added `listFailedWithinBudget` and pure `nextRetryAtUtc`. Stage42 added read-only `listDueFailedWithinBudget({nowUtc, dueAtUtcByOperationId, maxRetries})` with caller-owned clock and due map. Single-row `requeueFailed` already enforces budget (`canRequeue` `<=`). No `failedAt` column exists; this stage composes the existing filter with the existing transition without adding schema, clock, scheduler, or transport.

## In Scope
- `LocalOplogRepository.requeueDueFailedWithinBudget` or equivalent typed API composing filter + transition.
- Focused tests for due requeue, untouched rows, ordering, budget, and UTC validation.
- Stage43 work docs and index.

## Out of Scope
- Clock ownership, `DateTime.now()`, sleeps, timers, scheduler, background loop.
- Drift migration or `failedAt` schema storage.
- Network/server acknowledgement, Supabase, RLS, Storage, OCR, UI, and platform runtime.

## Assumptions
- Caller supplies UTC ISO-8601 `nowUtc` and due times keyed by operation ID.
- Due equality is ready: `dueAt <= nowUtc`.
- Missing due entries are excluded, never invented.
