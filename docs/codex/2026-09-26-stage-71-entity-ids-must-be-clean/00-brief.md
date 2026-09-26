# Stage 71 entity IDs must be clean

- Task ID: `2026-09-26-stage-71-entity-ids-must-be-clean`
- Status: `done`
- Created: 2026-09-26
- Feat commit: `0c0da7b`
- Language: en

## Request
Tighten `_require_id` in `services/ai_gateway/page_extract.py` so block, figure, and page IDs cannot smuggle control characters, HTML/URI-scheme payloads, or surrounding whitespace. Reuse the existing `_CONTROL_TEXT` and `_UNSAFE` guards already applied to block text and captions.

## Success Criteria
- New failing test first: padded/control/HTML IDs rejected with `INVALID_BLOCK_ID` / `INVALID_FIGURE_ID` / `INVALID_PAGE_REF`.
- After fix: page suite 15/15, gateway suite 62/62, `validate_task_docs.py --structure-only` OK, `git diff --check` clean.
- Feat + close commits land; status `done`.

## Context
Probes on HEAD `125c6be` accepted `id=' b2 '`, `id='b<NUL>2'`, `id='<b>b2'` (`ACCEPTED-HOLE` x3). Text/caption already reject these classes; IDs never got the same guards.

## In Scope
- `_require_id` hardening + tests in `test_page_extract.py` + Stage71 task docs + `_index.md` row.

## Out of Scope
- Contract JSON change; confidence/uncertain semantics (probed, accepted, left alone: `uncertain=True` + high confidence is legal low-risk metadata).
