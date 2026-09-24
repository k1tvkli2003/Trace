# Plan

## Approach
Add a small domain-level import manifest item and a data repository that validates every logical path, supported MIME/extension, byte cap, and hash before one Drift transaction. Reuse existing immutable `SourceEntries`; add `image` rows without introducing a second byte store. Keep archive members rejected until an audited adapter exists.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | completed | Define inventory contract and inspect existing source persistence. |
| 2 | completed | Add RED tests for image and deterministic batch behavior. |
| 3 | completed | Implement image repository and atomic batch import. |
| 4 | active | Run package/app verification and commit. |

## Interfaces and Artifacts
- `packages/trace_domain/lib/src/models/source_import_item.dart`
- `packages/trace_data/lib/src/local/local_source_import_repository.dart`
- `packages/trace_data/test/local_source_import_repository_test.dart`
- `docs/contracts/source-manifest-v1.md`

## Risks
- Existing `source_entries` version uniqueness is per library/name/version; batch import must calculate versions transactionally.
- Drift transaction callbacks must not call a second transaction through a public repository method.
- Images are evidence originals only; no image text is accepted as lesson text in this stage.

## Acceptance Checks
- Focused RED then GREEN tests.
- Full `trace_data` and `trace_domain` suites.
- `dart analyze lib test`, Flutter analyze, web build, `git diff --check`.
- No changes under `StudyHub-Web`.
