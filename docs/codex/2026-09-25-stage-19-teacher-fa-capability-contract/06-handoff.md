# Handoff

## Outcome
Stage 19 teacher-fa offline contract implemented and tested. It does not authorize a model call. The prompt/result path is source-scope-bound, policy-versioned, and schema-validated.

## Changed Artifacts
- `services/ai_gateway/teacher_fa.py`: prompt builder, typed preferences, authorization-scope validation, byte-size guard, result validator.
- `services/ai_gateway/test_teacher_fa.py`: 9 offline contract tests.
- `services/ai_gateway/prompts/teacher-fa/teacher-fa-v1.md`: canonical policy reference.
- `services/ai_gateway/README.md`: Stage 19 boundary language.
- `docs/codex/2026-09-25-stage-19-teacher-fa-capability-contract/`: task record.
- `docs/codex/_index.md`: Stage 19 row.

## How To Continue
Wire a server-only provider adapter only after confirming OpenCode Go endpoint/vision compatibility and cost on a real pilot with explicit user authorization. Keep source text and figure metadata out of logs/client bundles. Add bounded timeout/cancel/retry/ledger and real response validation before enabling a Flutter path. A separate Stage 17 cursor/planner safety-fix commit should precede any ingestion wiring.

## Done
- Stage 19 offline contract and tests; full Gateway suite, domain suite, data suite, analyze and diff hygiene green.

## Remaining
- Real provider compatibility/cost pilot, Flutter renderer/UI integration, ingestion worker persistence, Sync/RLS, Android/Windows/Web E2E and release proof remain outside Stage 19.
- 2026-09-25 addendum: Stage 17 safety-fix commit done as e0d5e23; no Stage19 code change.

## Verification
- Gateway `41/41` tests passed; focused planner/cursor suite, full domain/data suites and analyze passed. No live AI, Vision, OCR, app runtime, sync or release claim.
