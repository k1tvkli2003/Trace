import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> claimNextJson({
  required String id,
  required String createdAt,
  String state = 'pending',
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
  'retryCount': 0,
  'createdAt': createdAt,
};

Future<LocalOplogRepository> openClaimNextRepository() async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final repository = LocalOplogRepository(database);
  await repository.putBatch(
    operations: [
      SyncOperation.fromJson(
        claimNextJson(id: 'claim-2', createdAt: '2026-09-25T12:02:00Z'),
      ),
      SyncOperation.fromJson(
        claimNextJson(id: 'claim-1', createdAt: '2026-09-25T12:01:00Z'),
      ),
    ],
    runs: [],
  );
  return repository;
}

void main() {
  test('claimNext atomically claims the queue head', () async {
    final repository = await openClaimNextRepository();
    final claimed = await repository.claimNext();
    expect(claimed, isNotNull);
    expect(claimed!.operationId, 'claim-1');
    expect(claimed.syncState, SyncState.inFlight);
    expect(
      (await repository.readOperation('claim-1'))?.syncState,
      SyncState.inFlight,
    );
  });

  test('claimNext skips already-claimed rows', () async {
    final repository = await openClaimNextRepository();
    await repository.claimNext();
    final second = await repository.claimNext();
    expect(second, isNotNull);
    expect(second!.operationId, 'claim-2');
  });

  test('claimNext returns null when the queue is empty', () async {
    final repository = await openClaimNextRepository();
    await repository.claimNext();
    await repository.claimNext();
    expect(await repository.claimNext(), isNull);
  });
}
