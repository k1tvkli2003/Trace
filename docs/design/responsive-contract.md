# Trace — provisional responsive contract (Stage 5 evidence)

**Status:** design-only, not a Flutter token package or tested production UI. Working reference: Evidence Atelier HTML mock. This does not close the imagegen-specific Stage 5 gate or Stage 6 Flutter implementation.

## Geometry and surfaces

At wide widths, retain library rail, Knowledge Worktree, teaching stage and source inspector. Target zones from the tested 1440px mock: header height 60; rail 230; tree 265; source 280; flexible teaching 665 with 564px lesson. Width is *content-aware*, not a hard-coded Flutter width: constrain lesson to readable paragraph measure, let side regions collapse before text becomes too narrow. At medium width, keep worktree and lesson, source as toggleable inspector; library becomes a collapsed rail/drawer. At narrow width, one vertical reading stage and explicit Worktree/Source buttons; never rely on horizontal swipes to reveal essential controls. Mock QA tested 320, 375, 768 and 1440 CSS pixel widths without horizontal document overflow; only desktop/phone screenshots retained. Header brand/drawer/button fit at 320 after removing mock label and reducing horizontal padding. A vertical browser scrollbar consumes 15px in desktop Chrome emulation.

## Script and typography

English chrome uses bundled Inter (modern, minimal; exact Codex font match not required). Persian lesson/chat uses bundled Vazirmatn and isolated `TextDirection.rtl`; English chrome remains LTR. Both carry their OFL license in `packages/trace_design/licenses/`, work offline, and are registered in `trace_design/pubspec.yaml`. **All displayed digits use ASCII `0-9`**, even in Persian prose and dates; `TraceTypography.displayDigits` maps Persian and Arabic-Indic decimal digits at the presentation boundary. Keep original source/citation bytes, hashes and user-authored data unchanged; normalize display only. Source locators, hashes, file names and embedded English phrases need LTR isolation where relevant. RTL content does not flip the whole shell. Test actual font metrics, mixed-script numerals, formula rendering, 200% text scaling, long book titles, long node labels, clipped figure captions and text selection on all selected platforms. At 200%, reflow/scroll rather than suppress text, truncate primary controls or scale entire stage to tiny sizes.

## Interaction and accessibility

Target at least 48×48 logical pixels for Android primary taps where feasible; minimum 44×44 CSS px in these browser mocks is a provisional size, not native proof. All actions have labels; shortcut/icon-only controls need tooltip and semantic label. Preserve visible focus, predictable tab order, return focus after drawer close, Escape/back to dismiss and no focus behind modal drawer. Honor reduced motion and platform text settings; no gesture-only essential action or color-only status. Notifications never indicate due unless derived ReviewItem really is due. Review and source controls cannot vanish when offline.

## State coverage before Flutter sign-off

For library: empty, import-in-progress, unsupported format, local-only, sync pending, conflict. For worktree: loading, current, studied, due projection, uncertain boundary, unavailable page. For lesson: cached replay, generation pending, partial figure, uncertain citation, error with bounded retry. For chat: draft preserved on failure, streaming/cancelled, citation mismatch, tool mutation pending. Source inspector: original page present/absent, figure crop, document still downloading, hash mismatch. One representative vertical slice must demonstrate these states with fake repos before system rollout.

## Current proof and limits

`python tool/capture_design_mocks.py` drives isolated Chrome CDP to render both HTML mocks and asserts icon load, Persian `rtl`, horizontal fit at four widths and mobile Worktree open/close. It saves `docs/design/previews/*-{desktop,phone}.png`. This **does not** verify Flutter renderer, 200% text, keyboard/screen-reader workflow, installability or true PDF evidence. Stage 6 token code/golden matrix not started. Accessibility reference: [WCAG 2.2 Target Size (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html); platform behavior must be checked against installed Flutter runtime, not guessed from HTML.
