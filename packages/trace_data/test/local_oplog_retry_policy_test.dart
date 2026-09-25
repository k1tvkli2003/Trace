import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> retryJson({
  String id = 'retry-1',
  String state = 'failed',
  int retryCount = 0,
}) => {
  'operationId': id,
  'version': 1,
  'contentHash': 'd' * 64,
  'entityType': 'study_note',
  'entityId': 'note-$id',
  'mutationType': 'insert',
  'payload': <String, Object?>{'text': 'saved'},
  'localVersion': 1,
  'syncState': state,
  'retryCount': retryCount,
  'createdAt': '2026-09-25T12:00:00Z',
};

Future<LocalOplogRepository> openRetryRepository({
  int retryCount = 0,
  String state = 'failed',
}) async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final repository = LocalOplogRepository(database);
  await repository.putBatch(
    operations: [
      SyncOperation.fromJson(retryJson(retryCount: retryCount, state: state)),
    ],
    runs: [],
  );
  return repository;
}

void main() {
  test('failed row within budget requeues to pending', () async {
    final repository = await openRetryRepository(retryCount: 1);
    final requeued = await repository.requeueFailed('retry-1', maxRetries: 2);
    expect(requeued.syncState, SyncState.pending);
    expect(requeued.retryCount, 1);
  });

  test('failed row over budget stays failed as dead-letter', () async {
    final repository = await openRetryRepository(retryCount: 3);
    await expectLater(
      repository.requeueFailed('retry-1', maxRetries: 2),
      throwsStateError,
    );
    expect(
      (await repository.readOperation('retry-1'))?.syncState,
      SyncState.failed,
    );
    expect((await repository.readOperation('retry-1'))?.retryCount, 3);
  });

  test('invalid retry budget fails closed', () async {
    final repository = await openRetryRepository(retryCount: 0);
    await expectLater(
      repository.requeueFailed('retry-1', maxRetries: -1),
      throwsArgumentError,
    );
    expect(
      (await repository.readOperation('retry-1'))?.syncState,
      SyncState.failed,
    );
    final stored = await repository.readOperation('retry-1');
    expect(stored, isNotNull);
    expect(
      () => LocalOplogRepository.canRequeue(stored!, maxRetries: -1),
      throwsArgumentError,
    );
  });

  test('pure helper agrees with stored failed rows', () async {
    final repository = await openRetryRepository(retryCount: 2);
    final stored = await repository.readOperation('retry-1');
    expect(stored, isNotNull);
    expect(LocalOplogRepository.canRequeue(stored!, maxRetries: 2), isTrue);
    expect(LocalOplogRepository.canRequeue(stored, maxRetries: 1), isFalse);
  });
}
