# Stage 11 immutable source manifest and provenance

- Task ID: `2026-09-24-stage-11-immutable-source-manifest`
- Status: `active`
- Created: 2026-09-24
- Language: English

## Request
Implement the next concrete Trace slice: immutable source manifest/provenance contract, domain model, persistence, tests, and verification. Preserve Stage 10 import guarantees. Do not touch `StudyHub-Web`.

## Success Criteria
- Source manifest captures hash-bound identity, path, size, MIME, modification time, logical role, and exclusion reason.
- Original bytes remain immutable and changed bytes create a new revision.
- Provenance survives persistence, migration, replay, and readback.
- Invalid or conflicting batch input fails before writes.
- Focused and full package tests plus analysis pass.

## Context
Trace uses Flutter/Dart/Drift local-first persistence. OCR, archive extraction, Vision, AI, sync, and ingestion worker implementation are outside this stage.

## In Scope
- `SourceDocument` and `SourceImportItem` provenance fields.
- Drift v10 source provenance columns and generated code.
- Local import validation, persistence, replay, conflict handling, and origin map.
- Contract and migration tests.
- Source manifest documentation.

## Out of Scope
- ZIP extraction, PDF rendering, OCR, Vision, AI, sync, UI, and `StudyHub-Web`.

## Assumptions
- `modifiedAt` is metadata, not identity. Accepted wire timestamps are UTC ISO-8601 tokens ending in `Z`.
