# Stage 14 vision page extraction

- Task ID: `2026-09-24-stage-14-vision-page-extraction`
- Status: `done`
- Created: 2026-09-24
- Language: English

## Request
Validate `page_vision_extract` output as strict `page-extract-v1` JSON: complete ordered blocks, normalized boxes, figures tied to blocks, uncertainty, and coverage. One hash-bound raster page only. No OCR, no PDF text layer, no live model call.

## Success Criteria
- Runtime validator and JSON Schema agree.
- Accepted extract matches caller sourceHash, pixelHash, render profile, and page ref.
- Only `coverage: complete` passes. Partial or guessed pages fail.
- Unknown/low-confidence content stays quarantined as `unknown` with empty text.
- Figure entries must reference an existing block; figure-kind blocks must have a figure record.
- Extra provenance fields and HTML payloads fail.
- Gateway suite stays green. No network call.

## Context
`learning_contract.py` already builds the offline envelope for `page_vision_extract`. Stage 13 added the structure validator. Page, planner, and coach outputs were unvalidated; this stage validates page output only.

## In Scope
- `docs/contracts/page-extract-v1.json`
- `services/ai_gateway/page_extract.py`
- `services/ai_gateway/test_page_extract.py`
- Task docs

## Out of Scope
- Live Vision call
- Persisting SourceBlock/FigureAsset rows
- OCR, text-layer transcription, lesson AST
- Flutter UI

## Assumptions
- Low-confidence threshold is 0.5. Below it requires `uncertain: true`.
- One validated extract covers exactly one rendered page.
