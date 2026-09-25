# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Hermes

## Current State
`putNote` و `readNote` و tombstone موجود است ولی query معکوس backlink و export قابل‌انتقال وجود ندارد. تصمیم: متدهای فقط‌خواندنی `listNotesFor*` و export خالص note+locator، بدون migration.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | No schema change for Stage 28 | Existing `StudyNotes` already stores anchor/block/figure/lesson targets and UTC timestamps | trace_database.dart |
| 2026-09-25 | Deterministic order by updatedAt then id | Stable listing for review/export without device-clock authority | plan section 10 conflict rules |
| 2026-09-25 | Locator is display-only | Identity stays on IDs/hashes; locator never redefines the link | plan section 9 |

## Blockers
- None

## Done
- Task scaffold and scope boundary recorded
- Read-only `listNotesForAnchor` and display-only `exportNote` green

## Remaining
- Docs validation and commit
