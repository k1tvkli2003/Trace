# Stage 81: Vision hardening (RecursionError, stream ceiling, key charset, SSE prefix)

- Task ID: `2026-09-29-stage-81-vision-hardening-recursion-stream-key-sse`
- Status: `ready-for-review`
- Created: 2026-09-29

## Request
Harden the Stage80 server-side page Vision adapter against the review findings in
`deleg_84e1109a`: hostile JSON recursion must stay a stable schema rejection,
ignored SSE frames must not evade the stream ceiling, a hostile API key must
never echo, final-only SSE output must respect the token cap, and the SSE parser
must accept spec-valid `data:` prefixes. No OCR, no local fallback, no client
secret wiring.

## Success Criteria
- `python -m unittest discover -s services/ai_gateway -p "test_*.py"` passes `92/92`.
- Validator for this task directory returns `OK`.
- Live product extraction remains `NOT VERIFIED`; this stage hardens local guards only.

## Context
Stage80 (`f9c0e89`) closed with targeted `20/20` and full `88/88` but left open
review items: `RecursionError` escaping the schema mapping, aggregate stream
ceiling bypass via ignored frames, unvalidated API key charset, uncapped
final-only SSE assembly, and strict `data: ` prefixing.

## In Scope
- `services/ai_gateway/page_vision.py`: map `RecursionError` to `AI_SCHEMA_REJECTED`.
- `services/ai_gateway/nine_router_transport.py`: aggregate stream counter, API key
  charset validation, final-assembly token cap, spec-tolerant SSE `data:` parsing.
- New RED-first tests in `test_page_vision.py` and
  `test_nine_router_transport.py`; no network or fixture PDF in tests.

## Out of Scope
- Live provider behavior, schema relaxation, product Farsi fidelity, Flutter/Dart
  wiring, durable idempotency, eviction policy, per-operation lock refactor.
- Raw diagnostic capture of the live schema mismatch (needs explicit user order).

## Assumptions
- Secrets stay server-side in `NINEROUTER_API_KEY` env; tests use synthetic keys only.
- Fixed route (`oc/muse-spark-1.3-contributor-free`, high/xhigh, Responses SSE) is unchanged.
