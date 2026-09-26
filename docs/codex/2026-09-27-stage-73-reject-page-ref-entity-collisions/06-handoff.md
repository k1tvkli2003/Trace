# Handoff

## Outcome

`validate_page_extract` now rejects any block or figure ID equal to the page's own `pageRef` with `ENTITY_ID_COLLIDES_PAGE_REF`. Three reproduced holes close; intentionally accepted classes (numeric-string variants, unicode casefold variants, schema-compatible page-ref values) are recorded as non-defects because exact-match consumers already bind them by page identity.

## Changed Artifacts

- `services/ai_gateway/page_extract.py` — block set vs `pageRef` guard plus figure-ID vs `pageRef` guard.
- `services/ai_gateway/test_page_extract.py` — `test_rejects_entity_id_colliding_with_page_ref`.
- `docs/qa/acceptance-matrix.md` — gateway row 64→65, Stage73 note.
- `docs/codex/2026-09-27-stage-73-reject-page-ref-entity-collisions/*`, `_index.md`.

## How To Continue

- Verify with `python -m unittest discover -s services/ai_gateway -p 'test_*.py'` (expect 65).
- Next open probe remainder: none from this class; pick the next unproven gate (live-AI pilot, release builds, device/browser smoke).

## Done

- RED test, minimal fix, full GREEN suite, matrix refresh, docs.

## Remaining

- None for Stage73; mark task `done` and commit.

## Verification

- Gateway 65/65 OK, page-identity repository 2/2 OK, post-fix probe closes all three holes, `git diff --check` clean.
