# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Hermes (single model)

## Current State
RED failed on missing `test/fixtures/synthetic/manifest.json` (`FileNotFoundError` + failed existence assert). GREEN passed 2/2 after an original one-page PDF, Markdown twin, and SHA-256 manifest were written. No ingestion, Vision, or textbook claim.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Original one-page synthetic PDF plus Markdown twin, hashed in `manifest.json` | Close the fixtures-beyond-placeholder gap without third-party content | Stage46 matrix row; local RED→GREEN |
| 2026-09-25 | Body sentence kept short enough to stay one PDF line | First draft wrapped and dropped the tail, so the expected string would not match extracted text | PyMuPDF `get_text()` on the first PDF |
| 2026-09-25 | Matrix fixture row moves to `SCAFFOLD`, not passed | Contract proves files and hashes only; no ingestion or Vision run | Stage48 brief |

## Blockers
- None.

## Done
- RED: contract failed because the synthetic fixture was absent.
- GREEN: `trace-synthetic-lesson.pdf`, `trace-synthetic-lesson.md`, `manifest.json`; contract 2/2.
- License text declares original synthetic content.

## Remaining
- None for this slice. Ingestion, Vision, and a real authorized textbook stay out of scope.
