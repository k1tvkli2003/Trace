# State

- Current status: `ready-for-review`
- Last updated: 2026-09-29
- Owner: Hermes

## Current State
Hardening is implemented locally. Deeply nested JSON maps to `AI_SCHEMA_REJECTED`
and replays from the cached failure with one submission. The SSE reader counts
every received byte toward `_MAX_STREAM_BYTES`, so comment/unknown frames cannot
clear the ceiling by being consumed. The transport validates the API key charset
before use and raises `AI_TRANSPORT_NOT_CONFIGURED` without echoing the value.
Final-only SSE assembly enforces the same `max_output_tokens * 64` cap as the
delta path. The SSE parser accepts both `data:` and `data: ` prefixes per spec.

## Decisions
- Removed unused `_MAX_TEXT_CHARS`; `_MAX_STREAM_BYTES` remains the single stream
  ceiling, enforced on both aggregate reads and unconsumed buffer.
- API key allowlist: ASCII alphanumerics plus `-_.~+/=`, length 16-256. Values
  outside the allowlist are treated as not configured, with no secret in the error.
- No Flutter wiring, no route change, no schema relaxation in this stage.

## Done
- Adapter: `RecursionError` maps to cached `AI_SCHEMA_REJECTED` with single submission.
- Transport: aggregate stream ceiling, key charset validation, final-assembly cap,
  spec-tolerant SSE prefix — all covered by new RED-first tests.

## Remaining
- Feat committed at `bf1f83b`; this docs-close names it and records parent review.
- Deferred review items (lock refactor, dead branches, Content-Type, operation-map
  bounds) need a follow-up stage with explicit user order.
