import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('v7-equivalent DB retains original and gains review tables', () async {
    final directory = await Directory.systemTemp.createTemp('trace-v7-');
    final file = File('${directory.path}/library.sqlite');
    final original = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
    try {
      final created = TraceDatabase(NativeDatabase(file));
      await LocalLibraryRepository(created).putEntry(
        const LibraryEntrySummary(id: 'library-1', title: 'Preserved'),
      );
      final source = await LocalPdfSourceRepository(
        created,
      ).importPdf(libraryId: 'library-1', name: 'book.pdf', bytes: original);
      await created.close();

      // Reconstruct exact v7 schema delta: v8 added only these two tables.
      final old = sqlite3.open(file.path);
      old.execute('DROP TABLE review_events');
      old.execute('DROP TABLE review_items');
      old.execute('PRAGMA user_version = 7');
      old.close();

      final upgraded = TraceDatabase(NativeDatabase(file));
      expect(
        await LocalPdfSourceRepository(upgraded).readOriginal(source.id),
        original,
      );
      expect(
        (await LocalLibraryRepository(upgraded).listEntries()).single.title,
        'Preserved',
      );
      final reviewIndex = await upgraded
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'index' AND name = 'review_item_state_due'",
          )
          .get();
      expect(reviewIndex, hasLength(1));

      final reviews = LocalReviewRepository(upgraded);
      expect(await reviews.readReviewItem('absent'), isNull);
      expect(await reviews.readEvent('absent'), isNull);

      final item = ReviewItem.fromJson({
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
      });
      await reviews.putReviewItem(item);
      await reviews.appendEvent(
        ReviewEvent.fromJson({
          'id': 'event-1',
          'version': 1,
          'contentHash': 'f' * 64,
          'reviewItemId': 'review-1',
          'rating': 'good',
          'occurredAt': '2026-09-24T10:35:00Z',
          'previousDueAt': '2026-09-24T10:30:00Z',
          'nextDueAt': '2026-09-27T10:35:00Z',
          'deviceId': 'device-1',
          'schedulerVersion': 'fixed-ladder-v1',
        }),
      );
      expect((await reviews.readReviewItem('review-1'))?.intervalDays, 3);
      await upgraded.close();

      final reopened = TraceDatabase(NativeDatabase(file));
      try {
        expect(
          await LocalPdfSourceRepository(reopened).readOriginal(source.id),
          original,
        );
        final reopenedReviews = LocalReviewRepository(reopened);
        expect(
          (await reopenedReviews.readReviewItem('review-1'))?.rawDueAt,
          '2026-09-27T10:35:00Z',
        );
        expect(
          (await reopenedReviews.readEvent('event-1'))?.rawNextDueAt,
          '2026-09-27T10:35:00Z',
        );
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
