# Stage 47 CI workflow foundation

- Task ID: `2026-09-25-stage-47-ci-workflow-foundation`
- Status: `active`
- Created: 2026-09-25T23:01:02
- Language: en

## Request
Add the missing `.github/workflows/ci.yml` foundation so the Stage30 local verification set (domain/data/app tests, analyzers, gateway suite, docs validator, diff-check) has a versioned CI equivalent. No release, deploy, signing, Supabase, benchmark, E2E, or live-AI claim.

## Success Criteria
- `.github/workflows/ci.yml` exists, parses as YAML, triggers on `master` push + `pull_request` + `workflow_dispatch`.
- Top-level `permissions: contents: read`; secrets appear in no job.
- Jobs mirror runbook: domain tests, data tests, gateway tests, app test/analyze (Flutter 3.44.0 baseline), docs validator, diff-check.
- Local validation passes; no CI run claimed (no runner evidence in this slice).

## Context
Repo `C:/Users/K1/Desktop/Projects/Trace`, branch `master`, no remote, no `.github/workflows/`, no `benchmarks/`, no `test/e2e/`. Stage46 matrix marks CI `MISSING`; Stage30 verification lists CI absent. Umbrella stays `active` until gates land with evidence.

## In Scope
- One workflow file `.github/workflows/ci.yml` (CI checks only, no publish/deploy).
- One RED regression test proving the workflow exists and holds the contract.
- Stage47 task docs + `_index.md` row (created by scaffold).
- Local `python` YAML/contract checks + existing suite spot-checks.

## Out of Scope
- Any GitHub run claim, badge, required-status wiring, release/publish/deploy jobs.
- Signing, secrets, environments, store, hosting, Supabase, live AI, benchmarks, E2E, fixtures.
- Flutter/SDK installs, `StudyHub-Web` touch, OCR, provider/model change.

## Assumptions
- Default branch is `master` (observed `git branch -a`); workflow tracks it explicitly.
- Flutter baseline 3.44.0 / Dart 3.12.0 per `tool/target-matrix.md`; CI pins that version string.
