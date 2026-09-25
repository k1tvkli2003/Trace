import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';

import 'local_lesson_state_action_test.dart' as fixture;

void main() {
  test(
    'due lesson replays its verified cached artifact and source evidence',
    () async {
      final db = await fixture.seededDb();
      addTearDown(db.close);
      await LocalLessonRepository(db).applyStateAction(fixture.request());
      final inbox = LocalReviewInboxRepository(db);

      expect(await inbox.listDue('2026-09-26T09:59:59Z'), isEmpty);
      final items = await inbox.listDue('2026-09-26T10:00:00Z');
      expect(items.map((item) => item.id), ['review:state-1']);

      final replay = await inbox.openDue(
        'review:state-1',
        '2026-09-26T10:00:00Z',
      );
      expect(replay.artifact.id, 'artifact-1');
      expect(replay.artifact.lesson.blocks.single.text, 'متن منبع.');
      expect(replay.citations.keys, ['cite-1']);
      expect(replay.citations['cite-1']!.locator, 'p.1');
      expect(replay.citations['cite-1']!.quote, 'متن منبع.');
      expect(replay.citations['cite-1']!.sourceName, 'book.pdf');
    },
  );

  test('tampered source original blocks cached replay', () async {
    final db = await fixture.seededDb();
    addTearDown(db.close);
    await LocalLessonRepository(db).applyStateAction(fixture.request());
    final source = (await LocalPdfSourceRepository(
      db,
    ).listForLibrary('library-1')).single;
    await db.customStatement(
      'UPDATE source_entries SET original_bytes = ? WHERE id = ?',
      [
        <int>[1, 2, 3],
        source.id,
      ],
    );

    await expectLater(
      LocalReviewInboxRepository(
        db,
      ).openDue('review:state-1', '2026-09-26T10:00:00Z'),
      throwsStateError,
    );
  });
}
