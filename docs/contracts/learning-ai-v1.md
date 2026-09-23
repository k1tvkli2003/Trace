# Trace learning AI v1 — offline contract, not connected

Runtime owner: `services/ai_gateway/learning_contract.py`. Transport/provider adapter absent. All five stages below are **design + deterministic contract tests only**. No model output, PDF transcript, lesson, cost or accuracy has been proven. AI in Trace remains exclusively OpenCode Go if later enabled; no provider/model switch or implicit retry.

## Learning path and expected behavior

| Action | Bounded input | Proposed JSON result | Product behavior without a model |
|---|---|---|---|
| Scan structure | Up to 24 labelled page refs, opaque `contactSheetHandle` | `structure-proposal-v1`: ordered nodes with page ranges, confidence, reason, `needsReview` | Keep imported PDF as original; let user inspect page images; never claim approved tree |
| Read needed page | One raster page handle, source/pixel hashes, render profile, page ref | `page-extract-v1`: complete ordered paragraphs/tables/formulas/figures, bboxes, uncertainty and coverage | Show `Waiting for Vision`; text layer/OCR cannot stand in for transcription |
| Plan next slice | Current node plus authorized hash-bound blocks | `slice-plan-v1`: ordered block IDs, concept, boundary reason, lookahead, `nextVisionRequiredAt` | Show source outline for MD/TXT; no invented lesson or cursor |
| Teach slice | One slice ID, authorized blocks and figures, enum preferences | `lesson-ast-v1`: Persian typed blocks with source IDs and figure explanations | Source Reading opens verified MD/TXT with chapters, not a pretend lesson |
| Ask about slice | Question and only same-scope source blocks | `coach-answer-v1`: Persian answer, claim-level source IDs or abstention | Keep question draft; no speculative answer |

`review_generator_optional` and mutating agent tools are not part of this v1 envelope. Spaced repetition remains deterministic. Toolbar actions like Mark studied must be implemented as authenticated domain mutations, never assumed from model prose.

## Prompt envelope

`build_prompt(...)` emits `instructionVersion`, `outputSchema`, and exactly two role-separated messages. System content is reviewed policy + stage-specific instructions; user content is a structured object of task, sourceContext, figures and enumerated userPreference. Source/page content is data, not trusted instructions. `tone` = `warm|neutral`, `depth` = `compact|balanced|deep`, `emoji` = `off|moderate`, `examples` = `off|on`, `questions` = `off|one|two`. Free-form learner questions are permitted only for `coach` in the untrusted task object. Prompt is capped at 64 KiB serialized; gateway guard has separate 4 MiB input and 4,096 output-token safety caps. These byte limits are not tokenizer measurements.

Images **are not embedded by this module**: `asset_...` handles identify server-owned, hash-verified page/contact-sheet rasters. A future adapter must resolve them inside authorized server storage, recheck source/pixel hash, MIME, dimensions, page ownership and bounded bytes, then transmit image input in a modality the approved Go route actually supports. The handle is not a remote URL or model-readable page by itself. Never pass local file paths or arbitrary URLs from the task to provider. Schema strings for structure/page/planner/coach are output contract names only, **not yet JSON Schemas/validators**; their outputs must not be persisted or shown as authoritative until dedicated validators exist.

## Lesson AST v1

`docs/contracts/lesson-ast-v1.json` defines a flat first version. `validate_lesson` checks version, Persian language, exact requested slice, unique block IDs, allowlisted block types, bounded text, citation IDs in authorized source set and matching figure/figure_explanation pairs. It rejects HTML markup and arbitrary fields. No factual correctness inference or citation-quote matching yet; future source-span verification and user review must precede treating output as a lesson. AI cannot mutate DB, execute SQL, output raw HTML or fetch web content. Partial JSON and empty answers do not become artifacts. Prompt/schema changes require new version + cache invalidation; no silent rewrite.

## Experience and failure states

- Source Reader: verified original Markdown/TXT, chapter tree or mobile drawer, line locator and short source hash; clearly marked source-only. PDF cannot use it before page-image Vision.
- Future teacher UI: `not_ready` (Go unconfigured), `source_missing`, `waiting_for_page`, `planning`, `generating`, `validating`, `needs_source_review`, `ready`, `refused`, `invalid_output`, `failed`, `unknown_outcome`. Each state retains node/slice and existing cached artifact. Stop/cancel never marks success. No infinite spinner or automatic re-submission.
- Cached slice reopens without spending; Next Box uses persisted cursor and source coverage, not model memory. On missing page, show a resumable ingestion job rather than fake chapter text. Cost ledger records only actual provider usage after connection, not estimates as facts.
- Only server may authorize original, source blocks and figures, invoke a configured Go model, validate response, persist immutable artifact and return a receipt. No Go key in Flutter bundle; no live calls until configuration, workload terms and Vision behavior are independently verified. This constraint does not block offline UI and prompt-contract development.

Checks: `python -m unittest discover -s services/ai_gateway -p 'test_*.py' -v`, `dart test` in `packages/trace_domain`, `flutter test` and `flutter analyze` in `apps/trace_flutter`.
