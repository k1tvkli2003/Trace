# State

- Current status: `done`
- Last updated: 2026-09-24
- Owner: Hermes

## Current State
Untrusted structure-scan JSON can be rejected or accepted offline. Accepted output is still a proposal, not an approved KnowledgeNode tree and not a lesson.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-24 | Validator lives in `services/ai_gateway`, not Flutter | Output is untrusted model JSON; client must not treat it as approved | learning-ai-v1.md |
| 2026-09-24 | Confidence under 0.5 requires `needsReview` | Ambiguous spans must not look approved | Stage 13 acceptance |
| 2026-09-24 | No live model call | OpenCode Go terms and Vision pilot still unproven | ai_gateway README |

## Blockers
- None

## Done
- Schema and runtime validator
- Focused tests including injection-as-data and malformed JSON

## Remaining
- Persist an approved tree after user edit (later stage)
- Wire a real structure_scan call only after the Go terms gate
