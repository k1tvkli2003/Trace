# Handoff

## Outcome
Stage 22 delivers the offline chat tool-router contract. One proposed tool call is validated against a strict allowlist and per-tool schema; unsafe payloads, unknown tools, malformed args, missing idempotency keys, and conflicting replays fail closed. Accepted proposals return inert receipts only.

## Changed Artifacts
- `services/ai_gateway/tool_router.py`
- `services/ai_gateway/test_tool_router.py`
- `services/ai_gateway/README.md`
- `docs/codex/2026-09-25-stage-22-chat-tool-router-offline-contract/`
- `docs/codex/_index.md`

## How To Continue
- Provenance reconciled on 2026-09-25: `457f7ce` is a dangling same-parent pre-commit tree, not on any branch; real history commit is `6069ee6` (`feat: add offline chat tool router contract`).
- Next only on user order: authorization/durable mutation wiring, chat UI integration, or live pipeline work.

## Done
- Offline allowlist validation for read-only and mutation proposals.
- Arg schema enforcement and unsafe-payload rejection.
- Idempotency replay plus conflict rejection.
- Gateway suite evidence and synchronized docs.

## Remaining
- No execution, auth, DB, network, UI, sync, or release work in this slice.
- Commit hash is recorded by repository history after final commit.

## Verification
- Passed: gateway suite, docs structure, diff-check.
- Not run: Flutter suites/build, devices, live pipeline.
