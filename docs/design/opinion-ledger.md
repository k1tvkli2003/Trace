# Trace — Stage 5 product/experience ledger (draft, 2026-09-23)

This is a design exploration, not a shipped UI. Current runtime remains Flutter's `Hello World!`. Product truth: one person reads long books, resumes an exact slice, asks a Persian tutor, checks claims against source-page evidence, and reviews due material offline. Three independent landmarks must remain legible: library, worktree, teaching stage. English chrome is LTR; Persian lesson/chat are locally RTL. Icon source is already chosen and immutable. No social leaderboard or fake XP.

## Whole-experience opinions

| Surface | Judgment | Evidence / intended job | Preservation and proof |
|---|---|---|---|
| Name, promise, voice | KEEP / REFINE | `Trace` chosen; promise is source-linked learning, not AI spectacle | Keep English shell copy direct, warm Persian teaching later; verify copy at 200% |
| Icon, favicon, adaptive icon | KEEP | User-selected WebP and platform derivatives are hash-verified | Do not redraw; inspect app display at launcher size later |
| Wordmark / splash | ADD | No actual brand typography or splash identity yet | Live accessible text + selected mark; splash remains future native QA |
| Typography / palette | ADD | Starter UI has none | Separate quiet chrome from long-form readable Persian; contrast / mixed scripts |
| Library rail / import | REDESIGN | Starter has no library; importing, due and ingestion state need a home | LibraryItem state visible; import remains disabled in mock until Stage 10 |
| Knowledge worktree | ADD | No navigation beyond starter | Tree depth, current node, completed/due, keyboard traversal and mobile drawer |
| Teaching stage / chat | ADD | Main task is consuming a cited slice then asking a question | Source-backed lesson + composer; no raw model HTML; fake copy only in preview |
| Source inspector / citations | ADD | Claim-to-page verification is product trust anchor | Citation action opens page/page-bound evidence and uncertainty; mock cannot assert extraction |
| Start Learning / Next box | ADD | Start without composing; cursor-based continuation | Controls near title and artifact; must wire to domain contract later |
| Study actions / review inbox | ADD | Deterministic schedule and cached replay are primary return loop | Due state distinct from read status; no coercive streak/XP language |
| Cost / sync / offline | ADD | User must understand charges, caching, failure and sync completeness | Status near affected object; bounded retry and honesty about not-yet-synced binary |
| Notes / highlights | ADD | Source-linked annotations must survive regenerations | Inspector/selection only after anchor engine exists |
| Command and keyboard flow | ADD | Frequent navigation needs direct access | Discoverable shortcut and focus-visible; dialog if real search exists |
| Notifications and native packaging | DEFER, NOT REMOVE | Stage 4 plugins need ATL on Windows, Android config | No scheduled-while-closed Web promise; review inbox remains source of truth |
| Motion / reward / mascot | REFINE / DEFER | Preserve orientation, do not gamify studying with pressure | Reduced-motion still, no mandatory streak or gamified chrome in MVP |
| Empty/loading/error/offline/permission states | ADD | Failure recovery is part of user trust | Replace content in its own region; no endless spinner or fake success |
| Promotional/store/share imagery | OUT OF SCOPE | Single-user private app without distribution identity | Do not invent marketing surfaces |

## Divergence: 24 raw recipes

Each line is mental model + topology + interaction + material + motion + data metaphor; UX gain and risk. These are **raw** hypotheses, not approved concepts.

| # | Recipe | UX gain | Risk |
|---|---|---|---|
| 01 | Evidence Atelier: document + split-stage + inspect-and-act + warm paper/ink + unfold + provenance trail | Teaching and citation share eye path | Dense book pages may overwhelm |
| 02 | Signal Console: cockpit + asymmetric rails + keyboard-first + graphite/copper + snap + status signals | Pending jobs and next action visible | Can look intimidating |
| 03 | Margin Observatory: lens + nested inspector + hover/select + vellum + focus + source coordinates | Claim-to-page comparison fast | Small screens need drawer |
| 04 | Chapter Transit: map + timeline spine + zoom-to-detail + mineral + glide + journey | Position across a long book | Tree hierarchy gets flattened |
| 05 | Source Loom: workshop + layered stack + drag-to-compose + woven grid + weave + threads | Build lessons from evidence | Drag gesture costly on mobile |
| 06 | Research Desk: studio + docked workbench + direct manipulation + ceramic + fold + annotated documents | Calm study posture | Risk of decorative skeuomorphism |
| 07 | Quiet Index: archive + elastic grid + search-first + crisp white/black + snap + ledger | Fast book retrieval | Tutor presence too hidden |
| 08 | Due Horizon: timeline + split-stage + inspect-and-act + slate/gold + scan + time markers | Return path obvious | Deadline pressure harmful |
| 09 | Citation Circuit: lab + asymmetric rails + compare-and-choose + dark foil + pulse + trace graph | Show how claims map to page | Graph can imply false causality |
| 10 | Reading Current: stream + focus tunnel + guided reveal + paper + gentle fade + text flow | Long reading without dashboard clutter | Weak worktree visibility |
| 11 | Folio Field: gallery + layered stack + gesture zoom + vellum + glide + page layer | Figures and source pages primary | Chat cramped |
| 12 | Slice Ledger: ledger + three panes + keyboard-first + neutral ink + snap + sequence | Exact resume and cache status | Accounting feel |
| 13 | Study Compass: instrument + radial preview + inspect-and-act + brushed metal + orbit + progress bearing | Orientation and next node | Radial navigation poor at 1000 nodes |
| 14 | Book Terrain: atlas + zoomable canvas + zoom-to-detail + terrain + parallax + source ranges | Visual chapter topology | Screen readers suffer |
| 15 | Annotator's Table: document + docked inspector + inline selection + ivory/charcoal + underline + anchors | Highlight/note relation visible | Too many tools around text |
| 16 | Learning Radar: observatory + alert rail + contextual tray + glassless graphite + pulse + due queue | Prioritize actionable reviews | Surveillance look |
| 17 | Node Workshop: worktree + split-stage + command chips + ink/copper + mechanical lock + dependencies | Depth without endless menus | Power-user bias |
| 18 | Teaching Gallery: gallery + wide stage + guided reveal + archival paper + settle + lesson artifacts | Lessons feel worth keeping | Library access buried |
| 19 | Evidence Meter: simulator + staged evidence lane + source compare + matte mineral + scan + certainty | Distinguish uncertain Vision text | False numerical confidence |
| 20 | Pocket Workbench: notebook + vertical stage + bottom dock + tactile rubber + fold + bookmarks | Android reachability | Desktop overly narrow |
| 21 | Worktree Terminal: command center + split stage + keyboard-first + graphite + blink-free snap + paths | Familiar agent ergonomics | Copies developer tool too literally |
| 22 | Quiet Library: archive + navigation rail + search-first + warm white + unfold + collection | First-use safety and overview | Low density with many books |
| 23 | Review Cabinet: ledger + nested inspector + cached replay + steel/cream + tab shift + memory index | Due reviews without model calls | Fragmented teaching flow |
| 24 | Trace Plate: lab + asymmetric workbench + compare-and-inspect + dark ink/ivory + split reveal + source imprint | One continuous lesson-to-evidence path | Must constrain source inspector on mobile |

## Shortlist and cut

01, 02, 03, 12, 15, 17, 20, 24 survive because source/cursor/lesson actions stay explicit. Reject 13/14 as primary shell: radial/zoom metaphors obscure keyboard navigation and deep trees. Reject 08/16 as primary identity: due-first hierarchy pressures study. Final code-native visual candidates: **Evidence Atelier** (01+15+20, light editorial reading surface) and **Signal Console** (02+12+24, dark dense operational surface). Both keep three jobs visible at desktop and collapse to accessible navigation on mobile. Stage 5 selection requires rendered comparisons and accessibility critique; neither is product UI yet.

## Preview policy conflict

Original plan requests imagegen for UI previews. User's newer own-model-only rule bars any other image model; icon is already final. HTML/CSS previews rendered to browser screenshots by this same model are valid visual evidence under shared preview contract, but **not imagegen output**. Record this deviation rather than silently substituting or using an unauthorized image model. Do not call the Stage 5 imagegen-specific gate passed; keep broad Flutter UI implementation gated until direction is established against rendered evidence and user delegation.
