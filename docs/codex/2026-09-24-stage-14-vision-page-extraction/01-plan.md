# Plan

## Approach
Mirror the Stage 13 shape: failing tests first, then a fail-closed runtime module and a public JSON Schema that agree.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | Failing page-extract tests |
| 2 | done | Validator plus `page-extract-v1.json` |
| 3 | done | Suite and docs |

## Interfaces and Artifacts
- `validate_page_extract(document, source_hash, pixel_hash, render_profile, page_ref)`
- `docs/contracts/page-extract-v1.json`

## Risks
- JSON Schema alone cannot enforce hash binding or quarantine rules. Runtime use is required.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"`
