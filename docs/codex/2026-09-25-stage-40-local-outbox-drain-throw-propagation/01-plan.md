# Plan

## Approach
Gap-closure tracer: RED is the missing test itself (contract
unproven). Write one focused drain test where the handler succeeds on
the first head then throws on the second. GREEN means the test passes
against unchanged production code, proving propagation.

## Steps
1. Append throw-propagation test to
   `test/local_oplog_bounded_drain_test.dart`.
2. Run focused test, then full data/domain/app/Gateway suites.
3. Record verification, update `_index.md`, validate docs, commit.

## Acceptance
- `drain` future completes with the handler error (not a partial list).
- First row reads back `synced`; second row reads back `in_flight`
  and `releaseClaim` returns it to `pending`.
