# Previews

## Preview Policy

Mock previews, fake states, and generated assets are labeled as previews until verified against the real implementation.

## No Previews Required

No previews were required; no Mock Preview, fake state, or generated visual asset was needed for this task. The only image is a real running-browser screenshot recorded below as verification evidence.

## Real Screenshot Evidence: tab2-welcome

- Label: Real-app screenshot (verification evidence, not a mock)
- Source: Chrome headless tab 2, same temporary profile, same COOP/COEP server
- Assumptions: None
- Limitations: Proves per-tab UI selection state only; data proof is the IndexedDB probe in `05-verification.md`
- Verified: yes
- Asset: `assets/trace-stage76.tab2.png`

Tab 2 shows the welcome/new-collection screen. The saved collection `Trace browser persistence` is visible in the sidebar, not auto-opened.
