# State

- Current status: `done`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
RED passed (5/5 dirty IDs accepted pre-fix), GREEN applied in `_require_id`, full suite 62/62 OK. Feat `0c0da7b` landed (code + test + matrix + docs). Close commit remains.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Reuse `_UNSAFE`/`_CONTROL_TEXT` in `_require_id` plus `value != value.strip()` rejection | Same guards as text/caption; padded IDs are copy/hash hazards | repo evidence `page_extract.py` |

## Blockers
- None

## Done
- RED test `test_rejects_entity_ids_with_whitespace_control_or_markup` (5 subcases fail pre-fix as `ContractFailure not raised`)
- GREEN `_require_id` hardening
- Full gateway suite 62/62 OK

## Remaining
- Close commit
