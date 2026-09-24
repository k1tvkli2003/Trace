# Plan

## Approach
Use strict test-first implementation: add focused failing persistence/provenance/migration tests, then make minimal domain and Drift changes while preserving atomic batch and hash guarantees.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Domain provenance fields, UTC-Z validation, JSON round-trip, origin map |
| 2 | done | Import provenance validation, persistence/readback, dedupe conflicts, re-import guard |
| 3 | done | Drift v10 columns, guarded migration, regenerated generated code |
| 4 | done | Real SQLite v9 upgrade/reopen regression |
| 5 | planned | Full tests, analysis, docs validation, commit |

## Interfaces and Artifacts
- `SourceDocument.fromJson/toJson`, `originMapFor`, `SourceImportItem`
- `LocalSourceImportRepository.importBatch/importOne/listForLibrary/readOriginal`
- `SourceEntries` v10 `modified_at`, `logical_role`, `exclusion_reason`
- `docs/contracts/source-manifest-v1.md`
- Focused and migration tests

## Risks
- Changed-input conflicts can silently lose metadata if provenance is not checked before writes.
- Migration code can break Stages 1-9 unless each regression remains green.
- Timestamp token normalization can break round-trip if parsed rather than preserved.

## Acceptance Checks
- `dart test` in both packages passes.
- `dart analyze lib test` clean.
- `git diff --check` clean.
- v9 fixture upgrades and reopens with original bytes and versions intact.
