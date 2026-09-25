# Plan

## Approach
Apply Signal Console as a token-driven reskin around the existing honest shell. Preserve domain behavior and test contracts, improve state hierarchy, worktree readability, review empty state, and responsive evidence presentation. Use TDD for layout/geometry rules and token behavior before visual changes.

## Steps
| Step | Status | Notes |
|---|---|---|
| 1 | planned | Record Signal Console decision in task docs and design previews |
| 2 | planned | Add failing widget/layout tests for console shell behavior |
| 3 | planned | Extend trace_design tokens and ChatWorkspace presentation |
| 4 | planned | Run targeted tests, full Flutter tests, analyze, and build/runtime smoke |
| 5 | planned | Update docs, verification, handoff, and commit |

## Interfaces and Artifacts
- `packages/trace_design/lib/src/tokens.dart`
- `packages/trace_design/lib/src/typography.dart`
- `packages/trace_design/lib/trace_design.dart`
- `apps/trace_flutter/lib/chat_workspace.dart`
- `apps/trace_flutter/lib/main.dart`
- `apps/trace_flutter/test/chat_shell_test.dart`
- `packages/trace_design/test/*`
- `docs/codex/2026-09-25-stage-20-signal-console-shell-redesign/*`
- `docs/design/previews/workbench-10/SELECT-ONE.md`

## Risks
- Matching raster pixels instead of rebuilding a responsive shell; mitigation is constraint-bound layout and width/state tests.
- Inventing source/worktree/AI data; mitigation is repository-driven state only.
- Breaking RTL, keyboard, text scale, reduced-motion behavior; mitigation is targeted regression checks.
- Linux/Windows host build proof may be unavailable; name honest limitation.

## Acceptance Checks
- Targeted widget tests pass.
- Existing `chat_shell_test.dart` behavior remains honest and responsive.
- `flutter test`, `flutter analyze`, available build/runtime smoke run or blocker named.
- Task docs complete and selection recorded.
