# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Hermes

## Current State
`PdfRenderBatchWorker` با checkpoint/resume مرزی موجود است ولی قرارداد capability و adapter ندارد. `listDueItems` منبع due است. این slice فقط قرارداد خالص + آداپتر foreground-only + resume خالص می‌سازد؛ هیچ پلاگین native تازه‌ای اضافه نمی‌شود.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | No new native plugin in Stage 29 | Windows host ATL-blocked for notification/secure-storage plugins; Web cannot deliver after close | docs/architecture/dependency-decisions.md |
| 2026-09-25 | Due query stays source of truth | In-app Review Inbox is the only proven due surface | Stage 26 handoff |
| 2026-09-25 | Resume decides only from hash-bound checkpoint | `PdfRenderBatchWorker` already fails closed on mismatch | apps/trace_flutter/lib/pdf_render_batch_worker.dart |
| 2026-09-25 | No schema change | No new Drift table needed for decision-only slice | trace_database.dart schemaVersion 11 |

## Blockers
- None for this slice; real OS scheduling/permission/PWA proofs remain out of scope.

## Done
- Task scaffold and scope boundary recorded
- Domain contract and app adapter implemented behind failing-first tests

## Remaining
- Docs validation, `git diff --check`, commit, clean worktree
