# Stage 48 licensed synthetic fixture contract

- Task ID: `2026-09-25-stage-48-licensed-synthetic-fixture-contract`
- Status: `done`
- Created: 2026-09-25T23:32:28
- Language: en

## Request
Add one original, license-declared synthetic PDF plus a matching Markdown twin under `test/fixtures/`, with expected source/figure evidence and a SHA-256 manifest. Close the Stage46 "fixtures beyond placeholder" gap without claiming a real textbook, OCR, Vision, or ingestion runtime.

## Success Criteria
- `test/fixtures/synthetic/` holds an original PDF, a Markdown twin, and `manifest.json` with SHA-256 of both files plus expected page/source/figure facts.
- A contract test fails before the fixture exists and passes after, asserting hash, page count, and the declared expected strings.
- License text states the fixture is original synthetic content, not a third-party work.
- Acceptance matrix fixture row moves off `MISSING` only to `SCAFFOLD` (contract exists; no ingestion/Vision run).

## Context
Repo `C:/Users/K1/Desktop/Projects/Trace`, branch `master`. `test/fixtures/` holds only `README.md`. Stage46 matrix marks fixtures `MISSING`. Stage47 CI is `done` as `SCAFFOLD (unrun)`. Umbrella stays `active`.

## In Scope
- One synthetic PDF generated locally with PyMuPDF from original text written for this repo.
- One Markdown twin of the same original text.
- `manifest.json` with license, hashes, page count, expected strings, figure note.
- One RED→GREEN contract test.
- Stage48 task docs + `_index.md` row + matrix row update.

## Out of Scope
- Any third-party textbook, scan, or copyrighted page.
- OCR, Vision, live AI, ingestion worker, lesson generation, sync, auth, benchmarks, E2E, CI run claims.
- `StudyHub-Web` touch, provider/model change, Flutter/SDK installs.

## Assumptions
- PyMuPDF 1.28.2 is already importable in the local Python 3.11 used for tests; no new package install.
- "Licensed synthetic" means an explicit original-work declaration in the manifest, not a third-party license grant.
