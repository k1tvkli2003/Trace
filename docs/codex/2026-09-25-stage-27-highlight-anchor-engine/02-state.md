# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Hermes

## Current State
موتور rehydration در دامنه و repository پیاده و سبز است: evaluator مرتبه‌ای، `rehydrateAnchor` فقط‌خواندنی و `markDetached` صریح بدون migration. suite و analyze و format پاس؛ فقط docs validation و commit مان...[truncated]

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | No schema change for Stage 27 | Existing anchor table already stores quote/prefix/suffix/offsets/bbox/hash | trace_database.dart |
| 2026-09-25 | Whitespace-only Persian matching | Plan section 9 forbids silent moves; Yeh/Kaf rewrite is out of scope | plan section 9 |
| 2026-09-25 | Rehydrate is read-only; detach is explicit | Silent moves are forbidden; repair needs visible state | plan section 9 |

## Blockers
- None

## Done
- Task scaffold and scope boundary recorded
- Domain ladder and repository rehydrate/detach implemented and green

## Remaining
- Docs validation and commit
