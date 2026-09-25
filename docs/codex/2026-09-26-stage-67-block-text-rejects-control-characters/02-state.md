# State

- Current status: `done`
- Last updated: 2026-09-26
- Owner: Codex

## Current State
RED test confirmed the control-character hole (`\x00`, `\x01`, U+202E in `b2.text` accepted). GREEN fix applied: block `text` path rejects `_CONTROL_RANGES`. Page suite 13/13, gateway 60/60 OK.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-26 | Reject C0/C1 controls + bidi isolates/overrides in block `text`, reuse `INVALID_BLOCK_TEXT` | `\x00`/C0/bidi overrides never belong in trusted Vision transcription; existing code already covers oversize/unsafe text | probe at Stage66 HEAD `fe78ec0` |
| 2026-09-26 | Keep `\n` accepted; defer whitespace-only/ID-padding/caption-side policy | Real extracts carry line wraps; other surfaces are separate slices | Stage67 brief Out of Scope |

## Blockers
- None

## Done
- RED test added and confirmed RED.
- GREEN fix applied (`_CONTROL_RANGES`/`_CONTROL_TEXT`); `test_page_extract -v` 13/13; gateway `discover` 60/60 OK; docs validated `OK`; feat `3a0d336` committed.

## Remaining
- None — stage closed at feat `3a0d336` + close commit.
