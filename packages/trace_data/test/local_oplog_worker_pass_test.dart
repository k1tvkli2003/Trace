import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> workerPassJson({
  required String id,
  String state = 'pending',
  int retryCount = 0,
  String createdAt = '2026-09-25T12:01:00Z',
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'a' * 64,
  'entityType': 'study_note',
  'entityId': 'note-$id',
  'mutationType': 'insert',
  'payload': <String, Object?>{'text': 'saved'},
  'localVersion': 1,
  'syncState': state,
  'retryCount': retryCount,
  'createdAt': createdAt,
};

Future<LocalOutboxWorker> openWorkerWith(
  List<Map<String, Object?>> rows,
) async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final oplog = LocalOplogRepository(database);
  await oplog.putBatch(
    operations: rows.map(SyncOperation.fromJson).toList(),
    runs: [],
  );
  return LocalOutboxWorker(oplog);
}

void main() {
  test('runNext acknowledges the head on handler success', () async {
    final worker = await openWorkerWith([workerPassJson(id: 'work-1')]);
    final settled = await worker.runNext(handler: (_) async => true);
    expect(settled?.operationId, 'work-1');
    expect(settled?.syncState, SyncState.synced);
    expect(
      (await worker.oplog.readOperation('work-1'))?.syncState,
      SyncState.synced,
    );
  });

  test('runNext requeues within budget on handler failure', () async {
    final worker = await openWorkerWith([workerPassJson(id: 'work-2')]);
    final settled = await worker.runNext(handler: (_) async => false);
    expect(settled?.operationId, 'work-2');
    expect(settled?.syncState, SyncState.pending);
    expect(settled?.retryCount, 1);
  });

  test('runNext leaves exhausted rows failed', () async {
    final worker = await openWorkerWith([
      workerPassJson(id: 'work-3', retryCount: 5),
    ]);
    final settled = await worker.runNext(
      handler: (_) async => false,
      maxRetries: 5,
    );
    expect(settled?.operationId, 'work-3');
    expect(settled?.syncState, SyncState.failed);
    expect(settled?.retryCount, 6);
  });

  test('runNext returns null when the queue is empty', () async {
    final worker = await openWorkerWith([]);
    var called = false;
    final settled = await worker.runNext(
      handler: (_) async {
        called = true;
        return true;
      },
    );
    expect(settled, isNull);
    expect(called, isFalse);
  });
}
