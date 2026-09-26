# Stage 73 page-ref and residual ID-namespace probe

- Task ID: `2026-09-27-stage-73-reject-page-ref-entity-collisions`
- Status: `done`
- Created: 2026-09-27T00:13:36
- Language: en

## Request

Follow the Stage72 handoff list of still-open probe classes for `validate_page_extract`: numeric-string ID coercion, unicode casefold collisions, and `pageRef` versus block/figure ID namespace. Confirm or reject each as a real trust-boundary hole; fix only real defects.

## Success Criteria

- Each probe class has a reproduced result from running the real validator.
- A real defect gets a failing test first, then a minimal fix.
- No defect means the probe result is recorded honestly and production code stays untouched.

## Context

Stage72 closed cross-namespace figure/block collisions and reserved prototype IDs. The handoff listed remaining candidate collision classes. The local Dart vision-cache layer already requires `pageRef == 'page-<pageNumber>'` and page identity binding, so page-ref namespace behavior matters on both sides of the air gap.

## In Scope

- Reproduce the remaining collision classes against `services/ai_gateway/page_extract.py`.
- Record outcomes in this task folder.

## Out of Scope

- Live model calls, network transport, UI changes, schema relaxations.

## Assumptions

- None.
