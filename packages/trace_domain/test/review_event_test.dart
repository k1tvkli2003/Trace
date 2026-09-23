import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'event-1',
    'version': 1,
    'contentHash': 'f' * 64,
    'reviewItemId': 'review-1',
    'rating': 'hard',
    'occurredAt': '2026-09-24T10:35:00Z',
    'previousDueAt': '2026-09-24T10:30:00Z',
    'nextDueAt': '2026-09-25T10:35:00Z',
    'deviceId': 'device-1',
    'schedulerVersion': 'fixed-ladder-v1',
  };

  test('ReviewEvent round-trips append-only schedule evidence', () {
    final event = ReviewEvent.fromJson(fixture);
    expect(event.rating, ReviewRating.hard);
    expect(event.occurredAt.isUtc, isTrue);
    expect(event.toJson(), fixture);
  });

  test('unknown rating remains unsupported and round-trips', () {
    final json = {...fixture, 'rating': 'future_rating'};
    final event = ReviewEvent.fromJson(json);
    expect(event.rating, ReviewRating.unsupported);
    expect(event.toJson(), json);
  });

  test('ReviewEvent rejects non-UTC timestamps or next due before event', () {
    expect(
      () => ReviewEvent.fromJson({
        ...fixture,
        'occurredAt': '2026-09-24T10:35:00+03:30',
      }),
      throwsFormatException,
    );
    expect(
      () => ReviewEvent.fromJson({
        ...fixture,
        'nextDueAt': '2026-09-24T10:34:00Z',
      }),
      throwsFormatException,
    );
  });
}
