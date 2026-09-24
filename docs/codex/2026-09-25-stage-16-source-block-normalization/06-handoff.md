# Handoff

## Outcome
Fragments can become ordered SourceBlocks with raw wording preserved and only whitespace shaped.

## Changed Artifacts
- `packages/trace_domain/lib/src/models/source_block_normalization.dart`
- `packages/trace_domain/lib/trace_domain.dart` (exports the helper)
- `packages/trace_domain/test/source_block_normalization_test.dart` (7 focused tests)

## How To Continue
- Next is the slice planner and cursor, Stage 17.

## Done
- Hash-bound SourceBlock normalization

## Remaining
- None

## Verification
- Domain: 87/87 passed, exit 0. Data: 77/77 passed, exit 0. Analyze clean. Docs validation OK.
- This is a domain-only helper; the render → Vision → review ingestion path and cross-page linking remain open for Stage 17.
