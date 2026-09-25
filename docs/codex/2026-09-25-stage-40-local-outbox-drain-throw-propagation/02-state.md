# State

- Current status: `ready-for-review`
- Last updated: 2026-09-25
- Owner: Codex

## Current State
Throw-propagation test added to the existing drain test file and GREEN
against unchanged production code. Full suites pass: data 146/146,
domain 114/114, app 41/41, Gateway 50. Next: validator, scans, commit.

## Done
- Throw-propagation gap captured as RED (contract documented in
  `deleg_05e06418` but unproven by any test).
- New test pins: exact error propagates, settled prefix stays `synced`
  in DB, throwing claim stays `in_flight` and releases to `pending`.
- Wider suites GREEN; analyzers clean; format clean.

## Remaining
- Validator, scans, commit (this verify step).
