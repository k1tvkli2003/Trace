# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Two real RED gaps were verified before fixes: Dart accepted unsafe text and whitespace-only identities, and the JSON Schema accepted non-figure `figureId`. Both are now rejected by the updated constrained validators.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Keep Stage 18 limited to validator parity. | Prevent scope drift into model calls, migrations, or renderer changes. | Plan Stage 18 acceptance checks. |
| 2026-09-25 | Reject active markup and `javascript:`/`data:` text. | Renderer must stay inert and no raw executable lesson text is allowed. | Project non-negotiable rule. |
| 2026-09-25 | Reject whitespace-only identity and text values. | Nonblank identity/citation evidence is required. | Existing nonblank-ID model rules. |
| 2026-09-25 | Reject `figureId` on ordinary factual lesson blocks in all three validators. | Matches Dart behavior and preserves figure/explanation pairing. | RED schema test. |

## Blockers
- None

## Done
- Focused Dart regression tests and parser guard.
- Focused Python schema-parity regression tests and schema constraints.
- Full domain, gateway, and data checks rerun.
- Read-only review found no high-confidence blocker.
- Work docs and stage index finalized.

## Remaining
- Stage 19 teacher-fa capability contract work without live provider calls.
