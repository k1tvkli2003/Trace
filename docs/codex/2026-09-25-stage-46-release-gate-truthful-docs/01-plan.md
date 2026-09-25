# Plan

## Approach
Docs-only tracer bullet: write the two missing truthful docs from recorded evidence (Stage30 verification + release-gate audit), label every unverified surface explicitly, then validate docs, scan the staged diff, and commit without touching production code.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | completed | Task docs scaffolded via `create_task_docs.py` |
| 2 | completed | Brief filled with audit evidence and scope |
| 3 | in_progress | Write `docs/qa/acceptance-matrix.md` from Stage30 verification evidence |
| 4 | planned | Write `docs/ops/runbook.md` with local-only commands actually run |
| 5 | planned | Fill state/progress/verification/handoff, mark ready-for-review |
| 6 | planned | Update `_index.md`, run validator, scan staged diff, commit |

## Interfaces and Artifacts
- `docs/qa/acceptance-matrix.md` (new, docs-only)
- `docs/ops/runbook.md` (new, docs-only)
- `docs/codex/2026-09-25-stage-46-release-gate-truthful-docs/` (task record)
- `docs/codex/_index.md` (one index row update)

## Risks
- Copying unverified claims into the matrix: mitigate by tracing every Result cell to a recorded run or marking NOT VERIFIED / MISSING with reason.
- Inventing a CI/benchmark/E2E surface: mitigate by explicit do-not-add list and staged-diff review.

## Acceptance Checks
- `validate_task_docs.py` on the Stage46 folder returns OK.
- Staged diff contains only the two new docs plus task docs and index row.
- Secret/static scans clean; worktree clean after commit.
