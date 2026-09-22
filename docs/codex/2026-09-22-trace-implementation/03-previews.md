# Previews

## Preview and runtime evidence ledger
Stage 5 has two browser-rendered mock directions, with Evidence Atelier provisional pending the imagegen-specific gate. User selected the final icon; canonical source is `../../../assets/brand/trace-icon-selected.webp`. Other design decisions are delegated; no further shell vote required.

| Name | Type | Verified? | Asset | Limit |
|---|---|---|---|---|
| Icon platform composite | Generated preview from selected source | Yes, source hash and icon sizes; not app UI | `../../design/previews/icons/trace-selected-platform-proof.png` | Composite is not runtime proof |
| Android starter | Actual emulator capture | Yes, debug scaffold launch | `assets/android-stage2.png` | Only `Hello World!`, no product flow |
| Web starter | Actual Chrome headless capture | Yes, served web build | `assets/web-stage2.png` | Only `Hello World!`, no PWA offline/install proof |
| Evidence Atelier desktop/phone | Browser-rendered **mock preview** | Render and layout only; NOT Flutter UI or imagegen | `../../design/previews/evidence-atelier-{desktop,phone}.png` | Synthetic content, no PDF, no actual lesson |
| Signal Console desktop/phone | Browser-rendered **mock preview** | Render and layout only; NOT Flutter UI or imagegen | `../../design/previews/signal-console-{desktop,phone}.png` | Synthetic content, no PDF, no actual lesson |

## Mock Preview: icon platform composite
- Label: Mock Preview
- Source: `tool/verify_icons.py` resized user-selected image into a presentation board.
- Assumptions: Circular Web mask is a simulation, not actual installed home-screen appearance.
- Limitations: Does not prove Flutter UI or physical-device icon rendering.
- Verified: no; icon file lineage and dimensions verified separately with script/build inspection.
- Asset: `../../design/previews/icons/trace-selected-platform-proof.png`

## Mock Preview: Stage 5 reading workbenches
- Label: Mock Preview; no real book content, persistence, citation or AI action.
- Source: self-contained HTML/CSS and selected immutable icon; browser screenshots from isolated headless Chrome via `python tool/capture_design_mocks.py`. No image-generation model invoked.
- Assumptions: Synthetic library and lesson copy illustrate placement only; no lesson or source is real.
- Limitations: Not imagegen-backed; no 200% text, screen-reader or Flutter parity proof.
- Verified: HTML mock rendered in Chrome; icon loaded, Persian block `rtl`, no horizontal overflow at 1440/768/375/320 CSS widths; mobile worktree opens and closes. Initial 5px mobile header overflow fixed.
- Asset: `../../design/previews/evidence-atelier-desktop.png`, `../../design/previews/evidence-atelier-phone.png`, `../../design/previews/signal-console-desktop.png`, `../../design/previews/signal-console-phone.png` (source HTML beside images).
