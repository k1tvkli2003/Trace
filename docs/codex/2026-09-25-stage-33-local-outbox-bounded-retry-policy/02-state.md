# State

- Current status: `done`
- Last updated: 2026-09-25
- Owner: Hermes

## Current State
Bounded local retry policy is GREEN in `LocalOplogRepository`: `requeueFailed(id, {maxRetries = 5})` enforces the budget, exhausted rows stay `failed` as dead-letter, and pure `canRequeue` answers eligibility without a DB hit. Full data (122) / domain (114) / app (41) / Gateway (50) suites pass; analyzers, format, validator clean. Docs ready for review.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-25 | Bound retries locally with `maxRetries` default 5, dead-letter = stays `failed` | Smallest coherent cut before transport; exhausted rows need operator signal without clock/backoff | Stage32 handoff |
| 2026-09-25 | Pure `canRequeue` predicate alongside DB transition | Workers/UI can check eligibility without a DB round-trip | Plan review |
| 2026-09-25 | No `DateTime.now()`, no backoff, no migration | Deterministic budget only; delay policy is a later stage | Non-negotiable determinism |
| 2026-09-25 | Existing no-arg `requeueFailed(id)` calls keep compiling under default budget 5 | Optional named parameter avoids breaking Stage31 callers; behavior change is tested | Regression check |
| 2026-09-25 | Leave `StudyHub-Web` untouched | Protected reference-only constraint | Project memory |

## Blockers
- None.

## Done
- Stage32 committed as `be22ee3`.
- RED retry-policy test observed (missing `maxRetries`/`canRequeue` API).
- Bounded `requeueFailed` + `canRequeue` implemented, no migration.
- Focused 4/4 GREEN; data 122, domain 114, app 41, Gateway 50.
- Analyzers clean; format 0 changed after fix; diff check clean.

## Remaining
- None for this record; slice committed in `7ad54cc` ancestor of HEAD. Backoff/transport/RLS/Storage/background/CI remain later stages.
