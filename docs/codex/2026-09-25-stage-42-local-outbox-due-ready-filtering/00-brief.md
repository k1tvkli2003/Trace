# Stage 42 local outbox due-ready filtering

- Task ID: `2026-09-25-stage-42-local-outbox-due-ready-filtering`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Continue the local outbox progression after Stage41. Add a deterministic, bounded query that identifies retry candidates whose caller-supplied due time has arrived, without inventing a clock owner or server transport.

## Success Criteria
- A read-only repository method returns only `failed` operations within retry budget whose supplied due timestamp is at or before a supplied `nowUtc`.
- Ordering remains deterministic: `createdAt`, then `operationId`.
- Invalid budget, non-UTC timestamps, and malformed due input fail closed.
- TDD RED is observed before production code; focused and full suites pass.
- Docs, validator, scans, and commit are complete.

## Context
Stage41 added `listFailedWithinBudget` and pure `nextRetryAtUtc`. The local schema has no `failedAt` or due column. This stage therefore accepts a caller-owned due-time map keyed by operation ID rather than adding schema or pretending a scheduler exists.

## In Scope
- `LocalOplogRepository.listDueFailedWithinBudget` or equivalent typed API.
- Focused tests for due, future, missing, malformed, ordering, budget, and UTC validation.
- Stage42 work docs and index.

## Out of Scope
- Clock ownership, `DateTime.now()`, sleeps, timers, scheduler, background loop.
- Drift migration or `failedAt` schema storage.
- Network/server acknowledgement, Supabase, RLS, Storage, OCR, UI, and platform runtime.

## Assumptions
- Caller supplies a UTC ISO-8601 `nowUtc` and due times keyed by operation ID.
- Due equality is ready: `dueAt <= nowUtc`.
- The due map is trusted only as input data; parsing and UTC checks remain repository responsibilities.
