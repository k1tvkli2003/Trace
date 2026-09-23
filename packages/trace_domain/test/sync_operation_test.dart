import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'operationId': 'op-1',
    'version': 1,
    'contentHash': 'b' * 64,
    'entityType': 'highlight',
    'entityId': 'highlight-1',
    'mutationType': 'update',
    'payload': {'color': 'amber'},
    'localVersion': 3,
    'syncState': 'pending',
    'retryCount': 0,
    'createdAt': '2026-09-23T11:10:00Z',
  };

  test('SyncOperation round-trips idempotent oplog data', () {
    final operation = SyncOperation.fromJson(fixture);
    expect(operation.mutationType, SyncMutationType.update);
    expect(operation.toJson(), fixture);
  });

  test('SyncOperation snapshots nested oplog payload', () {
    final payload = <String, Object?>{
      'fields': <String, Object?>{
        'tags': <String>['stable'],
      },
    };
    final operation = SyncOperation.fromJson({...fixture, 'payload': payload});
    (payload['fields'] as Map<String, Object?>)['tags'] = ['changed'];
    expect(
      ((operation.payload['fields'] as Map<String, Object?>)['tags'] as List)
          .single,
      'stable',
    );
    expect(
      () =>
          ((operation.payload['fields'] as Map<String, Object?>)['tags']
                  as List)
              .add('changed'),
      throwsUnsupportedError,
    );
  });

  test('unknown sync tokens remain unsupported and round-trippable', () {
    final operation = SyncOperation.fromJson({
      ...fixture,
      'mutationType': 'future_mutation',
      'syncState': 'future_state',
    });
    expect(operation.mutationType, SyncMutationType.unsupported);
    expect(operation.syncState, SyncState.unsupported);
    expect(operation.toJson(), {
      ...fixture,
      'mutationType': 'future_mutation',
      'syncState': 'future_state',
    });
  });

  test('SyncOperation rejects invalid retry and local version numbers', () {
    for (final key in ['localVersion', 'retryCount']) {
      expect(
        () => SyncOperation.fromJson({...fixture, key: -1}),
        throwsFormatException,
        reason: key,
      );
    }
  });
}
