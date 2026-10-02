# Local serverless gateway boundary — server report

## Scope and traced invariants

- Repo `C:/Users/K1/Desktop/Projects/Trace`; supplied baseline HEAD `ae53c4c`. No branch/commit/deploy, live cloud mutation, credential use, provider call, or child agent authorized.
- Read `00-brief.md`, `01-plan.md`, existing gateway/validator/budget/routing/transport/tests before implementation. Existing 107 gateway tests passed with supplied Python 3.11.15 executable.
- Existing `OnDemandGateway` owns strict in-process request validation and RAM-only replay. Reuse pure preflight only; its RAM map is not a durable production store.
- Existing `VisionAdapter` owns hash-bound raster extraction, pinned model/high|xhigh, prompt, single-attempt `BudgetedRun`, bounded output, safe metadata, and `validate_page_extract`. Existing local `nine_router_transport` must not be imported or wired by cloud composition.
- Tracer: `POST /api/trace-ai-run` → bounded HTTP headers/body + explicit-origin CORS → Supabase `GET /auth/v1/user` → UUID + `TRACE_AI_OWNER_ID` authorization → 11-field base64 wire validation → atomic owner-scoped DB claim/reservation → one injected cloud transport through existing Vision adapter → validated extract + separate metadata, atomically finalized in DB → HTTP 200 `{receipt, extract}`. Every failure returns allowlisted `{error:{code,message,requestId}}`, private no-store, no raw diagnostics.
- DB owns `(owner,idempotency_key)`, page cache `(owner,source_hash,pixel_hash,render_profile,model,prompt_version)`, per-owner concurrency 1, daily reservation ceiling 262144, claim-before-call and request-ID comparison. Same-key conflicts/in-flight/unknown never submit again. Crash/timeout leaves durable unknown, requires operator reconciliation; no automatic recovery or fallback.
- RLS: owner SELECT only; client mutation and RPC EXECUTE denied. Service role isolated server-side. Additive migration only.
- Production composition needs explicitly injected transport and HTTPS cloud URL; absent config fails closed. Synthetic HTTP/provider/storage doubles used only in tests; no durable claims attributed to RAM doubles.

## Checkpoints

| Checkpoint | Evidence | Result |
|---|---|---|
| Baseline | Supplied Python `-m unittest discover -s services/ai_gateway -p test_*.py` | 107 tests, OK |
| RED-1 | `-m unittest ... -p test_cloud_gateway.py` | Expected missing `cloud_gateway` module; 1 loader error, exit 1 |
| GREEN-1 | Wire suite + full `unittest discover -s services/ai_gateway` | 7 new + 114 total, OK |

Official runtime reference inspected: https://vercel.com/docs/functions/runtimes/python/api-directory confirms top-level `handler(BaseHTTPRequestHandler)` and file-based route mapping. Supabase Auth/RLS official references inspected. No framework dependency planned.

## Pending

Wire validation GREEN; durable backend/Auth RPC adapter RED/GREEN; DB claim/finalize migration and role tests; cloud service RED/GREEN; real loopback HTTP test with labeled mock backend; full regression/static checks. Local Postgres binaries not on PATH; investigate installed scratch-capable runtime before claiming SQL/RLS execution.
