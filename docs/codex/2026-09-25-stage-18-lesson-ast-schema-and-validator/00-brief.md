# Stage 18 lesson AST schema and validator

- Task ID: `2026-09-25-stage-18-lesson-ast-schema-and-validator`
- Status: `done`
- Created: 2026-09-25
- Language: en

## Request
Implement Stage 18 of the StudyForge/Trace plan: make the typed Lesson AST contract strict and aligned across JSON Schema, Dart domain parsing, and the offline Python gateway validator.

## Success Criteria
- Allowlisted lesson block types only.
- Every factual block has nonblank authorized citations.
- Figure blocks have no text; every figure has exactly one matching explanation.
- Arbitrary fields, active markup, unsafe URL schemes, and whitespace-only identities/text are rejected.
- Dart, Python, and JSON Schema tests agree.

## Context
Stage 17 is complete and committed. Existing Lesson AST code already rejects unknown fields, unknown block types, missing citations, foreign citations, and unmatched figures, but parity gaps remained for whitespace-only values, unsafe text, and non-figure blocks carrying `figureId`.

## In Scope
- `docs/contracts/lesson-ast-v1.json`
- `packages/trace_domain/lib/src/models/lesson_ast.dart` and focused tests
- `services/ai_gateway/learning_contract.py` and focused tests
- Stage 18 work documentation

## Out of Scope
- AI provider calls, Vision, OCR, raw HTML rendering, persistence migration, sync, UI redesign, and `StudyHub-Web` changes.

## Assumptions
- Lesson AST remains flat `lesson-ast-v1` and Persian-only.
- Validation is fail-closed; factual accuracy still requires source review beyond schema validation.
