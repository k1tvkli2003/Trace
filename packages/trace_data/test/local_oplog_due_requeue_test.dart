import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> requeueJson({
  required String id,
  String state = 'failed',
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

Future<LocalOplogRepository> openRequeueOplogWith(
  List<Map<String, Object?>> rows,
) async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final oplog = LocalOplogRepository(database);
  await oplog.putBatch(
    operations: rows.map(SyncOperation.fromJson).toList(),
    runs: [],
  );
  return oplog;
}

void main() {
  test(
    'requeueDueFailedWithinBudget requeues only due failed rows in order',
    () async {
      final oplog = await openRequeueOplogWith([
        requeueJson(id: 'due-c', createdAt: '2026-09-25T12:03:00Z'),
        requeueJson(id: 'due-future', createdAt: '2026-09-25T12:04:00Z'),
        requeueJson(id: 'due-over', retryCount: 6),
        requeueJson(id: 'due-b', createdAt: '2026-09-25T12:02:00Z'),
        requeueJson(id: 'due-pending', state: 'pending'),
        requeueJson(id: 'due-nodue', createdAt: '2026-09-25T12:00:30Z'),
        requeueJson(id: 'due-a', createdAt: '2026-09-25T12:01:00Z'),
      ]);

      final requeued = await oplog.requeueDueFailedWithinBudget(
        nowUtc: '2026-09-25T12:00:30Z',
        dueAtUtcByOperationId: {
          'due-a': '2026-09-25T12:00:30Z',
          'due-b': '2026-09-25T12:00:10Z',
          'due-c': '2026-09-25T12:00:30Z',
          'due-future': '2026-09-25T12:00:31Z',
          'due-over': '2026-09-25T12:00:00Z',
          'due-pending': '2026-09-25T12:00:00Z',
          // Missing due input must leave the candidate failed.
        },
      );

      expect(requeued.map((op) => op.operationId).toList(), [
        'due-a',
        'due-b',
        'due-c',
      ]);
      expect(requeued.every((op) => op.syncState == SyncState.pending), isTrue);
      expect(
        (await oplog.readOperation('due-a'))?.syncState,
        SyncState.pending,
      );
      expect(
        (await oplog.readOperation('due-future'))?.syncState,
        SyncState.failed,
      );
      expect(
        (await oplog.readOperation('due-nodue'))?.syncState,
        SyncState.failed,
      );
      expect(
        (await oplog.readOperation('due-over'))?.syncState,
        SyncState.failed,
      );
      expect(
        (await oplog.readOperation('due-pending'))?.syncState,
        SyncState.pending,
      );
    },
  );

  test(
    'requeueDueFailedWithinBudget rejects invalid input before writes',
    () async {
      final oplog = await openRequeueOplogWith([requeueJson(id: 'due-1')]);
      expect(
        () => oplog.requeueDueFailedWithinBudget(
          nowUtc: '2026-09-25T12:00:00',
          dueAtUtcByOperationId: {'due-1': '2026-09-25T12:00:00Z'},
        ),
        throwsFormatException,
      );
      expect(
        () => oplog.requeueDueFailedWithinBudget(
          nowUtc: '2026-09-25T12:00:00Z',
          maxRetries: -1,
          dueAtUtcByOperationId: {'due-1': '2026-09-25T12:00:00Z'},
        ),
        throwsArgumentError,
      );
      expect((await oplog.readOperation('due-1'))?.syncState, SyncState.failed);
    },
  );
}
