# Handoff

## Outcome
Stage 18 Lesson AST validation parity implemented locally. JSON Schema, Dart domain parsing, and Python gateway validation now reject blank identity/text values, active markup, unsafe URL schemes, and ordinary blocks carrying `figureId`.

## Changed Artifacts
- `docs/contracts/lesson-ast-v1.json`
- `packages/trace_domain/lib/src/models/lesson_ast.dart`
- `packages/trace_domain/test/lesson_ast_test.dart`
- `services/ai_gateway/learning_contract.py`
- `services/ai_gateway/test_learning_contract.py`
- Stage 18 work docs under this directory.

## How To Continue
- Begin Stage 19 teacher-fa capability contract work without enabling live provider calls.
- Preserve Stage 18 validator/schema parity and source-bound citation gates.

## Done
- Strict allowlist and inert text behavior preserved.
- Figure/explanation and citation gates preserved.
- Regression tests demonstrate RED then GREEN behavior.

## Remaining
- No live AI call, Vision pilot, source-span factual review, UI E2E, sync, or release proof.
- Stage 19 teacher-fa generation and golden fixtures remain.

## Verification
- Dart focused: 5 passed.
- Full `trace_domain`: 103 passed; `dart analyze lib test`: no issues.
- AI gateway: 32 passed.
- Full `trace_data`: 77 passed.
- `git diff --check`: passed.
