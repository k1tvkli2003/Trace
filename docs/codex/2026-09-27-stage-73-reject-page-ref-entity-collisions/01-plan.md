# Plan

## Approach

TDD vertical probes, one class at a time. First reproduce each class against the real validator with exact error codes. Only write a failing test when a probe shows a real, contract-violating hole. If all classes are already correctly rejected, record the negative result and leave production code untouched.

## Steps

| Step | Status | Notes |
|---|---|---|
| 1 | done | Probe `pageRef`/block-id and `pageRef`/figure-id equality |
| 2 | done | Probe `figure.blockId` set to the page-ref value |
| 3 | done | Probe numeric-string and unicode-casefold sibling collisions |
| 4 | planned | Confirm no Dart/Flutter page-id owner is affected |
| 5 | planned | Record all results; no production patch unless a hole is real |

## Interfaces and Artifacts

- `services/ai_gateway/page_extract.py`
- `packages/trace_data/lib/src/local/local_vision_cache_repository.dart`
- `packages/trace_data/test/local_source_page_repository_test.dart`
- This task folder and `docs/codex/_index.md`

## Risks

- Patching without a real hole would add behavior nobody needs; mitigated by requiring a reproduced hole first.
- Misreading `ACCEPTED` results as holes; mitigated by checking consumer invariants.

## Acceptance Checks

- Every claimed hole has exact probe output and an error code or assertion.
- Any fix has a failing test written before production code changes.
- If no hole, the handoff states this explicitly.
