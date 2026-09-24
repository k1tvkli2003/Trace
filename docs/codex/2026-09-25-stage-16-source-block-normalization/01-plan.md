# Plan

## Approach
Add one pure domain helper that constructs validated `SourceBlock` JSON with only line- and space-level cleanup. Do not add AI, persistence, or Markdown rewriting.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Failing RTL/table/formula/cross-page tests |
| 2 | done | `SourceFragment` and `normalizeSourceBlocks` |
| 3 | done | Domain suite, analyze, docs |

## Interfaces and Artifacts
- `normalizeSourceBlocks(documentId, pageId, version, sourceHash, fragments)`
- `SourceFragment(kind, text, bbox, continuesFromBlockId)`

## Risks
- `continuesFromBlockId` is not stored in `SourceBlock`; cross-page relation must be persisted in a later stage, not inferred from this helper.
- `unknown` fragments fail closed; caller must quarantine them before normalization.
- This is a domain helper, not a wired ingestion path or a real Vision run.

## Acceptance Checks
- `dart test` in `packages/trace_domain`
