# Trace — Stage 5 interaction map (provisional)

**Working direction:** Evidence Atelier. **Modernization mode:** recompose from a Flutter starter, without claiming product implementation. User delegated all non-icon design decisions. Compare the two browser-rendered mocks in `previews/`; screenshots are rendered from HTML/CSS, not AI-generated images or Flutter runtime.

## Product tasks and routes

| Arrival | Primary action | Source-of-truth / result | Failure, recovery and boundary |
|---|---|---|---|
| Library empty | Import source | Local original + hash manifest, later Stage 10 | Unsupported format retained but not processed; no spinner without checkpoint |
| Library book | Open current node or Review inbox | Local repository; due projection separate from learner status | Offline remains usable; missing synced binary shown explicitly |
| Worktree node | Start Learning without composing | Node anchor / persisted `SliceCursor` | Cache hit reopens artifact; missing page starts visible ingestion job |
| Teaching slice | Read cached citation-backed Lesson AST | Domain lesson artifact immutable version | Figure absent: explicit placeholder + source inspector; no invented source |
| Next box | Advance cursor once | Existing cached next slice before gateway call | No double generation; pending job visible, cancellable |
| Chat input | Ask about active node | Bounded slice and citation context | Draft retained on timeout; no direct SQL mutation |
| Citation | Open exact original page and source block | Original binary/page pixel hash + extracted evidence | Detached/uncertain citation marked, never silently remapped |
| Read action | Mark studied / not learned / mastered / skipped | Validated domain mutation and deterministic review event | Idempotency key; no fake success on failed transaction |
| Review | Replay cached artifact | Due ReviewItem projection and source link | No background AI cost; request explicit for new explanation |

## Desktop vs mobile

Desktop: library rail → worktree → teaching stage → source inspector, with source title, locator and uncertainty beside lesson. Both mocks expose start, next, citation and study actions as labeled controls. 768px: inspect on demand; 375px and below: worktree drawer, single-column lesson, evidence sheet; no invisible gesture-only navigation. English chrome remains LTR; Persian lesson/chat use isolated RTL spans and LTR `bdi` technical terms. Keyboard: natural header-to-rail-to-tree-to-lesson focus order, visible focus, escape to dismiss panels (implementation requirement); buttons must explain actions. 200% text, screen reader semantics, dark/light contrast and mobile safe area require Flutter runtime checks; browser screenshot is not that proof.

## Stage 5 visual comparison

| Criterion | Evidence Atelier | Signal Console |
|---|---|---|
| Reader position at 1440px | Narrower paper lesson (measured 564px), source visible | Wider lesson (701px), high-contrast dark ground |
| Evidence position | Docked source pane, page locator adjacent | Right pane with command-style evidence index |
| Narrow handling | Drawer toggles, compact wordmark | Drawer toggles, icon rail hidden |
| Risk | Four desktop rails constrain tablet; reading width at 1440px needs future density review | Dark dominance can tire long-form reading; status panels compete with cited lesson |
| Working choice | **Use as provisional implementation reference**; reduce redundant metadata before Flutter conversion | Preserve as alternative for power-user mode only, not another settings-heavy design system |

## Asset and implementation boundary

Selected icon: `assets/brand/trace-icon-selected.webp` (immutable). Preview HTML text/layout is **not** canonical Lesson AST and must not be ported as static fake course content. Each preview's page skeleton, figure slot and citation are explicitly placeholders. Production decomposition after design gate: icon raster; typography/color/spacing tokens; semantic Flutter navigation, reading pane, inspector and status widgets; figure from page crop only; original source page from trusted renderer; all dynamic text/citations from repositories; keyboard and touch navigation in Flutter. No background illustration is required. No unapproved image-model call to satisfy the older imagegen-specific preview prescription.

## Precision and mismatch ledger

Headless Chrome CDP geometry/screenshot probe: 1440×900, 375×844 plus 320×700 and 768×1024 overflow checks. At 1440 Evidence stage = 665px and lesson = 563.6px; Signal stage = 802px and lesson = 700.6px. Both phone screenshots retained. Mobile Evidence header initially overflowed (right edge 380px vs client width 375px); removed draft label and tightened spacing; all measured widths then fit. Worktree open/close simulated on phone for both. No semantic/focus trap audit, text scaling at 200%, RTL entire-screen alternative, appearance inspection by authorized visual model, or Flutter parity proof yet. Browser scrollbars reduce actual layout viewport by 15px. The visual mismatch ledger is therefore open, not passed.

## Gate

Two rendered screenshot directions support a provisional independent choice. Original Stage 5 plan explicitly calls for imagegen previews; newer own-model-only rule prevents use of a different image model. These screenshots are **not** imagegen. Keep Stage 5 imagegen-specific acceptance unresolved; no broad production visual rollout represented as approved or verified. Continue non-visual contracts and bounded design work while this conflict remains recorded.
