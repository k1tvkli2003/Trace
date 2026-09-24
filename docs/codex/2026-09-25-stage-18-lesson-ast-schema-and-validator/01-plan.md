# Plan

## Approach
Preserve flat v1 contract. Use test-first regression cases at Dart and JSON Schema boundaries, then close only observed parity gaps. Keep Python validator aligned. No model connection or schema migration.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Audit existing AST schema, Dart parser, Python validator, renderer and artifact scope. |
| 2 | done | RED: test unsafe lesson text and whitespace-only identities in Dart; test schema parity and non-figure `figureId` in Python. |
| 3 | done | GREEN: enforce Dart text/identity guard and schema constraints; keep Python unsafe scheme check aligned. |
| 4 | done | Full suites passed, read-only review found no blockers, docs finalized and commit pending. |

## Interfaces and Artifacts
- `docs/contracts/lesson-ast-v1.json`
- `packages/trace_domain/lib/src/models/lesson_ast.dart`
- `packages/trace_domain/test/lesson_ast_test.dart`
- `services/ai_gateway/learning_contract.py`
- `services/ai_gateway/test_learning_contract.py`

## Risks
- JSON Schema cannot authorize citations or prove figure/explanation one-to-one pairing; runtime checks remain authoritative.
- Regex filtering is defense-in-depth, not substitute for inert Flutter rendering or URL allowlisting at action boundaries.

## Acceptance Checks
- `dart test test/lesson_ast_test.dart -r expanded` in `packages/trace_domain`
- `dart test -r compact && dart analyze lib test` in `packages/trace_domain`
- `python -m unittest discover -s services/ai_gateway -p 'test_*.py' -v` at repo root
- `dart test -j 1 -r compact` in `packages/trace_data`
- `git diff --check`; docs validator; clean worktree after commit.
