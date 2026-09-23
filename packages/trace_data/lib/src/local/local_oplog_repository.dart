import 'dart:convert';

import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Private local outbox and AI run metadata. No provider credentials or input text.
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

  Future<domain.AiRunLedger?> readRun(String id) async {
    final row = await (database.select(
      database.aiRunLedgers,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    return row == null ? null : _runFromRow(row);
  }

  Future<List<domain.SyncOperation>> listOperations() async =>
      (await database.select(database.syncOperations).get())
          .map(_operationFromRow)
          .toList();

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
