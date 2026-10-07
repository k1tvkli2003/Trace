# Harrison smoke receipt — pages 1-3 only, CANDIDATE_ONLY

Date: 2026-10-07. Scope: bounded first-pages smoke. No full-PDF claim.

## Source binding
- Source: `Harrison Part 06 - Disorders of the Cardiovascular System.pdf`
- source_sha256: `6bad55a2df78962c541141c6cf46e147195826e2d6bb9ce1b77b4ae8ed389327`
- pdf_pages: 358. Pages covered here: 3 of 358 (`page-0001`, `page-0002`, `page-0003`).
- Candidate root: `C:/Users/K1/AppData/Local/hermes/cache/scratch/harrison-smoke/_staging/native-candidates/part06/`

## Hash verification (live, this turn)
- Checked 6 artifacts per page: `blocks.json`, `candidate.md`, `native.txt`, `poppler-layout.txt`, `source.png`, `words.json`.
- Result: 18/18 `OK`. `FAILS: 0`.
- Status stays `CANDIDATE_ONLY`. Flags stay open: `PENDING_MANUAL_REVIEW`, `VISUALS_REQUIRE_RENDER_AND_FIGURE_AUDIT`, `HIGH_RISK_TOKENS_REVIEW`.

## Visual box check (pages 1-3 vs source.png renders)
- Page 1: render headings match candidate order: `Disorders of the Cardiovascular System` / `PART 6` / `Section 1 Introduction to Cardiovascular Disorders` / `Approach to the Patient with Possible Cardiovascular Disease` / `THE MAGNITUDE OF THE PROBLEM` / `NATURAL HISTORY`. No mismatch found in first-four ordering.
- Page 2: render starts mid-chapter with `TABLE 243-1 New York Heart Association Functional Classification`, then running text numbered `3.` / `4.`, then `PART 6 Disorders of the Cardiovascular System` folio mid-page. Candidate preserves same order; table split across columns retained as text candidate only. No promotion to reviewed table.
- Page 3: render starts mid-sentence on echocardiography, then `PITFALLS IN CARDIOVASCULAR MEDICINE` (numbered 1-3), then `DISEASE PREVENTION AND MANAGEMENT`. Candidate matches same order. No figure promotion; image objects remain inventory only.
- Mismatch ledger: none found for heading order on pages 1-3. Layout fidelity of the NYHA table and hyphenated line breaks remains unverified; figures/crops not promoted.

## App gates verified this turn
- Flutter: `flutter test test/chat_shell_test.dart test/ai_route_test.dart` -> `+17 All tests passed`.
- Gateway: `python -m unittest discover -s . -p test_*.py` in `services/ai_gateway` -> `Ran 138 tests OK`.
- Repo: `master`, log `4bbb5df`. Dirty slice: `chat_workspace.dart`, `main.dart`, `pubspec.yaml`, `pubspec.lock`, `chat_shell_test.dart` + untracked `ai_route.dart`, `ai_route_live.dart`, `ai_route_test.dart`, `work/`.

## Explicit limits
- No reviewed transcription. No import/display/question/save/resume proof yet.
- No signed Windows/Web/Android artifact in this receipt.
- DB/host resume with same account remains unproven.
- Chat send stays truthfully disabled: no chat thread/message repository exists yet, so `chat-send` has `onPressed: null` instead of a fake empty handler.
