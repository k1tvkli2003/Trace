# Stage 10 archive-safe import inventory

- Task ID: `2026-09-24-stage-10-archive-safe-import-inventory`
- Status: `active`
- Created: 2026-09-24
- Language: English

## Request
Continue StudyForge implementation. Take next concrete step: Stage 10 import UX and archive-safe inventory for PDF, Markdown, TXT, folders, and supported independent images.

## Success Criteria
- Supported source files receive deterministic, hash-bound inventory entries.
- Unsupported formats and unsafe paths fail closed before persistence.
- Batch imports preserve originals, deterministic ordering, duplicate identity, and partial-failure truth.

## Context
Trace already has immutable PDF/TXT/Markdown repositories and Drift v9. PDF text extraction/OCR remains forbidden. `StudyHub-Web` is reference-only and must not change.

## In Scope
- Domain import inventory contract.
- Local repository support for image originals and deterministic batch inventory/import.
- Tests for image, ordering, duplicate, unsupported, traversal, and atomic failure behavior.
- Documentation and verification.

## Out of Scope
- ZIP extraction or archive ingestion; this slice defines safe rejection until a later audited adapter.
- Folder picker UI and platform-specific directory APIs.
- Vision, OCR, PDF rendering, sync, and AI gateway.

## Assumptions
- Imported images are PNG/JPEG and are stored as immutable original bytes, pending page Vision.
- Folder inventory input arrives as logical relative paths plus bytes from a future platform adapter.
- One bad item fails the batch atomically; no silent partial import.
