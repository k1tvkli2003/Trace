import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> readyJson({
  required String id,
  String state = 'failed',
  int retryCount = 0,
  String createdAt = '2026-09-25T12:01:00Z',
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'f' * 64,
  'entityType': 'study_note',
  'entityId': 'note-$id',
  'mutationType': 'insert',
  'payload': <String, Object?>{'text': 'saved'},
  'localVersion': 1,
  'syncState': state,
  'retryCount': retryCount,
  'createdAt': createdAt,
};

Future<LocalOplogRepository> openReadyOplogWith(
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
    'listDueFailedWithinBudget returns ready failed rows in queue order',
    () async {
      final oplog = await openReadyOplogWith([
        readyJson(id: 'ready-c', createdAt: '2026-09-25T12:03:00Z'),
        readyJson(id: 'ready-future', createdAt: '2026-09-25T12:04:00Z'),
        readyJson(id: 'ready-over', retryCount: 6),
        readyJson(id: 'ready-b', createdAt: '2026-09-25T12:02:00Z'),
        readyJson(id: 'ready-pending', state: 'pending'),
        readyJson(id: 'ready-nodue', createdAt: '2026-09-25T12:00:30Z'),
        readyJson(id: 'ready-a', createdAt: '2026-09-25T12:01:00Z'),
      ]);

      final ready = await oplog.listDueFailedWithinBudget(
        nowUtc: '2026-09-25T12:00:30Z',
        dueAtUtcByOperationId: {
          'ready-a': '2026-09-25T12:00:30Z',
          'ready-b': '2026-09-25T12:00:10Z',
          'ready-c': '2026-09-25T12:00:30Z',
          'ready-future': '2026-09-25T12:00:31Z',
          'ready-over': '2026-09-25T12:00:00Z',
          'ready-pending': '2026-09-25T12:00:00Z',
          // Missing due input must exclude candidate instead of inventing a due time.
        },
      );

      expect(ready.map((op) => op.operationId).toList(), [
        'ready-a',
        'ready-b',
        'ready-c',
      ]);
      expect(ready.every((op) => op.syncState == SyncState.failed), isTrue);
    },
  );

  test(
    'listDueFailedWithinBudget rejects invalid now and due timestamps',
    () async {
      final oplog = await openReadyOplogWith([readyJson(id: 'ready-1')]);
      expect(
        () => oplog.listDueFailedWithinBudget(
          nowUtc: '2026-09-25T12:00:00',
          dueAtUtcByOperationId: {'ready-1': '2026-09-25T12:00:00Z'},
        ),
        throwsFormatException,
      );
      expect(
        () => oplog.listDueFailedWithinBudget(
          nowUtc: '2026-09-25T12:00:00Z',
          dueAtUtcByOperationId: {'ready-1': '2026-09-25T12:00:00'},
        ),
        throwsFormatException,
      );
    },
  );

  test('listDueFailedWithinBudget rejects negative budget', () async {
    final oplog = await openReadyOplogWith([readyJson(id: 'ready-1')]);
    expect(
      () => oplog.listDueFailedWithinBudget(
        nowUtc: '2026-09-25T12:00:00Z',
        maxRetries: -1,
        dueAtUtcByOperationId: {'ready-1': '2026-09-25T12:00:00Z'},
      ),
      throwsArgumentError,
    );
  });
}
