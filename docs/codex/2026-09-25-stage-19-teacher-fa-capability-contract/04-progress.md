# Progress

## Log
| Time | Status | Entry | Evidence |
|---|---|---|---|
| 2026-09-25T02:28:56 | active | Task docs created. | docs/codex/2026-09-25-stage-19-teacher-fa-capability-contract/ |
| 2026-09-25 | active | RED: teacher-fa tests written against missing contract. | `services/ai_gateway/test_teacher_fa.py` |
| 2026-09-25 | active | GREEN: offline prompt/result contract passes targeted tests. | `services/ai_gateway/teacher_fa.py` |
| 2026-09-25 | active | Added canonical `teacher-fa-v1` policy reference and README scope language. | `services/ai_gateway/prompts/teacher-fa/teacher-fa-v1.md`, `services/ai_gateway/README.md` |
| 2026-09-25 | active | Full Gateway suite green; domain focused/full/analyze green; data green. | `review17-gateway.log`, `review17-focused.log`, `review17-domain.log`, `review17-analyze.log`, `review17-data.log` |
| 2026-09-25 | ready-for-review | Reproduced Stage 17 review findings separately: planner priority, vision gate, planner-version forwarding, next-block page. | `slice_planner.dart`, `slice_cursor_advance.dart`, planner/cursor tests |

## Done So Far
- 9 offline teacher-fa contract tests covering defaults, invalid preferences, exact scope, authorization requirement, out-of-scope source/figure, size guard, injection separation, result validation, and preference round-trip.
- Offline builder/validator with hash-checked sources, foreign-figure rejection, explicit authorization sets, and byte-size guard.
- Policy reference plus README boundary language.
- Stage 17 review reproduction fixes verified but kept separate from Stage 19 commit.

## Next
- None. Record closed 2026-09-25; validator OK, f8a84cd + e0d5e23 committed, worktree clean.
