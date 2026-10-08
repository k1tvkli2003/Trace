-- Align durable receipt ceiling with the 600s gateway contract.
-- Expand-only: widen CHECK, keep append-only, owner RLS, no client UPDATE/DELETE.
alter table if exists public.trace_ai_receipts
  drop constraint if exists trace_ai_receipts_elapsed_seconds_check;
alter table if exists public.trace_ai_receipts
  add constraint trace_ai_receipts_elapsed_seconds_check
  check (elapsed_seconds >= 0 and elapsed_seconds <= 600);
