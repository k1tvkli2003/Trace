import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> syncJson({
  String id = 'sync-1',
  String state = 'pending',
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'a' * 64,
  'entityType': 'study_note',
  'entityId': 'note-1',
  'mutationType': 'insert',
  'payload': <String, Object?>{
    'nested': <String, Object?>{'text': 'saved'},
  },
  'localVersion': 1,
  'syncState': state,
  'retryCount': 0,
  'createdAt': '2026-09-24T10:00:00Z',
};

Map<String, Object?> ledgerJson({
  String id = 'run-1',
  String outcome = 'succeeded',
}) => {
  'runId': id,
  'version': 1,
  'contentHash': 'b' * 64,
  'capability': 'teacher_fa',
  'inputHashes': ['a' * 64],
  'modelProfile': 'opencode-go/user-selected',
  'promptVersion': 'v1',
  'inputTokens': 10,
  'outputTokens': 20,
  'costMicros': null,
  'latencyMs': 30,
  'retryCount': 0,
  'outcome': outcome,
  'createdAt': '2026-09-24T10:01:00Z',
};

void main() {
  test('oplog and private AI ledger persist and replay unchanged', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LocalOplogRepository(db);
    final operation = SyncOperation.fromJson(syncJson());
    final run = AiRunLedger.fromJson(ledgerJson());
    await repo.putBatch(operations: [operation], runs: [run]);
    expect((await repo.readOperation('sync-1'))?.toJson(), operation.toJson());
    expect((await repo.readRun('run-1'))?.toJson(), run.toJson());
    await repo.putBatch(operations: [operation], runs: [run]);
    expect((await repo.listOperations()).length, 1);
    expect((await repo.listRuns()).length, 1);
  });

  test('duplicate operation conflict rolls back new run', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LocalOplogRepository(db);
    await repo.putBatch(
      operations: [SyncOperation.fromJson(syncJson())],
      runs: [],
    );
    final conflicting = syncJson()..['entityId'] = 'note-2';
    await expectLater(
      repo.putBatch(
        operations: [SyncOperation.fromJson(conflicting)],
        runs: [AiRunLedger.fromJson(ledgerJson())],
      ),
      throwsStateError,
    );
    expect(await repo.readRun('run-1'), isNull);
    expect((await repo.readOperation('sync-1'))?.entityId, 'note-1');
  });

  test(
    'second operation failure rolls back earlier operation and run',
    () async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = LocalOplogRepository(db);
      await repo.putBatch(
        operations: [SyncOperation.fromJson(syncJson(id: 'existing'))],
        runs: [],
      );
      final conflicting = syncJson(id: 'existing')..['entityId'] = 'changed';
      await expectLater(
        repo.putBatch(
          operations: [
            SyncOperation.fromJson(syncJson(id: 'fresh')),
            SyncOperation.fromJson(conflicting),
          ],
          runs: [AiRunLedger.fromJson(ledgerJson())],
        ),
        throwsStateError,
      );
      expect(await repo.readOperation('fresh'), isNull);
      expect(await repo.readRun('run-1'), isNull);
    },
  );

  test('unknown states and outcomes never enter oplog', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LocalOplogRepository(db);
    await expectLater(
      repo.putBatch(
        operations: [SyncOperation.fromJson(syncJson(state: 'future_state'))],
        runs: [],
      ),
      throwsFormatException,
    );
    await expectLater(
      repo.putBatch(
        operations: [SyncOperation.fromJson(syncJson())],
        runs: [AiRunLedger.fromJson(ledgerJson(outcome: 'future_outcome'))],
      ),
      throwsFormatException,
    );
    expect(await repo.listOperations(), isEmpty);
    expect(await repo.listRuns(), isEmpty);
  });

  test('corrupt JSON and mismatched row identity fail closed on read', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LocalOplogRepository(db);
    await repo.putBatch(
      operations: [SyncOperation.fromJson(syncJson())],
      runs: [AiRunLedger.fromJson(ledgerJson())],
    );
    await db.customStatement(
      "UPDATE sync_operations SET payload_json = '{' WHERE id = 'sync-1'",
    );
    await expectLater(repo.readOperation('sync-1'), throwsFormatException);
    await db.customStatement(
      "UPDATE ai_run_ledgers SET content_hash = '${'c' * 64}' WHERE id = 'run-1'",
    );
    await expectLater(repo.readRun('run-1'), throwsFormatException);
  });
}
