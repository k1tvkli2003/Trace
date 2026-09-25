import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

import 'local_annotation_repository_test.dart'
    show anchorJson, noteJson, seededAnnotationDb;

void main() {
  test(
    'notes list per target in deterministic order without tombstones',
    () async {
      final (db, block) = await seededAnnotationDb();
      addTearDown(db.close);
      final repository = LocalAnnotationRepository(db);
      final anchor = HighlightAnchor.fromJson({
        ...anchorJson(),
        'contentHashAtCreation': block.sourceHash,
      });
      await repository.putAnchor(anchor);
      await repository.putNote(
        StudyNote.fromJson({
          ...noteJson(id: 'note-new', anchorId: anchor.id),
          'updatedAt': '2026-09-23T13:00:00Z',
        }),
      );
      await repository.putNote(
        StudyNote.fromJson({
          ...noteJson(id: 'note-old', anchorId: anchor.id),
          'updatedAt': '2026-09-23T12:00:00Z',
        }),
      );
      await repository.deleteNote('note-old', '2026-09-23T14:00:00Z');

      final notes = await repository.listNotesForAnchor(anchor.id);

      expect(notes.map((note) => note.id), ['note-new']);
    },
  );

  test(
    'note export carries locator and survives idempotent re-import',
    () async {
      final (db, block) = await seededAnnotationDb();
      addTearDown(db.close);
      final repository = LocalAnnotationRepository(db);
      final anchor = HighlightAnchor.fromJson({
        ...anchorJson(),
        'contentHashAtCreation': block.sourceHash,
      });
      await repository.putAnchor(anchor);
      await repository.putNote(StudyNote.fromJson(noteJson()));

      final exported = await repository.exportNote('note-1');

      expect(exported['note'], StudyNote.fromJson(noteJson()).toJson());
      final locator = exported['locator'] as Map<String, Object?>;
      expect(locator['anchorId'], anchor.id);
      expect(locator['quote'], 'mechanism');
      await repository.putNote(
        StudyNote.fromJson(Map<String, Object?>.from(exported['note'] as Map)),
      );
      expect((await repository.listNotesForAnchor(anchor.id)).length, 1);
    },
  );
}
