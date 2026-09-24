# Plan

## Approach
Keep rendering behind the existing rasterizer. Add a bounded worker and a contact-sheet composer with fail-closed identity checks.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Contact sheet composer and focused tests |
| 2 | done | Batch worker, checkpoint, cancel, dummy PDF render |
| 3 | done | Reject forged IDs and pages outside the requested batch |
| 4 | done | Focused tests, analysis, task docs |

## Interfaces and Artifacts
- `PdfRenderBatchWorker.run`
- `PdfRenderCheckpoint`
- `stablePdfPageId`
- `PdfContactSheetComposer.compose`

## Risks
- A trusted checkpoint pixel hash is not a re-render. Forged stable IDs are rejected; forged pixel hashes of the right shape are not independently proven.
- Contact-sheet labels are not pixel-asserted.

## Acceptance Checks
- `flutter test --no-pub` on the two focused files passes.
- `dart analyze` on the new files is clean.
