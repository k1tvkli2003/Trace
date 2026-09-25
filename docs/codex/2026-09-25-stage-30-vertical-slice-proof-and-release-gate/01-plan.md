# Stage 30 implementation plan

## Approach
Use one offline tracer bullet. Seed a memory database with a Markdown source, hash-bound page/block/citation evidence, and a validated Persian lesson. Apply existing local state and review APIs. Reopen through `LocalReviewInboxRepository`, then persist and rehydrate one highlight and note. Keep live AI, sync, PDF rendering, and native execution outside this proof.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | active | Freeze scope and inspect repository contracts. |
| 2 | pending | Write one integration test before implementation. |
| 3 | pending | Run RED and record expected missing path. |
| 4 | pending | Add only missing production wiring, if any. |
| 5 | pending | Run GREEN, full suites, analyzer, formatter, docs validator. |
| 6 | pending | Record release-gate matrix and commit. |

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
