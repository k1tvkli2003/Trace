import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> snapshotJson({
  required String id,
  String state = 'pending',
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
  'retryCount': 0,
  'createdAt': createdAt,
};

Future<LocalOplogRepository> openSnapshotOplogWith(
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
  test('countByState reports every bucket for mixed rows', () async {
    final oplog = await openSnapshotOplogWith([
      snapshotJson(id: 'snap-p1'),
      snapshotJson(id: 'snap-p2'),
      snapshotJson(id: 'snap-f1', state: 'in_flight'),
      snapshotJson(id: 'snap-d1', state: 'failed'),
      snapshotJson(id: 'snap-s1', state: 'synced'),
      snapshotJson(id: 'snap-t1', state: 'tombstone'),
    ]);
    final counts = await oplog.countByState();
    expect(counts[SyncState.pending], 2);
    expect(counts[SyncState.inFlight], 1);
    expect(counts[SyncState.failed], 1);
    expect(counts[SyncState.synced], 1);
    expect(counts[SyncState.tombstone], 1);
    expect(counts[SyncState.unsupported], 0);
    expect(counts.values.fold(0, (a, b) => a + b), 6);
  });

  test('countByState on empty outbox returns all-zero buckets', () async {
    final oplog = await openSnapshotOplogWith([]);
    final counts = await oplog.countByState();
    expect(counts.keys.toSet(), SyncState.values.toSet());
    expect(counts.values.every((count) => count == 0), isTrue);
  });

  test('countByState reflects transitions on recount', () async {
    final oplog = await openSnapshotOplogWith([snapshotJson(id: 'snap-1')]);
    expect((await oplog.countByState())[SyncState.pending], 1);
    await oplog.claimPending('snap-1');
    final counts = await oplog.countByState();
    expect(counts[SyncState.pending], 0);
    expect(counts[SyncState.inFlight], 1);
  });
}
