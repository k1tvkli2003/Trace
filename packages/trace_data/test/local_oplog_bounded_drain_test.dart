import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> drainJson({
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

Future<LocalOutboxWorker> openDrainWorkerWith(
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
  test('drain settles heads in createdAt then operationId order', () async {
    final worker = await openDrainWorkerWith([
      drainJson(id: 'drain-c', createdAt: '2026-09-25T12:03:00Z'),
      drainJson(id: 'drain-a', createdAt: '2026-09-25T12:01:00Z'),
      drainJson(id: 'drain-b', createdAt: '2026-09-25T12:02:00Z'),
    ]);
    final settled = await worker.drain(
      handler: (_) async => true,
      maxPasses: 10,
    );
    expect(settled.map((op) => op.operationId).toList(), [
      'drain-a',
      'drain-b',
      'drain-c',
    ]);
    expect(settled.every((op) => op.syncState == SyncState.synced), isTrue);
  });

  test('drain breaks createdAt ties by operationId order', () async {
    final worker = await openDrainWorkerWith([
      drainJson(id: 'drain-b'),
      drainJson(id: 'drain-a'),
    ]);
    final settled = await worker.drain(
      handler: (_) async => true,
      maxPasses: 10,
    );
    expect(settled.map((op) => op.operationId).toList(), [
      'drain-a',
      'drain-b',
    ]);
  });

  test('drain stops early when the queue empties', () async {
    final worker = await openDrainWorkerWith([drainJson(id: 'drain-1')]);
    final settled = await worker.drain(
      handler: (_) async => true,
      maxPasses: 10,
    );
    expect(settled.map((op) => op.operationId).toList(), ['drain-1']);
  });

  test('drain never exceeds maxPasses', () async {
    final worker = await openDrainWorkerWith([
      drainJson(id: 'd-a'),
      drainJson(id: 'd-b'),
      drainJson(id: 'd-c'),
    ]);
    final settled = await worker.drain(
      handler: (_) async => false,
      maxRetries: 5,
      maxPasses: 2,
    );
    expect(settled, hasLength(2));
  });

  test('drain returns empty without calling handler on empty queue', () async {
    final worker = await openDrainWorkerWith([]);
    var called = false;
    final settled = await worker.drain(
      handler: (_) async {
        called = true;
        return true;
      },
    );
    expect(settled, isEmpty);
    expect(called, isFalse);
  });

  test('drain with maxPasses below one fails closed', () async {
    final worker = await openDrainWorkerWith([drainJson(id: 'drain-1')]);
    expect(
      worker.drain(handler: (_) async => true, maxPasses: 0),
      throwsArgumentError,
    );
  });
}
