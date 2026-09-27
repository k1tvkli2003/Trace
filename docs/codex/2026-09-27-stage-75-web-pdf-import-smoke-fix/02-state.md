# State

- Current status: `ready-for-review`
- Last updated: 2026-09-27T04:20:00+03:30
- Owner: Hermes

## Current State

Stage 75 proves both Markdown and PDF originals survive a real Chrome reload in the
Stage 74 web build. This is test-harness proof, not production release or PDF
Vision fidelity proof. No product code changed.

## Decisions

| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-27 | Import before reload | `main.dart` resets `_selectedId` to null on reload, so the old harness clicked with no selected collection | `main.dart`, Chrome failure |
| 2026-09-27 | Click `Manage`, then format-specific import button | Fresh screenshot shows the actual control path and distinct button positions | `chat_workspace.dart`, real Chrome screenshots |
| 2026-09-27 | Close Chrome through CDP before temp cleanup | Windows locked Chrome network-state temp files after `proc.terminate()` alone | failed Markdown run (`WinError 32`) |

## Blockers

- None for Stage 75.

## Done

- Reproduced and fixed `Real file picker did not open`.
- Real native chooser imported `.pdf` and `.md`, with exact original bytes present before and after reload.
- Tests: harness contract 3/3; tool suite 11/11; gateway suite 65/65.

## Remaining

- None within Stage 75. The broader product still needs its remaining release
  gates, including real source Vision fidelity and cross-device sync.
