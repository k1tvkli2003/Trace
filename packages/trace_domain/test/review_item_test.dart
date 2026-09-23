import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'review-1',
    'version': 1,
    'contentHash': 'e' * 64,
    'targetType': 'lesson_box',
    'targetId': 'lesson-block-1',
    'dueAt': '2026-09-24T10:30:00Z',
    'intervalDays': 1,
    'ease': 2.5,
    'lapses': 0,
    'state': 'active',
    'schedulerVersion': 'fixed-ladder-v1',
  };

  test('ReviewItem round-trips deterministic schedule state', () {
    final item = ReviewItem.fromJson(fixture);
    expect(item.targetType, ReviewTargetType.lessonBox);
    expect(item.dueAt.isUtc, isTrue);
    expect(item.toJson(), fixture);
  });

  test('unknown target and state remain safe unsupported values', () {
    final json = {
      ...fixture,
      'targetType': 'future_target',
      'state': 'future_state',
    };
    final item = ReviewItem.fromJson(json);
    expect(item.targetType, ReviewTargetType.unsupported);
    expect(item.state, ReviewItemState.unsupported);
    expect(item.toJson(), json);
  });

  test('ReviewItem rejects invalid scheduler numbers and due time', () {
    for (final (key, value) in <(String, Object?)>[
      ('intervalDays', -1),
      ('ease', 0.9),
      ('lapses', -1),
      ('dueAt', 'local-time'),
    ]) {
      expect(
        () => ReviewItem.fromJson({...fixture, key: value}),
        throwsFormatException,
        reason: key,
      );
    }
  });
}
