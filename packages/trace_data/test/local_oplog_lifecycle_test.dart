import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> lifecycleJson({
  String id = 'lifecycle-1',
  String state = 'pending',
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'a' * 64,
  'entityType': 'study_note',
  'entityId': 'note-1',
  'mutationType': 'insert',
  'payload': <String, Object?>{'text': 'saved'},
  'localVersion': 1,
  'syncState': state,
  'retryCount': 0,
  'createdAt': '2026-09-25T12:00:00Z',
};

Future<LocalOplogRepository> openRepository() async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final repository = LocalOplogRepository(database);
  await repository.putBatch(
    operations: [SyncOperation.fromJson(lifecycleJson())],
    runs: [],
  );
  return repository;
}

void main() {
  test('pending can be claimed exactly once by an in-flight worker', () async {
    final repository = await openRepository();
    final claimed = await repository.claimPending('lifecycle-1');
    expect(claimed.syncState, SyncState.inFlight);
    expect(claimed.retryCount, 0);
    expect(claimed.operationId, 'lifecycle-1');
    expect(claimed.entityId, 'note-1');
    expect(
      (await repository.readOperation('lifecycle-1'))?.syncState,
      SyncState.inFlight,
    );
  });

  test('in-flight ack records synced without changing retry count', () async {
    final repository = await openRepository();
    await repository.claimPending('lifecycle-1');
    final acked = await repository.acknowledge('lifecycle-1');
    expect(acked.syncState, SyncState.synced);
    expect(acked.retryCount, 0);
    expect(
      (await repository.readOperation('lifecycle-1'))?.syncState,
      SyncState.synced,
    );
  });

  test('in-flight failure records failed and increments retry count', () async {
    final repository = await openRepository();
    await repository.claimPending('lifecycle-1');
    final failed = await repository.recordFailure('lifecycle-1');
    expect(failed.syncState, SyncState.failed);
    expect(failed.retryCount, 1);
    expect((await repository.readOperation('lifecycle-1'))?.retryCount, 1);
  });

  test('failed work can be requeued to pending with retry preserved', () async {
    final repository = await openRepository();
    await repository.claimPending('lifecycle-1');
    await repository.recordFailure('lifecycle-1');
    final requeued = await repository.requeueFailed('lifecycle-1');
    expect(requeued.syncState, SyncState.pending);
    expect(requeued.retryCount, 1);
    await repository.claimPending('lifecycle-1');
    await repository.acknowledge('lifecycle-1');
    expect(
      (await repository.readOperation('lifecycle-1'))?.toJson()['syncState'],
      'synced',
    );
  });

  test('illegal transitions fail closed', () async {
    final repository = await openRepository();
    await expectLater(repository.acknowledge('lifecycle-1'), throwsStateError);
    await repository.claimPending('lifecycle-1');
    await expectLater(repository.claimPending('lifecycle-1'), throwsStateError);
    await repository.acknowledge('lifecycle-1');
    await expectLater(
      repository.recordFailure('lifecycle-1'),
      throwsStateError,
    );
    await expectLater(
      repository.requeueFailed('lifecycle-1'),
      throwsStateError,
    );
  });

  test('stale same-ID replay cannot overwrite a transitioned row', () async {
    final repository = await openRepository();
    await repository.claimPending('lifecycle-1');
    await expectLater(
      repository.putBatch(
        operations: [SyncOperation.fromJson(lifecycleJson())],
        runs: [],
      ),
      throwsStateError,
    );
    expect(
      (await repository.readOperation('lifecycle-1'))?.syncState,
      SyncState.inFlight,
    );
  });
}
