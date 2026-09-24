# State

- Current status: `ready-for-review`
- Last updated: 2026-09-24
- Owner: Codex

## Current State
Stage 11 slice is implemented but not committed. Provenance is validated pre-transaction, persisted and read back immutably, conflicting provenance rejects batches and re-imports, origin map is sorted latest-revision, and v9 data upgrades to v10 while preserving original bytes.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-24 | `modifiedAt` is metadata, not hash or revision identity | Changing timestamp alone must not rewrite an immutable source | explicit assumption |
| 2026-09-24 | Duplicate `(path, hash)` with different provenance fails | First-wins would silently keep arbitrary metadata | failing focused tests |
| 2026-09-24 | Re-import with changed provenance fails instead of updating the row | Same-hash re-import must be idempotent or rejection, not mutation | failing focused test |
| 2026-09-24 | Preserve exact accepted `modifiedAt` token | Normalization would break JSON round-trip | domain regression tests |

## Blockers
- None.

## Done
- Domain and persistence provenance fields and contract tests.
- Local source provenance validation, deterministic ordering, and persistence/readback.
- Drift v10 columns with regenerated code and guarded migration.
- Real SQLite v9 upgrade and reopen test.
- Source manifest contract documentation.

## Remaining
- Commit Stage 11 and record clean-worktree proof.
