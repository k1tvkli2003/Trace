# Stage83 transport remaining deadline

- Task ID: `2026-09-29-stage83-transport-remaining-deadline`
- Status: `ready-for-review`
- Created: 2026-09-29
- Language: Persian report, ASCII numbers, English code IDs verbatim

## Request
Continue the standing goal with the next concrete slice: make the Stage80
transport honor the user-supplied deadline per network phase instead of
letting one slow phase consume the whole budget silently. Keep the fixed
route, single attempt, fail-closed codes, and no live model probe.

## Success Criteria
- RED: one regression test pins remaining-deadline socket waits across
  `getresponse` and `read1`, and fails on the old code (`[5.0, 5.0]` vs
  expected `[3.0, 2.0]`).
- GREEN: `test_nine_router_transport` 13/13 OK and full gateway suite
  96/96 OK, with `git diff --check` clean.
- Docs validated and committed with honest counts and limits.

## Context
- Workdir `C:/Users/K1/Desktop/Projects/Trace`, branch `master`.
- Baseline HEAD `ac778b9` on top of Stage82 code `2006021`.
- Finding source: critics report
  `work/parallel-critics/trace-standing-goal/v10-20260929-0020.md`,
  carried finding F20: `HTTPConnection` timeout fixed, deadline checked
  only before `read1`.
- Frozen code before this stage: `services/ai_gateway/page_vision.py`
  258 lines, `services/ai_gateway/nine_router_transport.py` 222 lines.

## In Scope
- Narrow transport change: remaining-deadline socket timeout before
  request, before `getresponse`, and before every `read1`.
- One regression test plus one shared stub fix that records the
  initial socket timeout.
- Stage83 task docs under
  `docs/codex/2026-09-29-stage83-transport-remaining-deadline/`.

## Out of Scope
- Live model probe, route change, retry policy, budget ceilings,
  operation-map eviction, concurrent-tab UI, Android signing, and any
  critic write beyond `work/parallel-critics/trace-standing-goal/`.

## Assumptions
- The local stub socket honors `settimeout`; real `http.client` socket
  honors the same timeout on blocking read.
