# Stage 15 page vision cache dedupe

- Task ID: `2026-09-25-stage-15-page-vision-cache-dedupe`
- Status: `done`
- Created: 2026-09-25
- Language: English

## Request
Prevent repeat Vision for an unchanged rendered page. Cache key is source hash, page, render profile, model profile, and prompt version, plus the raster pixel hash.

## Success Criteria
- Identical key and pixel hash hit and replay the stored extract.
- Any identity change misses.
- Payload must be a complete `page-extract-v1` bound to an existing rendered page.
- Conflicting overwrite and corrupted stored JSON fail closed.
- Real v10 SQLite upgrades to v11 without losing source pages.

## Context
Domain `PageVisionCacheKey` already existed. No cache table or repository did.

## In Scope
- Drift schema v11 and generated code
- `LocalVisionCacheRepository`
- Migration and focused tests

## Out of Scope
- Calling a Vision model
- OCR or PDF text-layer transcription
- Flutter UI

## Assumptions
- Page IDs used by this cache are `page-<pageNumber>`.
