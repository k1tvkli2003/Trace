import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Private local outbox and AI run metadata. No provider credentials or input text.
final class OutboxHealth {
  const OutboxHealth({
    required this.pending,
    required this.inFlight,
    required this.failedRetryable,
    required this.failedDeadLetter,
  });

  final int pending;
  final int inFlight;
  final int failedRetryable;
  final int failedDeadLetter;
}

final class LocalOplogRepository {
  const LocalOplogRepository(this.database);

  final db.TraceDatabase database;

  /// Every row in the batch commits together. Same-ID replay is immutable.
  Future<void> putBatch({
    required List<domain.SyncOperation> operations,
    required List<domain.AiRunLedger> runs,
  }) async {
    await database.transaction(() async {
      for (final operation in operations) {
        _requireOperation(operation);
        final prior =
            await (database.select(database.syncOperations)
                  ..where((row) => row.id.equals(operation.operationId)))
                .getSingleOrNull();
        if (prior != null) {
          final existing = _operationFromRow(prior);
          if (!_sameJson(existing.toJson(), operation.toJson())) {
            throw StateError(
              'Sync operation ${operation.operationId} is immutable',
            );
          }
          continue;
        }
        await database
            .into(database.syncOperations)
            .insert(
              db.SyncOperationsCompanion.insert(
                id: operation.operationId,
                version: operation.version,
                contentHash: operation.contentHash,
                syncState: operation.rawSyncState,
                createdAt: operation.createdAt,
                payloadJson: jsonEncode(operation.toJson()),
              ),
            );
      }
      for (final run in runs) {
        _requireRun(run);
        final prior = await (database.select(
          database.aiRunLedgers,
        )..where((row) => row.id.equals(run.runId))).getSingleOrNull();
        if (prior != null) {
          final existing = _runFromRow(prior);
          if (!_sameJson(existing.toJson(), run.toJson())) {
            throw StateError('AI run ${run.runId} is immutable');
          }
          continue;
        }
        await database
            .into(database.aiRunLedgers)
            .insert(
              db.AiRunLedgersCompanion.insert(
                id: run.runId,
                version: run.version,
                contentHash: run.contentHash,
                createdAt: run.createdAt,
                payloadJson: jsonEncode(run.toJson()),
              ),
            );
      }
    });
  }

  Future<domain.SyncOperation?> readOperation(String id) async {
    final row = await (database.select(
      database.syncOperations,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    return row == null ? null : _operationFromRow(row);
  }

  /// Claim one pending row for local work.
  ///
  /// Local-only: the caller owns crash recovery by calling the explicit
  /// acknowledge/recordFailure path. No server acknowledgement exists yet.
  Future<domain.SyncOperation> claimPending(String id) async => _transition(
    id,
    from: domain.SyncState.pending,
    to: domain.SyncState.inFlight,
    retryDelta: 0,
  );

  /// Mark in-flight work acknowledged locally.
  ///
  /// Terminal in this slice: there is no later local transition from synced.
  Future<domain.SyncOperation> acknowledge(String id) async => _transition(
    id,
    from: domain.SyncState.inFlight,
    to: domain.SyncState.synced,
    retryDelta: 0,
  );

  /// Release one claimed row back to pending without touching retries.
  ///
  /// Local-only crash recovery: a worker that dies after [claimNext] or
  /// [claimPending] leaves the row stranded in `in_flight`. The next worker
  /// calls this explicit release, then reclaims the head. No clock involved.
  Future<domain.SyncOperation> releaseClaim(String id) async => _transition(
    id,
    from: domain.SyncState.inFlight,
    to: domain.SyncState.pending,
    retryDelta: 0,
  );

  /// Record one local failure attempt and preserve the retry count.
  Future<domain.SyncOperation> recordFailure(String id) async => _transition(
    id,
    from: domain.SyncState.inFlight,
    to: domain.SyncState.failed,
    retryDelta: 1,
  );

  /// Return failed work to pending while preserving prior retry attempts.
  ///
  /// Bounded: rows whose `retryCount` exceeds [maxRetries] stay `failed`
  /// as a local dead-letter instead of requeueing forever.
  Future<domain.SyncOperation> requeueFailed(
    String id, {
    int maxRetries = 5,
  }) async {
    _requireRetryBudget(maxRetries);
    final current = await readOperation(id);
    if (current == null) {
      throw StateError('Sync operation $id is absent');
    }
    if (current.syncState != domain.SyncState.failed) {
      throw StateError(
        'Sync operation $id is ${current.rawSyncState}, not failed',
      );
    }
    if (current.retryCount > maxRetries) {
      throw StateError(
        'Sync operation $id exhausted retry budget ($maxRetries)',
      );
    }
    return _transition(
      id,
      from: domain.SyncState.failed,
      to: domain.SyncState.pending,
      retryDelta: 0,
    );
  }

  /// Atomically pick the queue head and mark it in-flight.
  ///
  /// Local-only: closes the list-then-claim race by selecting the oldest
  /// pending row and transitioning it inside one transaction. Returns `null`
  /// when no pending row exists.
  Future<domain.SyncOperation?> claimNext() async {
    return database.transaction(() async {
      final head =
          await (database.select(database.syncOperations)
                ..where(
                  (entry) =>
                      entry.syncState.equals(domain.SyncState.pending.wireName),
                )
                ..orderBy([
                  (entry) => OrderingTerm.asc(entry.createdAt),
                  (entry) => OrderingTerm.asc(entry.id),
                ])
                ..limit(1))
              .getSingleOrNull();
      if (head == null) {
        return null;
      }
      final current = _operationFromRow(head);
      if (current.syncState != domain.SyncState.pending) {
        throw StateError(
          'Sync operation ${current.operationId} changed during claim',
        );
      }
      return _writeTransition(
        current,
        to: domain.SyncState.inFlight,
        retryDelta: 0,
      );
    });
  }

  /// Pure retry eligibility without a DB hit.
  static bool canRequeue(domain.SyncOperation operation, {int maxRetries = 5}) {
    _requireRetryBudget(maxRetries);
    return operation.syncState == domain.SyncState.failed &&
        operation.retryCount <= maxRetries;
  }

  /// Pure deterministic retry delay: [baseDelay] doubled per attempt,
  /// capped at [maxDelay]. No clock, no DB, no network.
  static Duration retryDelay(
    int retryCount, {
    Duration baseDelay = const Duration(seconds: 10),
    Duration maxDelay = const Duration(minutes: 5),
  }) {
    if (retryCount < 0) {
      throw ArgumentError.value(retryCount, 'retryCount', 'must be at least 0');
    }
    var delay = baseDelay;
    for (var attempt = 0; attempt < retryCount; attempt++) {
      final doubled = delay.inMicroseconds * 2;
      delay = doubled >= maxDelay.inMicroseconds
          ? maxDelay
          : Duration(microseconds: doubled);
      if (delay == maxDelay) break;
    }
    return delay;
  }

  static void _requireRetryBudget(int maxRetries) {
    if (maxRetries < 0) {
      throw ArgumentError.value(maxRetries, 'maxRetries', 'must be at least 0');
    }
  }

  static DateTime _parseUtc(String value, String field) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null || !parsed.isUtc || !value.endsWith('Z')) {
      throw FormatException('$field must be UTC ISO-8601');
    }
    return parsed;
  }

  /// Pure UTC failure-time to next-retry mapping via [retryDelay].
  ///
  /// Local-only scheduling math: `failedAtUtc + retryDelay(retryCount)`,
  /// returned as UTC ISO-8601. No clock read, no DB, no network. Callers
  /// supply the failure instant (a future slice may store `failedAt` per
  /// row); non-UTC input fails closed with [FormatException] and a negative
  /// count fails closed via [retryDelay].
  static String nextRetryAtUtc({
    required String failedAtUtc,
    required int retryCount,
    Duration baseDelay = const Duration(seconds: 10),
    Duration maxDelay = const Duration(minutes: 5),
  }) {
    final failedAt = _parseUtc(failedAtUtc, 'failedAtUtc');
    final delay = retryDelay(
      retryCount,
      baseDelay: baseDelay,
      maxDelay: maxDelay,
    );
    return failedAt.add(delay).toIso8601String();
  }

  Future<domain.SyncOperation> _transition(
    String id, {
    required domain.SyncState from,
    required domain.SyncState to,
    required int retryDelta,
  }) async {
    return database.transaction(() async {
      final row = await (database.select(
        database.syncOperations,
      )..where((entry) => entry.id.equals(id))).getSingleOrNull();
      if (row == null) {
        throw StateError('Sync operation $id is absent');
      }
      final current = _operationFromRow(row);
      if (current.syncState != from) {
        throw StateError(
          'Sync operation $id is ${current.rawSyncState}, not ${from.wireName}',
        );
      }
      return _writeTransition(current, to: to, retryDelta: retryDelta);
    });
  }

  Future<domain.SyncOperation> _writeTransition(
    domain.SyncOperation current, {
    required domain.SyncState to,
    required int retryDelta,
  }) async {
    if (to == domain.SyncState.tombstone ||
        to == domain.SyncState.unsupported) {
      throw StateError('Sync transition target is out of scope');
    }
    final priorJson = current.toJson();
    final next = domain.SyncOperation.fromJson({
      ...priorJson,
      'syncState': to.wireName,
      'retryCount': current.retryCount + retryDelta,
    });
    final changed =
        await (database.update(database.syncOperations)..where(
              (entry) =>
                  entry.id.equals(current.operationId) &
                  entry.syncState.equals(current.rawSyncState),
            ))
            .write(
              db.SyncOperationsCompanion(
                syncState: Value(next.rawSyncState),
                payloadJson: Value(jsonEncode(next.toJson())),
              ),
            );
    if (changed != 1) {
      throw StateError(
        'Sync operation ${current.operationId} changed during transition',
      );
    }
    return next;
  }

  Future<domain.AiRunLedger?> readRun(String id) async {
    final row = await (database.select(
      database.aiRunLedgers,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    return row == null ? null : _runFromRow(row);
  }

  Future<List<domain.SyncOperation>> listReadyToClaim({int limit = 100}) async {
    if (limit < 1) {
      throw ArgumentError.value(limit, 'limit', 'must be at least 1');
    }
    final query = database.select(database.syncOperations)
      ..where(
        (entry) => entry.syncState.equals(domain.SyncState.pending.wireName),
      )
      ..orderBy([
        (entry) => OrderingTerm.asc(entry.createdAt),
        (entry) => OrderingTerm.asc(entry.id),
      ])
      ..limit(limit);
    return (await query.get()).map(_operationFromRow).toList();
  }

  Future<List<domain.SyncOperation>> listOperations() async =>
      (await database.select(database.syncOperations).get())
          .map(_operationFromRow)
          .toList();

  /// Read-only failed rows within retry budget, deterministic order.
  ///
  /// Local-only retry-candidate listing: rows whose `retryCount` exceeds
  /// [maxRetries] are the local dead-letter set and stay excluded, mirroring
  /// [canRequeue] `<=` budget semantics. Order matches the queue ownership:
  /// `createdAt` ascending, then row id ascending (the `operationId`).
  /// `retryCount` lives inside `payloadJson` (no DB column), so the budget
  /// filter applies after the reviewed row mapping. Negative budgets fail
  /// closed via [_requireRetryBudget].
  Future<List<domain.SyncOperation>> listFailedWithinBudget({
    int maxRetries = 5,
  }) async {
    _requireRetryBudget(maxRetries);
    final rows =
        await (database.select(database.syncOperations)
              ..where(
                (entry) =>
                    entry.syncState.equals(domain.SyncState.failed.wireName),
              )
              ..orderBy([
                (entry) => OrderingTerm.asc(entry.createdAt),
                (entry) => OrderingTerm.asc(entry.id),
              ]))
            .get();
    return rows
        .map(_operationFromRow)
        .where((operation) => operation.retryCount <= maxRetries)
        .toList();
  }

  /// Read-only exhausted failed rows past the retry budget, deterministic order.
  ///
  /// Local-only dead-letter listing: the complement of
  /// [listFailedWithinBudget] under the same `<=` budget semantics as
  /// [canRequeue]. Rows with `retryCount > maxRetries` stay `failed` as the
  /// local dead-letter set. Order matches the queue ownership: `createdAt`
  /// ascending, then row id ascending (the `operationId`). Negative budgets
  /// fail closed via [_requireRetryBudget]. No transition, clock, sleep,
  /// scheduler, schema, or network is involved.
  Future<List<domain.SyncOperation>> listFailedOverBudget({
    int maxRetries = 5,
  }) async {
    _requireRetryBudget(maxRetries);
    final rows =
        await (database.select(database.syncOperations)
              ..where(
                (entry) =>
                    entry.syncState.equals(domain.SyncState.failed.wireName),
              )
              ..orderBy([
                (entry) => OrderingTerm.asc(entry.createdAt),
                (entry) => OrderingTerm.asc(entry.id),
              ]))
            .get();
    return rows
        .map(_operationFromRow)
        .where((operation) => operation.retryCount > maxRetries)
        .toList();
  }

  /// Read-only failed rows whose caller-supplied due time has arrived.
  ///
  /// This method owns no clock: [nowUtc] and each due instant arrive from the
  /// caller and must be UTC ISO-8601 values. Missing due entries are excluded
  /// rather than treated as immediately due. Equality is ready (`dueAt <=
  /// nowUtc`). Rows remain ordered by `createdAt`, then `operationId`, through
  /// [listFailedWithinBudget]. No state transition, sleep, scheduler, or
  /// network is involved.
  Future<List<domain.SyncOperation>> listDueFailedWithinBudget({
    required String nowUtc,
    required Map<String, String> dueAtUtcByOperationId,
    int maxRetries = 5,
  }) async {
    _requireRetryBudget(maxRetries);
    final now = _parseUtc(nowUtc, 'nowUtc');
    for (final entry in dueAtUtcByOperationId.entries) {
      _parseUtc(entry.value, 'dueAtUtcByOperationId[${entry.key}]');
    }
    final candidates = await listFailedWithinBudget(maxRetries: maxRetries);
    return candidates.where((operation) {
      final dueText = dueAtUtcByOperationId[operation.operationId];
      if (dueText == null) {
        return false;
      }
      final due = _parseUtc(
        dueText,
        'dueAtUtcByOperationId[${operation.operationId}]',
      );
      return !due.isAfter(now);
    }).toList();
  }

  /// Transition due failed rows back to pending, preserving queue order.
  ///
  /// Local-only composition of [listDueFailedWithinBudget] with the
  /// single-row [requeueFailed]: input validation (budget, UTC `nowUtc`,
  /// due parsing) runs inside the read-only filter before any transition,
  /// so invalid input fails closed with no writes. Each selected row then
  /// requeues through the same budget and wrong-state checks as a manual
  /// single requeue; `retryCount` is untouched and over-budget rows stay
  /// `failed`. No clock read, sleep, scheduler, schema, or network.
  Future<List<domain.SyncOperation>> requeueDueFailedWithinBudget({
    required String nowUtc,
    required Map<String, String> dueAtUtcByOperationId,
    int maxRetries = 5,
  }) async {
    final due = await listDueFailedWithinBudget(
      nowUtc: nowUtc,
      dueAtUtcByOperationId: dueAtUtcByOperationId,
      maxRetries: maxRetries,
    );
    final requeued = <domain.SyncOperation>[];
    for (final operation in due) {
      requeued.add(
        await requeueFailed(operation.operationId, maxRetries: maxRetries),
      );
    }
    return requeued;
  }

  /// Read-only point-in-time counts per sync state.
  ///
  /// Local-only observability for worker/drain progress and dead-letter
  /// backlog. Folds existing rows through the reviewed row mapping; no
  /// transitions, clock, sleep, or network.
  Future<Map<domain.SyncState, int>> countByState() async {
    final counts = <domain.SyncState, int>{
      for (final state in domain.SyncState.values) state: 0,
    };
    final rows = await database.select(database.syncOperations).get();
    for (final row in rows) {
      final operation = _operationFromRow(row);
      counts[operation.syncState] = counts[operation.syncState]! + 1;
    }
    return counts;
  }

  /// Read-only single-scan health snapshot of actionable outbox backlog.
  ///
  /// Local-only observability for worker/drain callers: one point-in-time
  /// fold over existing rows reporting `pending` ready work, stranded
  /// `inFlight` claims, retryable `failed` rows, and exhausted dead-letter
  /// `failed` rows. The failed split reuses [canRequeue] semantics
  /// (`retryCount <= maxRetries` retryable, otherwise dead-letter), so the
  /// two failed counts are the exact in-memory complement of
  /// [listFailedWithinBudget] and [listFailedOverBudget]. `synced` and
  /// `tombstone` rows are not actionable backlog and are excluded from all
  /// four counts. Negative budgets fail closed via [_requireRetryBudget]
  /// before the scan. No transition, clock, sleep, scheduler, schema, or
  /// network is involved.
  Future<OutboxHealth> outboxHealth({int maxRetries = 5}) async {
    _requireRetryBudget(maxRetries);
    var pending = 0;
    var inFlight = 0;
    var failedRetryable = 0;
    var failedDeadLetter = 0;
    final rows = await database.select(database.syncOperations).get();
    for (final row in rows) {
      final operation = _operationFromRow(row);
      switch (operation.syncState) {
        case domain.SyncState.pending:
          pending += 1;
        case domain.SyncState.inFlight:
          inFlight += 1;
        case domain.SyncState.failed:
          if (canRequeue(operation, maxRetries: maxRetries)) {
            failedRetryable += 1;
          } else {
            failedDeadLetter += 1;
          }
        case domain.SyncState.synced:
        case domain.SyncState.tombstone:
        case domain.SyncState.unsupported:
          break;
      }
    }
    return OutboxHealth(
      pending: pending,
      inFlight: inFlight,
      failedRetryable: failedRetryable,
      failedDeadLetter: failedDeadLetter,
    );
  }

  Future<List<domain.AiRunLedger>> listRuns() async =>
      (await database.select(database.aiRunLedgers).get())
          .map(_runFromRow)
          .toList();

  static void _requireOperation(domain.SyncOperation operation) {
    if (operation.mutationType == domain.SyncMutationType.unsupported ||
        operation.syncState == domain.SyncState.unsupported) {
      throw const FormatException('Unsupported sync operation');
    }
  }

  static void _requireRun(domain.AiRunLedger run) {
    if (run.outcome == domain.AiRunOutcome.unsupported) {
      throw const FormatException('Unsupported AI run outcome');
    }
  }

  static domain.SyncOperation _operationFromRow(db.SyncOperation row) {
    final parsed = domain.SyncOperation.fromJson(
      Map<String, Object?>.from(jsonDecode(row.payloadJson) as Map),
    );
    if (parsed.operationId != row.id ||
        parsed.version != row.version ||
        parsed.contentHash != row.contentHash ||
        parsed.rawSyncState != row.syncState ||
        parsed.createdAt != row.createdAt) {
      throw const FormatException('Sync operation row metadata mismatch');
    }
    _requireOperation(parsed);
    return parsed;
  }

  static domain.AiRunLedger _runFromRow(db.AiRunLedger row) {
    final parsed = domain.AiRunLedger.fromJson(
      Map<String, Object?>.from(jsonDecode(row.payloadJson) as Map),
    );
    if (parsed.runId != row.id ||
        parsed.version != row.version ||
        parsed.contentHash != row.contentHash ||
        parsed.createdAt != row.createdAt) {
      throw const FormatException('AI run row metadata mismatch');
    }
    _requireRun(parsed);
    return parsed;
  }

  static bool _sameJson(Map<String, Object?> a, Map<String, Object?> b) =>
      jsonEncode(a) == jsonEncode(b);
}
