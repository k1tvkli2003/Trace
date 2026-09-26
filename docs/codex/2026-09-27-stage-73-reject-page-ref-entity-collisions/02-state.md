# State

- Current status: `active`
- Last updated: 2026-09-27T00:13:36
- Owner: Codex

## Current State

RED probe reproduced three real page-ref collision holes in `validate_page_extract`: a block ID equal to `pageRef`, a `kind: figure` block whose ID equals `pageRef`, and a figure ID equal to `pageRef` are all accepted. A new failing test `test_rejects_entity_id_colliding_with_page_ref` was written first and confirmed failing. The validator was then patched with `ENTITY_ID_COLLIDES_PAGE_REF` checks in the owning file only; the full gateway suite is now 65/65. Numeric coercion (`'1'` vs `'01'`), unicode casefold siblings (`B1`/`b1`, `I`/`ı`, NBSP/ZWSP inside IDs) and schema-compatible page-ref variants (`PAGE-1`, `1`, fullwidth) remain intentionally accepted: they are distinct opaque IDs in separate namespaces and the local Dart vision cache already binds them by exact page identity (`pageRef == 'page-<pageNumber>'`, SHA-256 source/pixel hashes).

## Decisions

| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-27 | Stage73 scope = page-ref/block/figure collision only; numeric/casefold variants stay accepted | Only the page-ref collisions violate a consumer or namespace invariant; numeric-string and case-variant IDs are opaque identifiers with exact-match dependents | probe output, `local_vision_cache_repository.dart` |
| 2026-09-27 | New error code `ENTITY_ID_COLLIDES_PAGE_REF`, separate from `FIGURE_ID_COLLIDES_BLOCK_ID` | Page-ref collision is a distinct cross-layer identity confusion, matching the Stage55 three-code precedent | repo convention |
| 2026-09-27 | Failing test written before the validator patch | TDD iron law; the test was observed failing with `ContractFailure not raised` before the fix | test run output |

## Blockers

- None for Stage73 scope.

## Done

- Stage73 task docs scaffolded with `_index.md` row.
- Probe reproduced: `block-id-equals-pageRef ACCEPTED-HOLE`, `figure-block-id-equals-pageRef ACCEPTED-HOLE`, `figure-id-equals-pageRef ACCEPTED-HOLE`; control case accepted correctly.
- RED test added and confirmed failing.
- Validator patched GREEN: full gateway suite 65 tests OK.
- Matrix gateway row updated to 65.

## Remaining

- Fill `04-progress.md`, `05-verification.md`, `06-handoff.md` and mark state/index `done`.
- Validate task docs, `git diff --check`, then feat/close commits.
