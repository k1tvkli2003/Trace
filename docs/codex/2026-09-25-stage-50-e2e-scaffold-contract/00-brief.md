# Stage 50 e2e scaffold contract

- Task ID: `2026-09-25-stage-50-e2e-scaffold-contract`
- Status: `active`
- Created: 2026-09-25T23:54:49
- Language: en

## Request
Close the acceptance-matrix `E2E (device/browser) = MISSING` row with a scaffold-only contract. Create `test/e2e/` plus a local unittest that proves the directory exists and holds a plan that names the §18 vertical-slice flows without claiming any of them ran.

## Success Criteria
- `test/e2e/README.md` exists and lists the §18 flows as `NOT RUN`.
- `tool/test_e2e_scaffold_contract.py` fails before the directory exists, then passes 2/2 after it does.
- Acceptance matrix E2E row moves from `MISSING` to `SCAFFOLD (unrun)`.
- No device, browser, emulator, Playwright, or Flutter integration run is claimed.

## Context
Stage30 vertical slice proved the offline local-first loop with unit/widget tests only. `test/e2e/` was still absent after Stage49 (`48c32b7`). Product name is Trace. StudyHub-Web stays reference-only.

## In Scope
- Task docs for this stage.
- RED contract test, then GREEN `test/e2e/README.md` plan.
- Acceptance-matrix status update to `SCAFFOLD (unrun)`.

## Out of Scope
- Running Playwright, Flutter integration tests, device/emulator smoke, or browser persistence checks.
- Any live AI, OCR, Supabase, auth, release build, or StudyHub-Web change.
- Claiming the §18 end-to-end flow is done.

## Assumptions
- A directory plus an honest `NOT RUN` plan is the correct next artifact, matching Stage47 CI scaffold and Stage48 fixture scaffold.
- None of the listed flows have runtime evidence in this stage.
