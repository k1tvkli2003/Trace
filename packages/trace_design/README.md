# Trace typography

- English UI: bundled **Inter**. User requested modern minimal font, not exact Codex typeface.
- Persian teaching/chat: bundled **Vazirmatn** with explicit RTL direction.
- UI numbers: `TraceTypography.displayDigits` converts Persian (`۰`–`۹`) and Arabic-Indic (`٠`–`٩`) digits to ASCII `0`–`9` at the display boundary. Render text through `TraceText.english` or `TraceText.persian`; apply the same policy to future rich text, date/counter widgets, inputs, accessibility labels and export views. Never mutate original source bytes, citation quotes, hashes or review events merely to display a number.
- Both TTFs are included in the package for offline Android, Windows and Web; their SIL OFL 1.1 notices live in `licenses/`. Inter from Google Fonts `ofl/inter`; Vazirmatn from an installed, license-bearing local copy.

Current status: typography tracer and tests only. `TraceText` handles plain strings; full Lesson AST, mixed-script rich spans and arbitrary third-party widgets are not implemented yet. No claim that all future numbers are already covered.
