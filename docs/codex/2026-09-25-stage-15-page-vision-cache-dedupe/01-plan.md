# Plan

## Approach
Store one immutable JSON payload per cache key and pixel hash. Validate payload and rendered-page identity before insert and again on read.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Failing cache tests |
| 2 | done | Schema v11, repository, generated Drift code |
| 3 | done | Fail-closed payload and page binding |

## Interfaces and Artifacts
- `LocalVisionCacheRepository.put/lookup`
- `VisionCacheEntries`

## Risks
- Payload check is a bounded contract check, not the full Python page-extract validator.

## Acceptance Checks
- `dart test -j 1` in `packages/trace_data`
