# Stage 67 block text rejects control characters

- Task ID: `2026-09-26-stage-67-block-text-rejects-control-characters`
- Status: `active`
- Created: 2026-09-26
- Language: en

## Request
Close the fail-closed hole where block `text` carrying control/format-invisible characters (`\\x00`, C0 controls, bidi overrides) passes `validate_page_extract` as trusted transcription.

## Success Criteria
- Probe `a\\x00b`, `a\\x01b`, `a\\u202eb` in `b2.text` rejected before the fix (RED: `ContractFailure not raised`).
- After the fix, `python -m unittest test_page_extract -v` 13/13 and gateway `discover` 60/60 OK.
- Legit punctuation stays accepted: newlines, Persian, emoji are NOT in this slice.
- Task docs validate `--structure-only`; `git diff --check` clean; feat + close commits land; status `done`.

## Context
Probe at Stage66 HEAD (`fe78ec0`) showed `null-byte-text`, `c0-control-text`, `bidi-override` all `ACCEPTED-HOLE`. Multiline `\\n` stays in scope for a later slice (real extracts may carry wraps). Whitespace-padded IDs also noted but deferred as a separate slice.

## In Scope
- One RED test (`\\x00` + `\\x01` + `\\u202e` in `b2.text` → single code).
- One minimal GREEN fix in `validate_page_extract` block-text path.
- Stage67 task docs + `_index.md` row; feat commit + close commit.

## Out of Scope
- Newline/whitespace-only policy, ID padding policy, caption-side control policy, contract JSON change.

## Assumptions
- `\\x00`, C0/C1 controls, and bidi format controls never belong in trusted Vision transcription text.
