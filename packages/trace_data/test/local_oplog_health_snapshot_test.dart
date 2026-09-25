import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> healthJson({
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

Future<LocalOplogRepository> openHealthOplogWith(
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
  test('outboxHealth splits actionable backlog in one snapshot', () async {
    final oplog = await openHealthOplogWith([
      healthJson(id: 'health-pending', state: 'pending'),
      healthJson(id: 'health-flight', state: 'in_flight'),
      healthJson(id: 'health-retry', state: 'failed', retryCount: 2),
      healthJson(id: 'health-dead', state: 'failed', retryCount: 6),
      healthJson(id: 'health-synced', state: 'synced'),
      healthJson(id: 'health-tomb', state: 'tombstone'),
    ]);

    final health = await oplog.outboxHealth();

    expect(health.pending, 1);
    expect(health.inFlight, 1);
    expect(health.failedRetryable, 1);
    expect(health.failedDeadLetter, 1);
  });

  test(
    'outboxHealth splits failed rows on the retry budget boundary',
    () async {
      final oplog = await openHealthOplogWith([
        healthJson(id: 'health-at', state: 'failed', retryCount: 5),
        healthJson(id: 'health-above', state: 'failed', retryCount: 6),
        healthJson(id: 'health-narrow-retry', state: 'failed', retryCount: 2),
      ]);

      final atDefault = await oplog.outboxHealth();
      final atNarrow = await oplog.outboxHealth(maxRetries: 2);

      expect(atDefault.failedRetryable, 2);
      expect(atDefault.failedDeadLetter, 1);
      expect(atNarrow.failedRetryable, 1);
      expect(atNarrow.failedDeadLetter, 2);
    },
  );

  test('outboxHealth rejects negative budget', () async {
    final oplog = await openHealthOplogWith([
      healthJson(id: 'health-1', state: 'failed', retryCount: 6),
    ]);
    expect(() => oplog.outboxHealth(maxRetries: -1), throwsArgumentError);
  });
}
