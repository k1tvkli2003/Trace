import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> deadLetterJson({
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

Future<LocalOplogRepository> openDeadLetterOplogWith(
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
    'listFailedOverBudget returns only exhausted failed rows in order',
    () async {
      final oplog = await openDeadLetterOplogWith([
        deadLetterJson(
          id: 'dead-b',
          retryCount: 6,
          createdAt: '2026-09-25T12:02:00Z',
        ),
        deadLetterJson(
          id: 'dead-ok',
          retryCount: 5,
          createdAt: '2026-09-25T12:00:30Z',
        ),
        deadLetterJson(id: 'dead-pending', state: 'pending', retryCount: 9),
        deadLetterJson(
          id: 'dead-a',
          retryCount: 7,
          createdAt: '2026-09-25T12:01:00Z',
        ),
      ]);

      final dead = await oplog.listFailedOverBudget();

      expect(dead.map((op) => op.operationId).toList(), ['dead-a', 'dead-b']);
      expect(dead.every((op) => op.syncState == SyncState.failed), isTrue);
    },
  );

  test('listFailedOverBudget rejects negative budget', () async {
    final oplog = await openDeadLetterOplogWith([
      deadLetterJson(id: 'dead-1', retryCount: 6),
    ]);
    expect(
      () => oplog.listFailedOverBudget(maxRetries: -1),
      throwsArgumentError,
    );
  });
}
