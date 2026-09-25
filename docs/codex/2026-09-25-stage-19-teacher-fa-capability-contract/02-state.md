# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Teacher-fa offline contract is implemented and green: prompt builder plus result validator enforce explicit authorized slice scope; preferences map to independent versioned policies; size guard runs before provider spend; source/figure checks reject foreign IDs; README plus policy reference record boundaries.

Stage 17 review reproduction fixes were committed separately as e0d5e23: planner earliest-missing-page priority, vision-required selection gate, planner-version forwarding on advance, and exact next-block page reporting. These are **not** part of the Stage 19 commit f8a84cd.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Require explicit `authorized_source_ids` + `authorized_figure_ids` before prompt build | Implicit scope lets foreign blocks/figures leak into lesson input | `teacher_fa.py:198-199`, `test_teacher_fa.py:138-149` |
| 2026-09-25 | Keep teaching choices as versioned allowlisted policies only | Free-form preference text is an instruction-injection channel | `teacher_fa.py:21-42`, `test_teacher_fa.py:102-116` |
| 2026-09-25 | Reject prompt payloads above 65536 bytes before any provider spend | Long-context slices must fail closed, not become silent cost | `teacher_fa.py:89`, `test_teacher_fa.py:167-175` |
| 2026-09-25 | Delegate result validation to shared `validate_lesson` with current source/figure context | Avoid a second divergent Lesson AST validator | `teacher_fa.py:236-252`, `test_teacher_fa.py:190-212` |
| 2026-09-25 | Keep Stage 17 review fixes in a separate staged change | Stage 19 remains a capability contract only; cursor/planner safety fixes deserve their own commit | diff of `slice_planner.dart` + `slice_cursor_advance.dart` |

## Blockers
- None.

## Done
- Offline teacher-fa prompt/result contract and 9 regression tests.
- Policy reference and Gateway README contract update.
- Full verification evidence captured.

## Remaining
- Validate Stage 19 task docs structure.
- Commit Stage 19 files separately.
- Update `_index.md` + brief/state to `ready-for-review` or `done`.
- Commit Stage 17 fixes separately after Stage 19 if still justified.
