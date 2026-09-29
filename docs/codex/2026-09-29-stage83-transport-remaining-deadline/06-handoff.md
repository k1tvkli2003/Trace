# Handoff

## Outcome
Stage83 closes the carried F20 deadline slice at the transport layer: a new
regression test first showed that after 2 seconds of elapsed call time, the
old socket wait stayed `[5.0, 5.0]`; transport now refreshes socket waits as
`[3.0, 2.0]` under the same single 5-second budget. Suites passed 13/13 and
96/96.

## Changed Artifacts
- `services/ai_gateway/nine_router_transport.py`: remaining-deadline hook
  around request, `getresponse`, and `read1`.
- `services/ai_gateway/test_nine_router_transport.py`: regression test plus
  initial-timeout recording in the shared connection stub.
- Task docs
  `docs/codex/2026-09-29-stage83-transport-remaining-deadline/` plus
  `_index.md` row.
- No change to `page_vision.py`, `budget.py`, retry rules, or provider route.

## How To Continue
- Validator passed `OK`; run staged diff check, then commit the four owned
  paths only.
- Await explicit user order for live capture, eviction policy, cross-tab
  runtime proof, signing, and any Stage84 slice.

## Done
- RED-first regression: old waits `[5.0, 5.0]`.
- GREEN minimal fix, targeted 13/13, full 96/96, unstaged diff clean.
- Docs written truthfully; commit blocked only until validator passes.

## Remaining
- Validator, staged check, commit, and v11 critic merge when workers finish.
- Known open product lines: schema-valid real-PDF pilot, eviction,
  concurrent-tab proof, app signing, idempotency across restarts.

## Verification
- Code proof is local stub evidence only. It does not claim provider latency,
  PDF fidelity, Flutter state, sync, browser persistence, or build readiness.
