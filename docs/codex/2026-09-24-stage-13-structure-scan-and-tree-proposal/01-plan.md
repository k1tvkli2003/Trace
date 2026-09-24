# Plan

## Approach
Add a fail-closed Python validator next to the existing offline gateway contracts. Schema file is the public contract; runtime checks scope, nesting, overlap, and review flags that JSON Schema cannot express alone.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Failing tests for heading, review, injection, malformed output |
| 2 | done | Validator plus `structure-proposal-v1.json` |
| 3 | done | Gateway suite and task docs |

## Interfaces and Artifacts
- `validate_structure_proposal(document, source_hash, page_refs, page_count)`
- `docs/contracts/structure-proposal-v1.json`

## Risks
- Schema accepts shapes the runtime still rejects (overlap, unknown parent, low confidence without review). Callers must use the runtime validator before persistence.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"`
