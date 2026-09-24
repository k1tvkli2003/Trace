# Plan

## Approach
Implement the teacher-fa contract offline with TDD: write scope/security regression tests first, then the prompt/result contract, then fixtures/policy reference, keeping the full Gateway suite green and no provider dependency.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: teacher-fa tests fail because no `teacher_fa.py` contract exists |
| 2 | done | GREEN: add `teacher_fa.py` envelope builder, preference policies, scope guard, size guard, result validator |
| 3 | done | Add policy reference `teacher-fa-v1.md` and update Gateway README contract language |
| 4 | done | Run targeted + full Gateway + domain + data suites and record evidence |
| 5 | active | Fill Stage 19 docs, validate structure, stage/commit separately from Stage 17 fixes |

## Interfaces and Artifacts
- `services/ai_gateway/teacher_fa.py`: `build_teacher_fa_prompt`, `validate_teacher_fa_result`, `TeacherFaPreferences`, policy/version constants.
- `services/ai_gateway/test_teacher_fa.py`: 9 offline contract tests.
- `services/ai_gateway/prompts/teacher-fa/teacher-fa-v1.md`: canonical policy reference.
- `services/ai_gateway/README.md`: contract-language note naming the Stage 19 scope guard.
- Stage 19 task docs: brief/plan/state/progress/verification/handoff + index row.
- Stage 17 fixes remain separate staged files, not part of the Stage 19 commit.

## Risks
- Scope validator could diverge from `lesson-ast-v1` — mitigated by calling shared `validate_lesson`.
- Preference text could leak into system policy — mitigated by user-payload mapping plus version strings only.
- Live behavior may differ — mitigated by explicit no-pilot claim in docs and handoff.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` passes; 41 tests OK.
- `test_teacher_fa.py` alone passes; 9 tests OK.
- Domain focused + full + analyze pass; data suite passes.
- `git diff --check` clean; Stage 19 files committed separately.
- Task docs validate structurally; state/brief/index all `ready-for-review`.
