# Stage 19 teacher-fa capability contract

- Task ID: `2026-09-25-stage-19-teacher-fa-capability-contract`
- Status: `done`
- Created: 2026-09-25T02:28:56
- Language: en

## Request
Define and test the offline teacher-fa capability contract: build a versioned Persian teaching prompt from an explicitly authorized slice scope, then validate the resulting Lesson AST against the same scope. No provider calls, model selection, credentials, OCR, persistence, or UI in this stage.

## Success Criteria
- Prompt builder binds one `sliceId`, exact authorized `sourceContext`, exact authorized `figures`, and independent versioned Persian teaching preferences.
- Source/figure metadata stay untrusted data in user-role payload; instruction-bearing policy stays system-side and reusable.
- Prompt size is guarded before any provider spend.
- Result validator rejects lessons that use foreign slice IDs, source citations, or figure IDs.
- All Gateway Python contract tests pass; domain/data suites stay green; docs record scope, verification, and handoff.

## Context
- Base Gateway policy lives in `services/ai_gateway/learning_contract.py`; teacher-fa specifics live in `services/ai_gateway/teacher_fa.py`.
- Lesson AST validation target is `docs/contracts/lesson-ast-v1.json` + `validate_lesson`.
- Stage 16/17/18 evidence is already closed; Stage 19 remains offline and provider-neutral.
- OpenCode Go remains the only eventual provider route; this stage authorizes no live route, model, or cost claim.

## In Scope
- Offline `teacher_fa.py` prompt envelope creation.
- Preference validation and independent policy versioning.
- Authorization-scope enforcement for source and figure IDs.
- Prompt byte-size guard.
- Offline `validate_teacher_fa_result` scope validation.
- Contract tests in `test_teacher_fa.py`.
- Policy reference doc in `services/ai_gateway/prompts/teacher-fa/teacher-fa-v1.md`.
- README contract-language update.

## Out of Scope
- Live provider calls, model selection, API keys, request IDs, token/cost metering.
- OCR, PDF rendering, Vision compatibility, or actual lesson generation.
- Drift persistence, sync, scheduler changes, Flutter UI, Workbench shell.
- Prompt-injection-proof factual accuracy: schema/scope validation only; factual correctness still needs source review.

## Assumptions
- Authorized slice IDs come from Stage 17 slice plan + cursor.
- Source review remains the final factual gate.
- Actual model route/cost is proven only through a separate real pilot.
