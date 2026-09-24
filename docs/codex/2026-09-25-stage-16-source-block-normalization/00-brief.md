# Stage 16 source block normalization

- Task ID: `2026-09-25-stage-16-source-block-normalization`
- Status: `done`
- Created: 2026-09-25
- Language: English

## Request
Turn Vision fragments or parsed Markdown fragments into canonical `SourceBlock` values. Mechanical whitespace shaping only.

## Success Criteria
- Reading order preserved through fragment order.
- Persian/Latin glyphs, table pipes, and formula symbols kept verbatim.
- Cross-page paragraphs keep distinct page locators and are never silently merged.
- Raw wording is always retained in `rawText`.
- Unsupported kinds, HTML tables, bad hashes, and empty identities fail closed.

## Context
`SourceBlock` and the local block repository already exist. No mechanical bridge from Vision/page fragments to `SourceBlock` values existed.

## In Scope
- `SourceFragment` input shape
- `normalizeSourceBlocks`
- Domain tests for RTL/LTR, tables, formulas, cross-page text, and rejection

## Out of Scope
- OCR or PDF text-layer transcription
- Planner, teacher, or live Vision calls
- Markdown structural parsing beyond the existing outline
- Persistence migration

## Assumptions
- Caller has already validated the page extract or verified Markdown source.
- Block IDs are `pageId-v<version>-<index>` inside one call; conflicting replay is rejected by persistence.
- `continuesFromBlockId` is an unused input hint in this domain-only helper; cross-page linking is not persisted by this stage.
