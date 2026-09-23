# Trace responsive contract — Stage 6

**Status:** implemented token contract. Flutter widget tests cover 320/200% text, 375, 834 and 1440 logical pixels; prior Chrome runtime captures cover 390 and 1440. Android/Windows native packaging remains unverified.

## Product direction

Quiet Index keeps one readable teaching stage as primary surface. Navigation and evidence remain adjacent only when they do not steal the minimum teaching measure. The shell stays LTR for English chrome; lesson/source content owns its explicit RTL direction.

## Semantic tokens

Canonical values live in `packages/trace_design/lib/src/tokens.dart`:

- Surface roles: `ink #202b2b`, `canvas #faf9f4`, `muted #606d69`, `accent #2f6b60`, `edge #dbe5e0`, `context #eef4ef`, `rail #f5f5f1`.
- Spacing ramp: `0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64`.
- Radius roles: control `8`, panel `12`, stage `16`.
- Motion roles: quick `180ms`, standard `240ms`.
- Minimum interactive target: `48x48` logical pixels.
- Typography: Inter for English chrome; Vazirmatn for Persian content; display digits normalized to ASCII `0-9` only at presentation boundary.

Repeated shell geometry must use `TraceGeometry`, not local viewport literals.

## Layout equations and breakpoints

```text
compact = viewportWidth < 700
railAvailable = viewportWidth >= 1180
navigationWidth = 264
railWidth = clamp(viewportWidth * 0.28, 270, 360)
```

At rail breakpoint, the remaining width after navigation and rail must remain at least `560` pixels for the teaching stage:

```text
teachingWidth = viewportWidth - navigationWidth - railWidth
teachingWidth >= 560
```

This yields the minimum rail layout at `1180` pixels without squeezing lesson content. Lesson content may constrain itself to `780` pixels for readable paragraphs; the outer stage remains flexible.

## Responsive behavior

| Width | Shell | Evidence | Primary action |
|---|---|---|---|
| `<700` | one stage; library in drawer | source route via explicit button | composer and source button remain visible |
| `700–1179` | desktop/tablet navigation + stage | no rail; source opens as route/panel | source route never squeezed into a narrow column |
| `>=1180` | navigation + stage; optional rail | user-controlled source rail | rail toggle appears only with selected collection |

The rail is optional, not a replacement for source navigation. A tablet never receives a hidden overflow rail. Mobile never depends on horizontal swipe to discover sources.

## Typography and stress rules

- 200% text scale reflows within scrollable frames; it must not scale the whole stage down.
- Long collection/source names ellipsize only where the full value remains available through source reader or inspector.
- Persian content uses `TextDirection.rtl` locally. Mixed source names, hashes, paths and digits remain isolated from shell direction.
- Display digits are ASCII `0-9`; stored source bytes and hashes remain unchanged.
- Reduced-motion mode must remove decorative transitions while preserving selected state and navigation feedback.

## Touch, keyboard and focus

- Main taps target at least `48x48` logical pixels.
- Icon-only actions have tooltip and semantic label.
- Drawer has explicit open/close path; Escape/back dismisses it and returns focus to its trigger where platform support allows.
- Source rail is a persistent sibling, not a modal overlay, so it cannot hide required composer controls.
- Modal and route states retain a visible escape action.

## State and occupancy rules

The same frame owns empty, loading and error states as the content they replace. Sparse collections show honest empty state, not fabricated source cards. Source rail displays only persisted source rows or an explicit no-source state. Composer remains available offline but send stays disabled until a real connection is configured.

## Verification evidence

- `packages/trace_design/test/quiet_index_tokens_test.dart`: token values, geometry equations, breakpoint and theme tests.
- `apps/trace_flutter/test/chat_shell_test.dart`: 320px/200% text, 375px drawer, 834px tablet route, 1440px rail show/hide, source flow and draft preservation.
- Runtime captures: `docs/design/runtime/quiet-index-desktop-rail-final.png`, `docs/design/runtime/quiet-index-mobile-final.png`.
- Existing Flutter Web build uses COOP/COEP preview server when Drift Web persistence is exercised.

## Known limits

- Token package is shared by Flutter packages; broader lesson renderer palette migration remains a follow-up.
- Native Windows and Android geometry/device smoke are not claimed by Web evidence.
- Browser keyboard/screen-reader audit and Android TalkBack audit remain release-gate work.
