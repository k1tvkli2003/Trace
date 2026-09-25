import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> queueJson({
  required String id,
  required String createdAt,
  String state = 'pending',
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'c' * 64,
  'entityType': 'study_note',
  'entityId': 'note-$id',
  'mutationType': 'insert',
  'payload': <String, Object?>{'text': 'saved'},
  'localVersion': 1,
  'syncState': state,
  'retryCount': 0,
  'createdAt': createdAt,
};

Future<LocalOplogRepository> openQueueRepository() async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final repository = LocalOplogRepository(database);
  await repository.putBatch(
    operations: [
      SyncOperation.fromJson(
        queueJson(id: 'queue-2', createdAt: '2026-09-25T12:02:00Z'),
      ),
      SyncOperation.fromJson(
        queueJson(id: 'queue-1', createdAt: '2026-09-25T12:01:00Z'),
      ),
      SyncOperation.fromJson(
        queueJson(id: 'queue-3', createdAt: '2026-09-25T12:01:00Z'),
      ),
      SyncOperation.fromJson(
        queueJson(
          id: 'queue-late',
          createdAt: '2026-09-25T12:03:00Z',
          state: 'synced',
        ),
      ),
    ],
    runs: [],
  );
  await repository.claimPending('queue-2');
  return repository;
}

void main() {
  test('pending queue returns createdAt then operationId order', () async {
    final repository = await openQueueRepository();
    final queued = await repository.listReadyToClaim();
    expect(queued.map((operation) => operation.operationId).toList(), [
      'queue-1',
      'queue-3',
    ]);
  });

  test('pending queue honors limit from the head of the queue', () async {
    final repository = await openQueueRepository();
    final queued = await repository.listReadyToClaim(limit: 1);
    expect(queued.map((operation) => operation.operationId).toList(), [
      'queue-1',
    ]);
  });

  test('pending queue rejects invalid limit', () async {
    final repository = await openQueueRepository();
    await expectLater(
      repository.listReadyToClaim(limit: 0),
      throwsArgumentError,
    );
  });

  test('empty pending queue returns empty', () async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalOplogRepository(database);
    expect(await repository.listReadyToClaim(), isEmpty);
  });
}
