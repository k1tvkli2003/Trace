# Trace AI gateway — cloud deploy checklist (live 2026-10-03)

Endpoint (prod deploy): `https://trace-hdguqyncl-amirkeyvan-tavakkolis-projects.vercel.app/api/trace-ai-run`

## Vercel project
- Project `trace` (`prj_WNjm369S1SDMsFwpXIFlvD4s9Jym`), team scope default.
- `vercel.json`: modern form — `functions` with `maxDuration` only, no legacy
  `runtime`/`routes` keys (legacy form fails deploy with "Function Runtimes
  must have a valid version").
- `.vercelignore` keeps the deploy to `api/` + `services/` + `supabase/`
  (20M `work/` dir excluded). No `package.json` — pure Python function.
- Deployment Protection (SSO) disabled so the API route is public.

## Server env vars (names only — values live in Vercel, never in repo)
- `TRACE_SUPABASE_URL` — `https://<ref>.supabase.co`
- `TRACE_SUPABASE_ANON_KEY` — JWT auth check only (`GET /auth/v1/user`)
- `TRACE_SUPABASE_SERVICE_ROLE_KEY` — receipt writes only
- `NINEROUTER_API_KEY` — upstream vision route (fixed route in transport)

## Supabase
- Table `public.trace_ai_receipts` live (migration `20261002_trace_ai_receipts.sql`).

## Smoke (frozen contract, live prod deploy)
- `POST {} → 400 AI_VISION_REQUEST_INVALID`
- `POST garbage-png body, no JWT → 400 AI_PAGE_IMAGE_INVALID` (shape first)
- `POST valid-shape body, no JWT → 401 AI_UNAUTHORIZED` (no upstream spend)
- `POST valid-shape body, bad JWT → 401 AI_UNAUTHORIZED`
- `GET → 405`
- Full vision spend needs a real user Supabase JWT (only the user holds one).

## Local gate
- `python -B -m unittest test_cloud_wiring test_on_demand_run test_cloud_gateway
  test_supabase_backend test_trace_ai_run_route` → 33 OK
- `git diff --check` clean; secret grep over touched files clean.
