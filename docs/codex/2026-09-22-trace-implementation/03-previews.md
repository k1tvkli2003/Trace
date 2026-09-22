# Previews

## Preview and runtime evidence ledger
Stage 5 shell direction is still pending. User selected the final icon; canonical source is `../../../assets/brand/trace-icon-selected.webp`. Other design decisions are delegated; no shell approval is needed.

| Name | Type | Verified? | Asset | Limit |
|---|---|---|---|---|
| Icon platform composite | Generated preview from selected source | Yes, source hash and icon sizes; not app UI | `../../design/previews/icons/trace-selected-platform-proof.png` | Composite is not runtime proof |
| Android starter | Actual emulator capture | Yes, debug scaffold launch | `assets/android-stage2.png` | Only `Hello World!`, no product flow |
| Web starter | Actual Chrome headless capture | Yes, served web build | `assets/web-stage2.png` | Only `Hello World!`, no PWA offline/install proof |

## Mock Preview: icon platform composite
- Label: Mock Preview
- Source: `tool/verify_icons.py` resized user-selected image into a presentation board.
- Assumptions: Circular Web mask is a simulation, not actual installed home-screen appearance.
- Limitations: Does not prove Flutter UI or physical-device icon rendering.
- Verified: no; icon file lineage and dimensions verified separately with script/build inspection.
- Asset: `../../design/previews/icons/trace-selected-platform-proof.png`
