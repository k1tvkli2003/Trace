import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'library-1',
    'version': 1,
    'contentHash': 'a' * 64,
    'title': 'زیست شناسی',
    'language': 'fa',
    'ownerId': 'owner-1',
    'defaultNodeId': null,
    'createdAt': '2026-09-23T10:30:00Z',
  };

  test('LibraryItem round-trips owner and UTC creation identity', () {
    final item = LibraryItem.fromJson(fixture);
    expect(item.ownerId, 'owner-1');
    expect(item.createdAt.isUtc, isTrue);
    expect(item.toJson(), fixture);
    expect(LibraryItem.fromJson(item.toJson()).toJson(), fixture);
  });

  test('LibraryItem preserves approved default node', () {
    final json = {...fixture, 'defaultNodeId': 'node-1'};
    expect(LibraryItem.fromJson(json).toJson(), json);
  });

  test(
    'LibraryItem rejects malformed hash, version, owner and default node',
    () {
      for (final (key, value) in <(String, Object?)>[
        ('contentHash', 'not-a-hash'),
        ('version', 0),
        ('ownerId', ''),
        ('defaultNodeId', ''),
      ]) {
        expect(
          () => LibraryItem.fromJson({...fixture, key: value}),
          throwsFormatException,
          reason: key,
        );
      }
    },
  );

  test('LibraryItem rejects non-UTC or invalid creation timestamps', () {
    for (final date in [
      '2026-09-23T10:30:00+03:30',
      'tomorrow',
      '2026-09-23',
    ]) {
      expect(
        () => LibraryItem.fromJson({...fixture, 'createdAt': date}),
        throwsFormatException,
        reason: date,
      );
    }
  });
}
