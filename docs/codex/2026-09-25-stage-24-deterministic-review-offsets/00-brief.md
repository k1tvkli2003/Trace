# Stage 24 deterministic review offsets

- Task ID: `2026-09-25-stage-24-deterministic-review-offsets`
- Status: `ready-for-review`
- Created: 2026-09-25
- Language: en

## Request
Continue Trace toward deterministic review scheduling. This slice fixes the existing repository's interval/offset confusion and adds an explicit first-study schedule constructor, without AI calls. Original plan requires review milestones +1, +3, +7, +15, +30 days from the first studied instant, not cumulatively added offsets.

## Success Criteria
- First study at UTC instant A yields due A+1 day.
- On-time completed reviews land at A+3, A+7, A+15, A+30; late reviews retain one due event, with next due based on actual review instant and the difference between milestones.
- `again` resets to +1 day; `hard` holds current gap; `easy` moves ahead one extra milestone. At/after final milestone policy is explicit and deterministic.
- Same event ID replays safely; rejected events never partly mutate item or event log.
- Existing review API tests and package suites pass; no model or network calls.

## Context
Existing `LocalReviewRepository` uses [1,3,7,15,30] as successive intervals. That makes on-time review milestones cumulative (A+1, A+4, A+11...) contrary to product contract. ReviewItem and ReviewEvent already exist in Drift with immutable initial receipt and append-only event log.

## In Scope
- Versioned deterministic scheduling plus repository integration for new version; preserve v1 behavior of already-persisted items.
- Clock-controlled unit and local Drift tests; documentation and verification.

## Out of Scope
- Footer/UI action wiring and scheduler creation from the Stage 23 state transaction (future vertical integration), snooze/reset UI, sync, notifications, network, AI.
- Changes to protected `StudyHub-Web`.

## Assumptions
- Day means exactly 24 hours in UTC; local timezone only formats due time.
- New v2 items are constructed from the first-study instant; their immutable creation receipt preserves initial due (+1). No separate anchor field is stored; later gap calculations use actual review time. Hard/again intentionally shift subsequent due dates.
- Existing v1 rows remain readable/replayable under their original policy, never silently reinterpret schedules.
