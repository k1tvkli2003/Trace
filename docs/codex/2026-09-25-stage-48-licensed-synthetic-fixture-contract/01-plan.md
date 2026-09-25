# Plan

## Approach
TDD RED: one contract test that requires `test/fixtures/synthetic/manifest.json`, the named PDF and Markdown, matching SHA-256, page count 1, and expected source/figure strings. GREEN: generate the PDF with PyMuPDF from original text, write the Markdown twin and manifest, re-run until green. Docs close after local proof only.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | RED: `tool/test_synthetic_fixture_contract.py` failed because `test/fixtures/synthetic/` was absent |
| 2 | done | GREEN: original PDF + Markdown + `manifest.json`; contract 2/2 |
| 3 | done | Hashes, page count 1, expected strings, original license |
| 4 | done | State/progress/verification/handoff filled; matrix fixture row `SCAFFOLD` |

## Interfaces and Artifacts
- `test/fixtures/synthetic/trace-synthetic-lesson.pdf`
- `test/fixtures/synthetic/trace-synthetic-lesson.md`
- `test/fixtures/synthetic/manifest.json`
- `tool/test_synthetic_fixture_contract.py`
- `docs/codex/2026-09-25-stage-48-licensed-synthetic-fixture-contract/*`, `docs/codex/_index.md`, `docs/qa/acceptance-matrix.md`

## Risks
- Generating a PDF can drift byte-for-byte across PyMuPDF versions — mitigated by hashing the committed file and asserting that hash, not regenerating in the test.
- A synthetic page is not a textbook — mitigated by license text and by not claiming ingestion/Vision.

## Acceptance Checks
- Contract test fails RED before the fixture, passes GREEN after.
- Manifest SHA-256 matches file bytes; PDF page count is 1; expected strings are present.
- No third-party content; `validate_task_docs.py` OK; `git diff --check` clean.
