-- Slice B: durable trace_ai_receipts boundary (append-only).
-- Server receipt write owned by Supabase, not RAM.
-- Owner-scoped RLS; service_role stays server-only (no grant here).
-- No secret seed. No UPDATE/DELETE from client roles.

create table if not exists public.trace_ai_receipts (
  owner uuid not null references auth.users (id) on delete cascade,
  idempotency_key text not null
    check (char_length(idempotency_key) between 1 and 128),
  request_id text not null check (char_length(request_id) = 32),
  status text not null check (status in ('completed', 'failed')),
  operation text not null
    check (char_length(operation) between 1 and 128),
  capability text not null check (capability = 'page_vision_extract'),
  model text not null check (char_length(model) between 1 and 256),
  reasoning_effort text not null check (reasoning_effort in ('high', 'xhigh')),
  usage jsonb not null default '{}'::jsonb,
  elapsed_seconds double precision not null
    check (elapsed_seconds >= 0 and elapsed_seconds <= 300),
  provider_request_id text,
  source_hash text not null check (source_hash ~ '^[a-f0-9]{64}$'),
  pixel_hash text not null check (pixel_hash ~ '^[a-f0-9]{64}$'),
  error_code text check (error_code is null or error_code ~ '^AI_[A-Z0-9_]{1,60}$'),
  created_at timestamptz not null default now(),
  primary key (owner, idempotency_key)
);

create index if not exists trace_ai_receipts_owner_created_idx
  on public.trace_ai_receipts (owner, created_at desc);
create index if not exists trace_ai_receipts_owner_request_idx
  on public.trace_ai_receipts (owner, request_id);

alter table public.trace_ai_receipts enable row level security;

drop policy if exists trace_ai_receipts_select_own on public.trace_ai_receipts;
create policy trace_ai_receipts_select_own
  on public.trace_ai_receipts for select
  to authenticated
  using (owner = auth.uid());

drop policy if exists trace_ai_receipts_insert_own on public.trace_ai_receipts;
create policy trace_ai_receipts_insert_own
  on public.trace_ai_receipts for insert
  to authenticated
  with check (owner = auth.uid());

-- No UPDATE/DELETE policy: client roles cannot mutate receipts.
-- Service-role writes happen server-side with the service_role key,
-- which never ships to Flutter, logs, receipts, or responses.
