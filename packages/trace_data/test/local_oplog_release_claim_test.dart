import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> releaseClaimJson({
  required String id,
  String state = 'pending',
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
  'retryCount': 1,
  'createdAt': '2026-09-25T12:01:00Z',
};

Future<LocalOplogRepository> openReleaseClaimRepository() async {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final repository = LocalOplogRepository(database);
  await repository.putBatch(
    operations: [SyncOperation.fromJson(releaseClaimJson(id: 'release-1'))],
    runs: [],
  );
  await repository.claimPending('release-1');
  return repository;
}

void main() {
  test('releaseClaim returns in-flight work to pending', () async {
    final repository = await openReleaseClaimRepository();
    final released = await repository.releaseClaim('release-1');
    expect(released.syncState, SyncState.pending);
    expect(released.retryCount, 1);
    expect(
      (await repository.readOperation('release-1'))?.syncState,
      SyncState.pending,
    );
    expect(await repository.claimNext(), isNotNull);
  });

  test('releaseClaim fails closed on wrong-state rows', () async {
    final repository = await openReleaseClaimRepository();
    await repository.releaseClaim('release-1');
    expect(
      () => repository.releaseClaim('release-1'),
      throwsA(isA<StateError>()),
    );
  });

  test('releaseClaim fails closed on absent rows', () async {
    final repository = await openReleaseClaimRepository();
    expect(
      () => repository.releaseClaim('release-absent'),
      throwsA(isA<StateError>()),
    );
  });
}
