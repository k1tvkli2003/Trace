# Signal Console — user-approved design decision

2026-09-25: User selected **Signal Console** (05 desktop worktree, 06 mobile review) and explicitly authorized improvement during implementation. This supersedes the earlier autonomous Quiet Index recommendation below. Both files remain Mock Previews, not runtime proof. The prior scoring is historical, not binding.

## Binding production direction

- Matte graphite navigation and center stage with warm, readable text; restrained amber for active selection and sea-glass for verified local source status. Prefer truthful data-driven worktree over fictional progress.
- Desktop: flexible center, repository-backed collection list in fixed rail, optional source inspector at >=1180 dp. Mobile: drawer and working source route; do **not** add dead review tabs or fake due counts from preview 06.
- Keep draft, source import/reading, collection selection, offline AI state, and explicit teaching-preview label. AI send remains disabled until live gateway exists.
- Existing Inter/Vazirmatn font assets and ASCII numeral policy remain. Use bounded roles, directional geometry, keyboard focus, 200% text, reduced motion.
- New UI changes must follow the approved reference while improving legibility and responsive behavior. Deviations from fictional preview data are required by product truth.

## Superseded decision (historical)

Selected after inspection of 10 separate Flare-generated previews (01–10), contact-sheet comparison, and original-resolution checks of 09/10. User delegated visual selection under `/automate`; this was a working design spec, not a claim of user-approved pixels. Source previews in 09/10 contain fictional book metadata, fake reading counts, and illustration; none is product data. Existing icon is unchanged.

| System | Task clarity | Trust/honest state | Identity | Adaptive fit | RTL/type | Buildability | Mean |
|---|---:|---:|---:|---:|---:|---:|---:|
| Evidence Atelier 01–04 | 4 | 2 | 4 | 2 | 3 | 3 | 3.0 |
| Signal Console 05–06 | 3 | 4 | 4 | 3 | 3 | 4 | 3.5 |
| Folio Field 07–08 | 4 | 3 | 4 | 3 | 4 | 3 | 3.5 |
| Quiet Index 09–10 | 5 | 4 | 4 | 4 | 4 | 4 | 4.2 |

Scores are visual/feasibility judgments, not measured UX outcomes. Quiet Index wins on source-led typography, clear selection marker, calm reading space, and low-cost live Flutter implementation. Borrow Folio Field's document-as-object on the source reader later; do not combine whole palettes.

## Binding direction for representative slice

- **Mode:** Recompose existing chat-first shell while keeping behavior and data flows. Not a poster redesign.
- **Material:** off-white flat reading plane, ink-charcoal narrow nav rail, hairline separators, vermilion selected-position mark, moss/green only for *real* source provenance. No glass, gradient or fake progress.
- **Typography:** bundled Inter in chrome and Vazirmatn only in Persian content; all displayed digits ASCII. Use `Display` 28–34, heading 20–24, body 14–16, metadata 11–12; line height sized for reading, not screenshot fit.
- **Desktop:** rail ~248 dp, flexible center; source inspector min 320 dp only when parent width >= 1180 dp and selection has source context. Explicit toggle to preserve reading width; at narrower widths use existing source route. Never force a fourth fixed column on tablet.
- **Mobile:** full-width stage, navigation drawer, local context bar, source route. Do not invent mobile review inbox or fake bottom tabs before those routes work. Keep composer above system safe area.
- **Focus/action:** welcome state exposes one primary create/open action; sample teaching is clearly secondary. Selected source state surfaces *actual* source rows and readable originality status. `AI offline` means model not connected, not local AI inference. Send stays disabled; unsaved draft confirmation stays.
- **State:** loading/error/empty/selected/source-missing must use existing repository state; no hardcoded counts, lessons, due items, citations or progress.

## Preview-to-production decomposition

| Visible layer from 09/10 | Implementation | State/semantics | Responsive/verification |
|---|---|---|---|
| Dark spine, typographic Trace label | Live Flutter layout + current selected icon | Navigation actions; tooltip/focus | Rail desktop; drawer mobile; 320/375/834/1440 widths |
| Vermilion index tick | Live selected border/indicator | Selected library ID from repository | RTL-independent shell; 200% text |
| Library/source rows, status | Live list fed by existing Drift future | Actual `Ready to read` or `Waiting for Vision`; no fake counts | Intrinsic height, long names, tap >= 48dp |
| Center learning stage | Live text and action widgets | Empty/selected/offline; composer draft preserved | Max readable width; flexible blank space |
| Source location rail | Live side panel only when real source exists | Real filenames/hash/status; no invented page locators | >=1180 dp and manually collapsible; no rail on compact |
| Persian lesson art in image 10 | **Not** carried into shell as screenshot | Existing typed lesson preview remains explicitly sample | Separate teaching preview slice later |
| Book art, graph, fake citation, iOS home indicator | **Not used** | Sample/imagegen artifacts only | Native OS safe areas |

No raster mockup used as app chrome. Performance: no added runtime image or network request. Rollback: revert token/shell changes only; database and source originals untouched.

## Open mismatch ledger before implementation

1. Generated 10 shows source locator `p.18` and `NOT VERIFIED` beside a fake Persian lesson; real app has no such citation. Replace with actual document list and unverified AI state.
2. Generated right rail cramped: use 320+ dp and collapsible toggle, not literal pixel match.
3. Generated 09 mobile bottom tabs have no live search/review routes: retain drawer and working actions, no dead tabs.
4. Generated 10 center contains a finished lesson; current shell's real selected state is still import/read. Preserve honest state; implement lesson continuity only after artifact persistence.
