# Stage 13 structure scan and tree proposal

- Task ID: `2026-09-24-stage-13-structure-scan-and-tree-proposal`
- Status: `done`
- Created: 2026-09-24
- Language: English

## Request
Validate structure-scan output as strict JSON: ordered candidate nodes, page ranges, confidence, reason, and needsReview. Input is page refs plus an opaque contact-sheet handle only. No lesson text, no transcription, no OCR, no live model call.

## Success Criteria
- `structure-proposal-v1` JSON Schema and runtime validator agree.
- Heading proposals with nested ranges pass.
- Low-confidence or ambiguous spans without `needsReview` fail closed.
- Foreign pages, overlaps, unknown parents, extra lesson fields, and non-object payloads fail.
- Mixed Persian/English titles and injected instruction text stay untrusted data.
- Existing gateway tests still pass. No network call.

## Context
Stage 12 committed contact-sheet rasters at `5d70ac3`. `learning_contract.py` already builds the `structure_scan` envelope (`structure-proposal-v1`) but does not validate model output. `KnowledgeNode` in domain is the later persisted tree, not this untrusted proposal.

## In Scope
- `docs/contracts/structure-proposal-v1.json`
- `services/ai_gateway/structure_proposal.py`
- `services/ai_gateway/test_structure_proposal.py`
- Task docs

## Out of Scope
- Live Vision or structure_scan model call
- Persisting an approved tree
- OCR, text-layer transcription, lesson AST
- Flutter UI for the proposal

## Assumptions
- Page numbers in `sourceRange` are 1-based and bounded by the caller `page_count`.
- Sibling ranges under the same parent must not overlap. Nested child ranges must sit inside the parent range.
- Confidence below 0.5 requires `needsReview`.
