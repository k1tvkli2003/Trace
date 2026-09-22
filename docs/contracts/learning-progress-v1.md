# Trace learning progress contract — design only

Status: **proposed, not implemented**. Scope: personal, private feedback derived from actual learning evidence. Stage 23 owns learner-state mutation, Stage 24 owns deterministic review scheduling, Stage 25 owns cached replay; this document does not move those stages or add a new production dependency.

## Principle and source of truth

Learning is not a currency. A lesson tap, app-open, passive reading time, repeated easy replay, AI generation, upload, or streak day is **not** evidence of mastery. Worktree progress and recap are projections of `LearnerState`, immutable `LessonArtifact`, append-only `ReviewEvent` and, only if later assessment exists, a validated answer/correction event. Due is a `ReviewItem` projection, never a replacement for `STUDIED`. `MASTERED` needs an explicit, versioned rule; a single “مسلطم” tap represents learner confidence, not independently verified mastery.

| Input | Qualification | Visible response | Excluded inference |
|---|---|---|---|
| `lesson_studied` | First idempotent `STUDIED` transition for a specific slice/artifact | “Studied” and upcoming review dates | No award, XP or automatic understanding |
| `concept_understood` | Explicit learner self-report bound to concept and source-linked slice | Confidence marked **self-reported** | No verified mastery or hidden score |
| `review_completed` | Answer/rating to due target, bound to ReviewEvent ID and artifact | New due date computed by scheduler; reviewed marker | Reopening cached box alone is not completion |
| `mistake_corrected` | Earlier recorded incorrect answer then new valid answer to same target; maintain both receipts | Quiet “corrected” milestone after evidence exists | Tapping retry or model praise is not correction |
| `not_learned` | Explicit learner action, no negative value | Clear remediation affordance and earlier due date | Never punishment, lost points or shame copy |
| `mastery_verified` | **Deferred** until assessment criteria, source trace and delayed review are implemented and tested | Factual mastery milestone | `STUDIED`/self-report alone cannot emit it |

Each input has `eventId`, `ownerId`, `targetType`, `targetId`, `artifactVersion`, `occurredAtUtc`, `deviceId`, `idempotencyKey`, `ruleVersion`, and causal `sourceEventId` when applicable. No raw book text in event payload. Durable storage/sync schema belongs to stages 7–8/28; names here are contracts, not existing tables.

## Local-first derivation and sync

1. Stage 23 validates authorized action and target against existing library, appends an immutable event and updates local projection in **one** transaction. UI renders accepted local receipt, not guessed success.
2. Stage 24 scheduler reads same `ReviewEvent` history; first studied anchor is `firstStudiedAtUtc`, with +1/+3/+7/+15/+30-day ladder and versioned late-review rules. Gamification never modifies `dueAt` or review rating.
3. Sync stage merges append-only events by stable `eventId` and `idempotencyKey`, with server owner checks. Duplicate device replay yields one event and one projection. `occurredAtUtc` is for learning-time display, not server mutation ordering. Conflict/undo uses an explicit compensating event; never silently delete history.
4. Rebuild projections from sorted canonical events plus rule version. Local-only “milestone” is provisional until sync; never show competitive awards or assert server-verified knowledge.
5. Quarantine malformed, missing-target or unauthorized events; do not turn them into progress. Log hashes/IDs and failure codes only, not private source payload.

## Experience scope

- **Progress spine:** existing Knowledge Worktree; states `not started`, `in progress`, `studied`, `review due`, `self-reported understood` and future `verified mastered`. Explain what each means. No locked paid nodes or decorative boss gates.
- **Session feedback:** quiet receipt with citation and next real action; wrong answers lead to explanation and retry without penalty. `NOT_LEARNED` stays actionable.
- **Recap:** optional non-blocking summary after a meaningful completed review session: actual slices studied, reviews completed, concepts corrected, next due date. No timer, combo or XP counter. Cached replay costs no AI call.
- **Optional goals/achievements:** deferred until learning loop exists; if added, weekly self-set goals or delayed recall/correction milestones only, derived from distinct targets with idempotent rules and no expiry penalty. No daily quest pressure.
- **Economy, chests, energy/hearts, league/social, paid power-ups, mascot performance and daily streak:** deliberately **out of MVP**. One private learner has no reason for leaderboards or arbitrary currencies; no disabled essential learning path.
- **Motion/identity:** selected Trace icon remains unchanged; tiny non-essential progress-state transitions only. Reduced-motion and no-motion paths show same semantic text. No visual celebration unless real event and accessible fallback are proven on Android/Windows/Web.

## Rule-and-test matrix for later stages

| Rule | Idempotency and cap | Failure/abuse case to test | Owner |
|---|---|---|---|
| First studied receipt | Unique `(ownerId, sliceId, firstStudiedAt event)`; repeat view does nothing | Offline replay twice from two devices; regenerated artifact version | Stage 23/28 |
| Review completion | Unique review action ID; state from append-only event | Double tap, late due, timezone change, stale device | Stage 24/28 |
| Corrected mistake | Causal incorrect event + distinct verified follow-up | Repeated button tap, wrong target, undo/correction order | After assessment exists |
| Self-reported understanding | Last explicit self-report, no mastery award | Conflicting offline confidence, rollback | Stage 23/28 |
| Recap projection | Derived only, no mutation or AI call | Duplicate event, source page missing, offline | Stage 25 |

Required tests later: event replay yields identical projection, duplicate operation no duplicate progress, false self-report cannot unlock verified mastery, browser refresh restores local state, reduced-motion/keyboard/screen-reader state text, and mismatched library ownership rejected. No tests in this stage because models/repositories do not yet exist.

## Reuse and verification limit

`Trace` is Flutter, not React/Next/Tailwind. Do not copy the Duolingo clone's components, XP weights, mascot or palette; no code reused, no attribution needed. Skill's richer blueprint is deliberately scoped down to source-backed individual study. This is a **product rule document**, not functioning gamification, a stored event ledger, a proved sync flow or a shipped UI.
