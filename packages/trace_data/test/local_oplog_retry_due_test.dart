import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> dueJson({
  required String id,
  String state = 'failed',
  int retryCount = 0,
  String createdAt = '2026-09-25T12:01:00Z',
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'e' * 64,
  'entityType': 'study_note',
  'entityId': 'note-$id',
  'mutationType': 'insert',
  'payload': <String, Object?>{'text': 'saved'},
  'localVersion': 1,
  'syncState': state,
  'retryCount': retryCount,
  'createdAt': createdAt,
};

Future<LocalOplogRepository> openDueOplogWith(
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
  test('listFailedWithinBudget keeps ordered retry candidates only', () async {
    final oplog = await openDueOplogWith([
      dueJson(id: 'due-c', retryCount: 1, createdAt: '2026-09-25T12:03:00Z'),
      dueJson(id: 'due-over', retryCount: 6),
      dueJson(id: 'due-b', retryCount: 2, createdAt: '2026-09-25T12:02:00Z'),
      dueJson(id: 'due-synced', state: 'synced'),
      dueJson(id: 'due-pending', state: 'pending'),
      dueJson(id: 'due-a', retryCount: 0, createdAt: '2026-09-25T12:01:00Z'),
    ]);
    final due = await oplog.listFailedWithinBudget(maxRetries: 5);
    expect(due.map((op) => op.operationId).toList(), [
      'due-a',
      'due-b',
      'due-c',
    ]);
    expect(due.every((op) => op.syncState == SyncState.failed), isTrue);
    expect(due.every((op) => op.retryCount <= 5), isTrue);
  });

  test('listFailedWithinBudget with negative budget fails closed', () async {
    final oplog = await openDueOplogWith([dueJson(id: 'due-1')]);
    await expectLater(
      oplog.listFailedWithinBudget(maxRetries: -1),
      throwsArgumentError,
    );
    expect((await oplog.readOperation('due-1'))?.syncState, SyncState.failed);
  });

  test('nextRetryAtUtc maps failure time through the backoff ladder', () async {
    expect(
      LocalOplogRepository.nextRetryAtUtc(
        failedAtUtc: '2026-09-25T12:00:00Z',
        retryCount: 0,
      ),
      '2026-09-25T12:00:10.000Z',
    );
    expect(
      LocalOplogRepository.nextRetryAtUtc(
        failedAtUtc: '2026-09-25T12:00:00Z',
        retryCount: 1,
      ),
      '2026-09-25T12:00:20.000Z',
    );
    expect(
      LocalOplogRepository.nextRetryAtUtc(
        failedAtUtc: '2026-09-25T12:00:00Z',
        retryCount: 30,
      ),
      '2026-09-25T12:05:00.000Z',
    );
  });

  test('nextRetryAtUtc rejects non-UTC input and negative count', () async {
    expect(
      () => LocalOplogRepository.nextRetryAtUtc(
        failedAtUtc: '2026-09-25T12:00:00',
        retryCount: 0,
      ),
      throwsFormatException,
    );
    expect(
      () => LocalOplogRepository.nextRetryAtUtc(
        failedAtUtc: '2026-09-25T12:00:00Z',
        retryCount: -1,
      ),
      throwsArgumentError,
    );
  });
}
