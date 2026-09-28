# Previews

## Preview Policy
No previews required — server-side gateway hardening with unit tests only;
no UI, no build, no device surface.

## Evidence
- Targeted: `python -m unittest test_page_vision test_nine_router_transport`
  from `services/ai_gateway` → `24/24 OK`.
- Full: `python -m unittest discover -s services/ai_gateway -p "test_*.py"` →
  `92/92 OK`.
