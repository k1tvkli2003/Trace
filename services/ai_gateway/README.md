# AI gateway boundary

Server-only future module. Provider credentials must never enter Flutter client. Capability names do not authorize another model/provider. No network gateway or deployed service exists yet.

`budget.py` is a **tested in-memory guard**, not production enforcement. It accepts one byte payload and one explicit provider callable for a single operation. Positive limits cap input bytes, requested output tokens, attempt count, elapsed time passed to adapter and returned bytes; absolute ceilings are 4 MiB input, 4,096 requested output tokens, 2 attempts, and 120 seconds per operation. Those are safety defaults, not proof of acceptable scientific answer length or cost. A duplicate successful call replays the result. No automatic retry, no model fallback, no recursive/reentrant request. `429`, `500`, `503` may be retried only by an explicit caller after the allowed time, within one operation's finite attempt/deadline budget. `400`, `401`, `403`, unknown failures, malformed/oversize/empty result, deadline expiry and ambiguous timeout stop safely with stable codes. A timeout after submission is `AI_OUTCOME_UNKNOWN`, never a blind retry.

This does **not** measure actual tokens or cost. The eventual provider adapter must enforce the token cap, transport-level timeout and cancellation, verify full response/schema, report actual usage and request ID, persist operation/idempotency/budget/ledger across restarts, authorize source access, and reconcile ambiguous remote outcomes. Without those, no AI call may be enabled in the Flutter app. No book content or credentials are logged by this guard.

Check: `python -m unittest discover -s services/ai_gateway -p test_*.py -v` from repository root.
