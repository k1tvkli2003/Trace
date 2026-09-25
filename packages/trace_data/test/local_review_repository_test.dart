import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> itemJson({
  String id = 'review-1',
  String dueAt = '2026-09-24T10:30:00Z',
  int intervalDays = 1,
  double ease = 2.5,
  int lapses = 0,
  String targetType = 'lesson_box',
  String state = 'active',
}) => {
  'id': id,
  'version': 1,
  'contentHash': 'e' * 64,
  'targetType': targetType,
  'targetId': 'lesson-block-1',
  'dueAt': dueAt,
  'intervalDays': intervalDays,
  'ease': ease,
  'lapses': lapses,
  'state': state,
  'schedulerVersion': 'fixed-ladder-v1',
};

Map<String, Object?> eventJson({
  String id = 'event-1',
  String reviewItemId = 'review-1',
  String rating = 'good',
  String occurredAt = '2026-09-24T10:35:00Z',
  String? previousDueAt = '2026-09-24T10:30:00Z',
  String nextDueAt = '2026-09-27T10:35:00Z',
}) => {
  'id': id,
  'version': 1,
  'contentHash': 'f' * 64,
  'reviewItemId': reviewItemId,
  'rating': rating,
  'occurredAt': occurredAt,
  'previousDueAt': previousDueAt,
  'nextDueAt': nextDueAt,
  'deviceId': 'device-1',
  'schedulerVersion': 'fixed-ladder-v1',
};

TraceDatabase _database() {
  final database = TraceDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  return database;
}

void main() {
  test('review item persists with replay-safe immutable put', () async {
    final repository = LocalReviewRepository(_database());
    final item = ReviewItem.fromJson(itemJson());
    await repository.putReviewItem(item);
    expect((await repository.readReviewItem(item.id))?.toJson(), itemJson());
    await repository.putReviewItem(item);
  });

  test(
    'replaying original item after an event leaves projection intact',
    () async {
      final repository = LocalReviewRepository(_database());
      final original = ReviewItem.fromJson(itemJson());
      await repository.putReviewItem(original);
      await repository.appendEvent(ReviewEvent.fromJson(eventJson()));
      await repository.putReviewItem(original);
      expect((await repository.readReviewItem(original.id))?.intervalDays, 3);
    },
  );

  test('duplicate item id with different payload is rejected', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    await expectLater(
      repository.putReviewItem(
        ReviewItem.fromJson(itemJson(dueAt: '2026-09-25T10:30:00Z')),
      ),
      throwsStateError,
    );
  });

  test('unsupported target or state is rejected fail-closed', () async {
    final repository = LocalReviewRepository(_database());
    await expectLater(
      repository.putReviewItem(
        ReviewItem.fromJson(itemJson(targetType: 'future_target')),
      ),
      throwsFormatException,
    );
    await expectLater(
      repository.putReviewItem(
        ReviewItem.fromJson(itemJson(state: 'future_state')),
      ),
      throwsFormatException,
    );
  });

  test('due query returns only active items due at or before now', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(
      ReviewItem.fromJson(itemJson(id: 'due-1', dueAt: '2026-09-24T09:00:00Z')),
    );
    await repository.putReviewItem(
      ReviewItem.fromJson(
        itemJson(id: 'future-1', dueAt: '2026-09-25T09:00:00Z'),
      ),
    );
    await repository.putReviewItem(
      ReviewItem.fromJson(
        itemJson(
          id: 'suspended-1',
          dueAt: '2026-09-24T08:00:00Z',
          state: 'suspended',
        ),
      ),
    );
    final due = await repository.listDueItems('2026-09-24T10:30:00Z');
    expect(due.map((item) => item.id), ['due-1']);
  });

  test('due query compares instants across different UTC precisions', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(
      ReviewItem.fromJson(
        itemJson(id: 'due-whole', dueAt: '2026-09-24T10:30:00Z'),
      ),
    );
    await repository.putReviewItem(
      ReviewItem.fromJson(
        itemJson(id: 'due-fraction', dueAt: '2026-09-24T10:30:00.250Z'),
      ),
    );
    expect(
      (await repository.listDueItems(
        '2026-09-24T10:30:00.500Z',
      )).map((item) => item.id),
      ['due-whole', 'due-fraction'],
    );
  });

  test('zero interval begins at first rung without immediate hard retry', () {
    final item = ReviewItem.fromJson(
      itemJson(intervalDays: 0, dueAt: '2026-09-24T10:30:00Z'),
    );
    final now = DateTime.utc(2026, 9, 24, 10, 30);
    final good = LocalReviewRepository.projectNext(
      current: item,
      rating: ReviewRating.good,
      occurredAt: now,
    );
    final hard = LocalReviewRepository.projectNext(
      current: item,
      rating: ReviewRating.hard,
      occurredAt: now,
    );
    expect(good.intervalDays, 1);
    expect(good.rawDueAt, '2026-09-25T10:30:00Z');
    expect(hard.intervalDays, 1);
    expect(hard.rawDueAt, '2026-09-25T10:30:00Z');
  });

  test('v2 first-study due preserves UTC subsecond instant', () {
    final item = LocalReviewRepository.firstStudyItem(
      id: 'fractional',
      targetId: 'lesson-block-1',
      targetType: ReviewTargetType.lessonBox,
      contentHash: 'e' * 64,
      firstStudiedAt: DateTime.utc(2026, 9, 24, 10, 30, 0, 250),
    );
    expect(item.rawDueAt, '2026-09-25T10:30:00.250Z');
    final next = LocalReviewRepository.projectNext(
      current: item,
      rating: ReviewRating.good,
      occurredAt: item.dueAt,
    );
    expect(next.rawDueAt, '2026-09-27T10:30:00.250Z');
  });

  test(
    'first study creates UTC v2 due at +1 day with immutable receipt',
    () async {
      final repository = LocalReviewRepository(_database());
      final firstStudiedAt = DateTime.utc(2026, 9, 24, 10, 30);
      final item = LocalReviewRepository.firstStudyItem(
        id: 'new-1',
        targetId: 'lesson-block-1',
        targetType: ReviewTargetType.lessonBox,
        contentHash: 'e' * 64,
        firstStudiedAt: firstStudiedAt,
      );
      expect(item.schedulerVersion, 'fixed-offset-v2');
      expect(item.rawDueAt, '2026-09-25T10:30:00Z');
      expect(item.intervalDays, 1);
      await repository.putReviewItem(item);
      await repository.putReviewItem(item);
      expect(
        (await repository.readReviewItem('new-1'))?.toJson(),
        item.toJson(),
      );
    },
  );

  test('v2 review offsets are anchored to first study, not cumulative', () {
    final firstStudy = DateTime.utc(2026, 9, 24, 10, 30);
    var item = ReviewItem.fromJson({
      ...itemJson(dueAt: '2026-09-25T10:30:00Z'),
      'schedulerVersion': 'fixed-offset-v2',
    });
    for (final (reviewedAt, expectedDue, gap) in [
      (DateTime.utc(2026, 9, 25, 10, 30), '2026-09-27T10:30:00Z', 2),
      (DateTime.utc(2026, 9, 27, 10, 30), '2026-10-01T10:30:00Z', 4),
      (DateTime.utc(2026, 10, 1, 10, 30), '2026-10-09T10:30:00Z', 8),
      (DateTime.utc(2026, 10, 9, 10, 30), '2026-10-24T10:30:00Z', 15),
    ]) {
      item = LocalReviewRepository.projectNext(
        current: item,
        rating: ReviewRating.good,
        occurredAt: reviewedAt,
      );
      expect(item.rawDueAt, expectedDue);
      expect(item.intervalDays, gap);
    }
    expect(firstStudy.add(const Duration(days: 30)), item.dueAt);
  });

  test('v2 review event advances due and duplicate ID replays once', () async {
    final repository = LocalReviewRepository(_database());
    final item = ReviewItem.fromJson({
      ...itemJson(dueAt: '2026-09-25T10:30:00Z'),
      'schedulerVersion': 'fixed-offset-v2',
    });
    await repository.putReviewItem(item);
    final event = ReviewEvent.fromJson({
      ...eventJson(
        occurredAt: '2026-09-25T10:30:00Z',
        previousDueAt: '2026-09-25T10:30:00Z',
        nextDueAt: '2026-09-27T10:30:00Z',
      ),
      'schedulerVersion': 'fixed-offset-v2',
    });
    await repository.appendEvent(event);
    await repository.appendEvent(event);
    expect((await repository.listEvents(item.id)).length, 1);
    expect((await repository.readReviewItem(item.id))?.intervalDays, 2);
    expect(
      (await repository.readReviewItem(item.id))?.rawDueAt,
      '2026-09-27T10:30:00Z',
    );
  });

  test('v2 late review retains one missed event then advances gap', () async {
    final repository = LocalReviewRepository(_database());
    final item = ReviewItem.fromJson({
      ...itemJson(dueAt: '2026-09-25T10:30:00Z'),
      'schedulerVersion': 'fixed-offset-v2',
    });
    await repository.putReviewItem(item);
    await repository.appendEvent(
      ReviewEvent.fromJson({
        ...eventJson(
          occurredAt: '2026-09-25T10:30:00Z',
          previousDueAt: '2026-09-25T10:30:00Z',
          nextDueAt: '2026-09-27T10:30:00Z',
        ),
        'schedulerVersion': 'fixed-offset-v2',
      }),
    );
    final late = ReviewEvent.fromJson({
      ...eventJson(
        id: 'late-1',
        occurredAt: '2026-09-28T10:30:00Z',
        previousDueAt: '2026-09-27T10:30:00Z',
        nextDueAt: '2026-10-02T10:30:00Z',
      ),
      'schedulerVersion': 'fixed-offset-v2',
    });
    await repository.appendEvent(late);
    final stored = await repository.readReviewItem(item.id);
    expect(stored?.rawDueAt, '2026-10-02T10:30:00Z');
    expect(stored?.intervalDays, 4);
    expect((await repository.listEvents(item.id)).length, 2);
  });

  test('v2 hard holds gap and v1 forged v2 mix is rejected', () async {
    final repository = LocalReviewRepository(_database());
    final item = ReviewItem.fromJson({
      ...itemJson(dueAt: '2026-09-25T10:30:00Z'),
      'schedulerVersion': 'fixed-offset-v2',
    });
    await repository.putReviewItem(item);
    await repository.appendEvent(
      ReviewEvent.fromJson({
        ...eventJson(
          occurredAt: '2026-09-25T10:30:00Z',
          previousDueAt: '2026-09-25T10:30:00Z',
          nextDueAt: '2026-09-27T10:30:00Z',
        ),
        'schedulerVersion': 'fixed-offset-v2',
      }),
    );
    await repository.appendEvent(
      ReviewEvent.fromJson({
        ...eventJson(
          id: 'hard-1',
          rating: 'hard',
          occurredAt: '2026-09-27T10:30:00Z',
          previousDueAt: '2026-09-27T10:30:00Z',
          nextDueAt: '2026-09-29T10:30:00Z',
        ),
        'schedulerVersion': 'fixed-offset-v2',
      }),
    );
    final stored = await repository.readReviewItem(item.id);
    expect(stored?.rawDueAt, '2026-09-29T10:30:00Z');
    expect(stored?.intervalDays, 2);
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson({
          ...eventJson(
            id: 'mix-1',
            rating: 'hard',
            occurredAt: '2026-09-29T10:30:00Z',
            previousDueAt: '2026-09-29T10:30:00Z',
            nextDueAt: '2026-10-02T10:30:00Z',
          ),
        }),
      ),
      throwsFormatException,
    );
  });

  test('v2 again resets and easy skips one milestone', () {
    final item = ReviewItem.fromJson({
      ...itemJson(dueAt: '2026-09-27T10:30:00Z', intervalDays: 2),
      'schedulerVersion': 'fixed-offset-v2',
    });
    final reviewedAt = DateTime.utc(2026, 9, 27, 10, 30);
    final again = LocalReviewRepository.projectNext(
      current: item,
      rating: ReviewRating.again,
      occurredAt: reviewedAt,
    );
    expect(again.rawDueAt, '2026-09-28T10:30:00Z');
    expect(again.lapses, 1);
    final easy = LocalReviewRepository.projectNext(
      current: item,
      rating: ReviewRating.easy,
      occurredAt: reviewedAt,
    );
    expect(easy.rawDueAt, '2026-10-05T10:30:00Z');
    expect(easy.intervalDays, 8);
  });

  test('v2 post-30-day policy doubles gaps and caps at 120 days', () {
    var item = ReviewItem.fromJson({
      ...itemJson(dueAt: '2026-10-24T10:30:00Z', intervalDays: 15),
      'schedulerVersion': 'fixed-offset-v2',
    });
    for (final (date, gap) in [
      (DateTime.utc(2026, 10, 24, 10, 30), 30),
      (DateTime.utc(2026, 11, 23, 10, 30), 60),
      (DateTime.utc(2027, 1, 22, 10, 30), 120),
      (DateTime.utc(2027, 5, 22, 10, 30), 120),
    ]) {
      item = LocalReviewRepository.projectNext(
        current: item,
        rating: ReviewRating.good,
        occurredAt: date,
      );
      expect(item.intervalDays, gap);
      expect(item.dueAt, date.add(Duration(days: gap)));
    }
  });

  test('v2 invalid gap is rejected before storing', () async {
    final repository = LocalReviewRepository(_database());
    final invalid = ReviewItem.fromJson({
      ...itemJson(intervalDays: 3),
      'schedulerVersion': 'fixed-offset-v2',
    });
    await expectLater(repository.putReviewItem(invalid), throwsFormatException);
    expect(await repository.readReviewItem(invalid.id), isNull);
  });

  test('good rating advances fixed ladder 1 to 3 days', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    final event = ReviewEvent.fromJson(eventJson());
    await repository.appendEvent(event);
    final projected = await repository.readReviewItem('review-1');
    expect(projected?.intervalDays, 3);
    expect(projected?.rawDueAt, '2026-09-27T10:35:00Z');
    await repository.appendEvent(event);
    expect((await repository.readReviewItem('review-1'))?.intervalDays, 3);
  });

  test('review event on suspended item is rejected atomically', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(
      ReviewItem.fromJson(itemJson(state: 'suspended')),
    );
    await expectLater(
      repository.appendEvent(ReviewEvent.fromJson(eventJson())),
      throwsStateError,
    );
    expect(await repository.readEvent('event-1'), isNull);
    expect(
      (await repository.readReviewItem('review-1'))?.rawDueAt,
      '2026-09-24T10:30:00Z',
    );
  });

  test('forged next due is rejected with no partial write', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson(eventJson(nextDueAt: '2026-09-28T10:35:00Z')),
      ),
      throwsStateError,
    );
    expect(await repository.readEvent('event-1'), isNull);
    expect(
      (await repository.readReviewItem('review-1'))?.rawDueAt,
      '2026-09-24T10:30:00Z',
    );
  });

  test('stale chained event and absent item are rejected', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    await repository.appendEvent(ReviewEvent.fromJson(eventJson()));
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson(
          eventJson(
            id: 'event-2',
            occurredAt: '2026-09-28T10:35:00Z',
            previousDueAt: '2026-09-24T10:30:00Z',
            nextDueAt: '2026-10-05T10:35:00Z',
          ),
        ),
      ),
      throwsStateError,
    );
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson(eventJson(id: 'event-x', reviewItemId: 'absent')),
      ),
      throwsStateError,
    );
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson(eventJson(id: 'event-y', rating: 'future_rating')),
      ),
      throwsFormatException,
    );
  });

  test('again rating resets to one day and counts a lapse', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(
      ReviewItem.fromJson(
        itemJson(intervalDays: 3, dueAt: '2026-09-27T10:35:00Z'),
      ),
    );
    await repository.appendEvent(
      ReviewEvent.fromJson(
        eventJson(
          occurredAt: '2026-09-27T11:00:00Z',
          previousDueAt: '2026-09-27T10:35:00Z',
          nextDueAt: '2026-09-28T11:00:00Z',
          rating: 'again',
        ),
      ),
    );
    final projected = await repository.readReviewItem('review-1');
    expect(projected?.intervalDays, 1);
    expect(projected?.lapses, 1);
    expect(projected?.rawDueAt, '2026-09-28T11:00:00Z');
  });

  test('projection rebuilds deterministically from stored events', () async {
    final repository = LocalReviewRepository(_database());
    final initial = ReviewItem.fromJson(itemJson());
    await repository.putReviewItem(initial);
    await repository.appendEvent(ReviewEvent.fromJson(eventJson()));
    await repository.appendEvent(
      ReviewEvent.fromJson(
        eventJson(
          id: 'event-2',
          occurredAt: '2026-09-27T11:00:00Z',
          previousDueAt: '2026-09-27T10:35:00Z',
          nextDueAt: '2026-10-04T11:00:00Z',
        ),
      ),
    );
    final events = await repository.listEvents('review-1');
    var folded = initial;
    for (final event in events) {
      folded = LocalReviewRepository.projectNext(
        current: folded,
        rating: event.rating,
        occurredAt: event.occurredAt,
      );
    }
    final stored = await repository.readReviewItem('review-1');
    expect(stored?.rawDueAt, folded.rawDueAt);
    expect(stored?.intervalDays, 7);
    expect(stored?.intervalDays, folded.intervalDays);
  });

  test(
    'event history sorts UTC instants despite precision differences',
    () async {
      final repository = LocalReviewRepository(_database());
      await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
      await repository.appendEvent(
        ReviewEvent.fromJson(
          eventJson(
            id: 'first',
            occurredAt: '2026-09-24T10:35:00Z',
            nextDueAt: '2026-09-27T10:35:00Z',
          ),
        ),
      );
      await repository.appendEvent(
        ReviewEvent.fromJson(
          eventJson(
            id: 'second',
            occurredAt: '2026-09-27T10:35:00.250Z',
            previousDueAt: '2026-09-27T10:35:00Z',
            nextDueAt: '2026-09-30T10:35:00.250Z',
            rating: 'hard',
          ),
        ),
      );
      expect((await repository.listEvents('review-1')).map((e) => e.id), [
        'first',
        'second',
      ]);
    },
  );

  test('equal-time appends require a strictly later instant', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    await repository.appendEvent(
      ReviewEvent.fromJson(
        eventJson(
          id: 'z',
          occurredAt: '2026-09-24T10:35:00Z',
          nextDueAt: '2026-09-27T10:35:00Z',
          rating: 'good',
        ),
      ),
    );
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson(
          eventJson(
            id: 'a',
            occurredAt: '2026-09-24T10:35:00Z',
            previousDueAt: '2026-09-27T10:35:00Z',
            nextDueAt: '2026-09-25T10:35:00Z',
            rating: 'again',
          ),
        ),
      ),
      throwsStateError,
    );
    expect(await repository.readEvent('a'), isNull);
    final stored = await repository.readReviewItem('review-1');
    expect(stored?.rawDueAt, '2026-09-27T10:35:00Z');
    expect(stored?.intervalDays, 3);
    expect(stored?.lapses, 0);
  });

  test('future event cannot be appended before its due instant', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    await expectLater(
      repository.appendEvent(
        ReviewEvent.fromJson(
          eventJson(
            occurredAt: '2026-09-24T10:29:59Z',
            nextDueAt: '2026-09-27T10:29:59Z',
          ),
        ),
      ),
      throwsStateError,
    );
    expect(await repository.readEvent('event-1'), isNull);
  });

  test(
    'earlier timestamp cannot append after later event even with matching due',
    () async {
      final repository = LocalReviewRepository(_database());
      await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
      await repository.appendEvent(ReviewEvent.fromJson(eventJson()));
      await expectLater(
        repository.appendEvent(
          ReviewEvent.fromJson(
            eventJson(
              id: 'backdated',
              rating: 'hard',
              occurredAt: '2026-09-24T10:34:00Z',
              previousDueAt: '2026-09-27T10:35:00Z',
              nextDueAt: '2026-09-27T10:34:00Z',
            ),
          ),
        ),
        throwsStateError,
      );
      expect(await repository.readEvent('backdated'), isNull);
    },
  );

  test('corrupted due timestamp surfaces instead of silent default', () async {
    final repository = LocalReviewRepository(_database());
    await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
    await repository.database.customStatement(
      "UPDATE review_items SET due_at = 'not-a-timestamp' WHERE id = 'review-1'",
    );
    await expectLater(
      repository.readReviewItem('review-1'),
      throwsFormatException,
    );
  });

  test('corrupted immutable receipt surfaces instead of being ignored', () async {
    final repository = LocalReviewRepository(_database());
    final item = ReviewItem.fromJson(itemJson());
    await repository.putReviewItem(item);
    await repository.database.customStatement(
      "UPDATE review_items SET initial_payload_json = 'not-json' WHERE id = 'review-1'",
    );
    await expectLater(repository.putReviewItem(item), throwsFormatException);
  });

  test(
    'corrupted event row cannot silently become an idempotent replay',
    () async {
      final repository = LocalReviewRepository(_database());
      await repository.putReviewItem(ReviewItem.fromJson(itemJson()));
      final event = ReviewEvent.fromJson(eventJson());
      await repository.appendEvent(event);
      await repository.database.customStatement(
        "UPDATE review_events SET rating = 'unknown' WHERE id = 'event-1'",
      );
      await expectLater(repository.appendEvent(event), throwsStateError);
    },
  );
}
