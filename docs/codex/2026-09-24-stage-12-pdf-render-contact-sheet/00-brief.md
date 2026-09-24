# Stage 12 bounded PDF render and contact sheet

- Task ID: `2026-09-24-stage-12-pdf-render-contact-sheet`
- Status: `done`
- Created: 2026-09-24
- Language: English

## Request
Implement the next Trace slice: bounded PDF thumbnail batches and labelled contact sheets. Keep OCR, Vision, and text-layer transcription out.

## Success Criteria
- Batches are ordered and capped at 8 pages.
- Source hash, pixel hash, render profile, and stable page ID survive checkpoint/resume.
- Forged or out-of-batch checkpoints fail closed.
- Contact sheets scale pages to fit without cropping and hash the PNG.
- Focused tests and analysis pass.

## Context
`PdfPageRasterizer` already renders BGRA8888 with pdfrx. Stage 11 provenance is committed. This slice stays inside the Flutter app.

## In Scope
- Batch worker, checkpoint, cancellation, and contact-sheet composition.
- Tests using a fake rasterizer plus the existing dummy PDF.

## Out of Scope
- OCR, Vision, source persistence, ZIP, sync, UI, and `StudyHub-Web`.

## Assumptions
- Resume may skip a page only when its stable ID is recomputed and matches the checkpoint. Pixel bytes are not re-rendered on resume in this slice.
