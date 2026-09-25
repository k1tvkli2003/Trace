# Stage 22 chat tool router offline contract

- Task ID: `2026-09-25-stage-22-chat-tool-router-offline-contract`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Continue Stage 22 without live AI or DB writes. Add a minimal offline tool-call router contract in `services/ai_gateway`: model output may only propose one typed, allowlisted tool call; validation, authorization, and durable mutation stay outside the gateway. Contract must reject SQL, raw HTML, unknown tools, malformed args, missing idempotency keys, and duplicate mutation replays.

## Success Criteria
- `services/ai_gateway/tool_router.py` validates one proposed tool call offline and returns an inert receipt.
- Read-only allowlist: `get_current_slice`, `get_source_citations`, `search_cached_source`, `get_due_reviews`, `get_highlights`, `get_notes`, `get_learning_state`.
- Mutation allowlist: `mark_lesson_state`, `schedule_review`, `create_note`, `update_note`, `create_highlight`, `delete_highlight`, `jump_to_node`, `request_next_slice`, `set_preference`, `retry_failed_job`.
- Duplicate idempotency keys replay the same receipt; conflicting reuse is rejected.
- Unit tests prove allowlist, arg validation, idempotency, and no-DB/no-network behavior.

## Context
Monorepo `Trace`. Stages 13/14/15 done for offline validators and cache. Stage 18 froze Lesson AST contracts. Stage 21 closed teaching-stage reskin at `a434743`. `ToolInvocation` domain model exists as an audit receipt only. `learning_contract.py` says coach proposes no mutations or tool calls; this slice defines the separate router boundary for chat tools without changing live pipeline gates.

## In Scope
- New `services/ai_gateway/tool_router.py` offline validator/receipt builder.
- New `services/ai_gateway/test_tool_router.py` unit tests (TDD, RED first).
- Task docs, verification, handoff.

## Out of Scope
- Live model calls, route verification, Vision calls.
- Drift writes, repositories, sync, auth, Flutter chat wiring.
- New tool semantics, schema changes, release work.

## Assumptions
- Router never executes a tool; it only validates and receipts a proposal.
- Durable mutation, ownership, and UI confirmation belong to a later stage.
