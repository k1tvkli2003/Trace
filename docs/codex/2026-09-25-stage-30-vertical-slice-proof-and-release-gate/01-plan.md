# Stage 30 implementation plan

## Approach
Use one offline tracer bullet. Seed a memory database with a Markdown source, hash-bound page/block/citation evidence, and a validated Persian lesson. Apply existing local state and review APIs. Reopen through `LocalReviewInboxRepository`, then persist and rehydrate one highlight and note. Keep live AI, sync, PDF rendering, and native execution outside this proof.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Scope frozen; contracts inspected; proof committed in `339f1c3`. |
| 2 | done | Integration test written first: `offline_vertical_slice_test.dart`. |
| 3 | done | RED verified with temporary wrong-ID mutation (`TERMINAL_EXIT=1`); restored. |
| 4 | done | No missing wiring; no production files changed. |
| 5 | done | GREEN + full suites/analyzer/format/docs-validator recorded in `05-verification.md`. |
| 6 | done | Release-gate inventory recorded as open; matrix/runbook gaps point to Stage46 `9d17f88`, evidence unchanged. |

## Interfaces and artifacts
- Test: `packages/trace_data/test/offline_vertical_slice_test.dart`
- Source: `LocalTextSourceRepository`, `LocalSourcePageRepository`, `LocalSourceBlockRepository`, `LocalSourceCitationRepository`
- Lesson: `LocalLessonRepository.putLessonWithState` and `readArtifact`
- Learning: `LocalLessonRepository.applyStateAction`
- Review: `LocalReviewInboxRepository.openDue`
- Annotation: `LocalAnnotationRepository.putAnchor`, `putNote`, backlink reads
- Docs: this task folder and `docs/codex/_index.md`

## Risks
- Existing APIs may expose lower-level contracts than the acceptance sequence assumes; test failure must identify the first missing wire.
- Direct Markdown proof does not prove PDF Vision fidelity or live AI route compatibility.
- Existing worktree may contain task-doc changes only; preserve unrelated user changes.

## Acceptance checks
- RED exit is nonzero because the new proof is not yet satisfied, not because of a test syntax error.
- GREEN targeted test passes.
- Full data/domain/app/Gateway suites pass where runnable.
- `flutter analyze --no-pub` and format checks pass where runnable.
- Docs validator and `git diff --check` pass.
- Final report separates verified offline evidence from unverified release surfaces.
