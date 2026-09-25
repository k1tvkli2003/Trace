# Stage 41 local outbox retry due query

- Task ID: `2026-09-25-stage-41-local-outbox-retry-due-query`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Give failed outbox rows a bounded, deterministic retry-candidate path
without adding a clock, scheduler, schema, network, or server-ack:
a read-only `listFailedWithinBudget` query plus a pure
`nextRetryAtUtc` mapping from failure time through the Stage34
`retryDelay` ladder.

## Success Criteria
- `listFailedWithinBudget({maxRetries})` returns only `failed` rows
  with `retryCount <= maxRetries`, ordered `createdAt` then
  `operationId`; negative budget fails closed with `ArgumentError`.
- `nextRetryAtUtc({failedAtUtc, retryCount, ...})` returns
  `failedAt + retryDelay(retryCount)` as UTC ISO-8601; non-UTC input
  or negative count fails closed.
- Focused test GREEN against minimal production addition; wider
  data/domain/app/Gateway suites GREEN.

## Context
Stages 31-40 built a local-only outbox: lifecycle, ordered pending
queue, retry budget, pure backoff, atomic claim, release, single-pass
worker, bounded drain, snapshot counts, pinned throw contract. Failed
rows are a dead-letter set with no listing and no due-time mapping.
`retryCount` lives inside `payloadJson` (no DB column), so budget
filtering happens after the reviewed row mapping.

## In Scope
- Read-only failed-row listing within budget, deterministic order.
- Pure UTC failure-time to next-retry mapping reusing `retryDelay`.
- Focused test plus full-suite regression check.

## Out of Scope
- Clock, sleep, scheduler loop, or "now >= due" evaluation (no clock
  owner yet; caller supplies `failedAtUtc`).
- Schema/migration (`next_retry_at` column is a later slice, not this).
- Worker/drain behavior change, server-ack, Supabase, OCR.
- `StudyHub-Web` stays untouched.

## Assumptions
- CreatedAt tie-break by row id (`operationId`) matches the queue
  ownership documented on Stage38 `drain`.
