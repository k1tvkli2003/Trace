# Plan

## Approach
قرارداد را اول freeze کن: یک sync endpoint، auth مالکیت‌محور، validation fail-closed، بودجه server-side، idempotency key یکتا، failure‌های deterministic و receipt بدون secret. سپس RED→GREEN روی boundary و handler، بعد migration حداقلی و client boundary، و در پایان focused suite + local smoke + docs.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | done | ثبت brief/state/progress فعلی، frozen API/data/auth/error/idempotency/observability contract |
| 2 | done | RED: tests first برای success، duplicate idempotent، auth/ownership، invalid input، duplicate conflict، upstream failure |
| 3 | done | GREEN: minimal handler+route/service در سبک repo با همان قرارداد |
| 4 | done-local | Supabase migration حداقلی receipt + RLS owner-scoped، server-only service role (SQL نوشته شد، اجرا روی cloud نشده) |
| 5 | done | Flutter-facing client boundary بدون credential، قرارداد mock-labeled در preview |
| 6 | done | local smoke + focused suite + static checks + validator/docs/record/commit (cloud جدا) |

## Interfaces and Artifacts
- `api/trace-ai-run.py` فعلی Python serverless adapter برای `POST /api/trace-ai-run` است (`handler(BaseHTTPRequestHandler)` با `do_POST` و `do_GET → 405`)، نه معادل Node/TS.
- server service/handler جدا برای auth/validation/budget/idempotency/upstream/receipt.
- `supabase/migrations/*_trace_ai_receipts.sql` با PK/FK/unique/index/check و RLS `owner = auth.uid()`.
- `apps/trace_flutter/lib/services/trace_gateway_client.dart` یا adapter معادل با تست.
- tests حداقلیboundary/service با RED واقعی، ثم سبز.
- رکورد docs این تسک و ledger خطاهای honesty.

## Frozen contract (t1)

```text
API CONTRACT
- Caller: Flutter client, no secret, Supabase Auth JWT in Authorization header
- Method: POST /api/trace-ai-run
- Auth required: yes, Supabase JWT verified server-side
- Authorization rule: owner = auth.uid(); receipt insert scoped to owner; anon rejected
- Input schema: operation, capability allowlist, page_ref/source_hash/pixel_hash/render_profile, page_png bounded PNG, reasoning_effort high|xhigh, max_output_tokens 1..16384, max_elapsed_seconds 1..300, idempotency_key 1..128
- Output schema: requestId, status completed|failed, capability, model, reasoning_effort, error code-only, usage safe numbers, elapsed_seconds, provider_request_id safe-or-null
- Error shape: {error:{code, message safe, requestId}}
- Idempotency key: client-supplied, unique per owner, same-key same-payload replay, conflict fails closed
- Side effects: single upstream call server-only, no hidden retry/fallback, receipt write once
- Rate/abuse: BudgetedRun-equivalent caps server-side, bounded bytes, deadline enforced
- Logs/metrics: requestId, latency, retry count, outcome; no secret, image, prompt, raw response
```

```text
DATA CONTRACT
- Table: trace_ai_receipts, owner uuid, operation text, capability text, idempotency_key unique per owner, status, model_profile, prompt_version, input_hashes, usage safe, latency_ms, error_code nullable, created_at timestamptz
- RLS: SELECT/INSERT owner-only TO authenticated; no UPDATE/DELETE from client; service_role server-only
- Migration: append-only SQL, idempotent policies/indexes, no secret seed
```

Upstream model id and endpoint stay server env-only; contract pins shape, not secret value. Vercel Python function reuses `services/ai_gateway` validation/budget where possible. Flutter client sends JWT + bounded fields, never key.

## Risks
- نبود endpoint exact/live برای route شخصی: design secret/upstream را abstract نگه می‌دارد؛ deploy/live اثبات جدا است.
- timeout بزرگ Vision روی serverless ممکن است محدود شود: قرارداد request async/job یا budget کوچک‌تر با job id را آماده کن، نه retry پنهان.
- Flutter dependency/http stack ممکن است تغییر لازم کند: minimal adapter بدون secret و بدون product behavior جدید.

## Acceptance Checks
- `python -m unittest discover -s services/ai_gateway -p 'test_*.py'` سبز می‌ماند.
- tests تازه boundary ابتدا RED می‌دهد، سپس با minimal implementation سبز می‌شود.
- هیچ secret در code/log/receipt/DB client-visible نیست.
- `git diff --check`, validator ساختار task docs، tests مربوطه همگی سبز.
