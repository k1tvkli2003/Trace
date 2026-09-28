import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

import 'local_annotation_repository_test.dart'
    show anchorJson, noteJson, seededAnnotationDb;

void main() {
  test(
    'explicit repair creates a new verified anchor and leaves history intact',
    () async {
      final (db, block) = await seededAnnotationDb();
      addTearDown(db.close);
      final repository = LocalAnnotationRepository(db);
      final old = HighlightAnchor.fromJson({
        ...anchorJson(id: 'old', status: 'detached'),
        'contentHashAtCreation': 'b' * 64,
      });
      await repository.putAnchor(old);
      await repository.putNote(StudyNote.fromJson(noteJson(anchorId: 'old')));
      final replacement = HighlightAnchor.fromJson({
        ...anchorJson(id: 'new'),
        'contentHashAtCreation': block.sourceHash,
      });

      await repository.repairAnchor('old', replacement);
      await repository.repairAnchor('old', replacement); // safe replay
      expect(
        (await repository.readAnchor('old'))?.status,
        HighlightAnchorStatus.detached,
      );
      expect(
        (await repository.readAnchor('new'))?.status,
        HighlightAnchorStatus.attached,
      );
      expect((await repository.readNote('note-1'))?.anchorId, 'old');
      expect((await repository.rehydrateAnchor('new')).attached, isTrue);
    },
  );

  test(
    'repair rejects changed quote, wrong position, reused ID, or attached old',
    () async {
      final (db, block) = await seededAnnotationDb();
      addTearDown(db.close);
      final repository = LocalAnnotationRepository(db);
      await repository.putAnchor(
        HighlightAnchor.fromJson({
          ...anchorJson(id: 'old', status: 'detached'),
          'contentHashAtCreation': 'b' * 64,
        }),
      );
      await repository.putAnchor(
        HighlightAnchor.fromJson({
          ...anchorJson(id: 'attached'),
          'contentHashAtCreation': block.sourceHash,
        }),
      );
      final replacement = HighlightAnchor.fromJson({
        ...anchorJson(id: 'new'),
        'contentHashAtCreation': block.sourceHash,
      });
      Future<void> rejects(HighlightAnchor candidate, {String oldId = 'old'}) =>
          expectLater(
            repository.repairAnchor(oldId, candidate),
            throwsStateError,
          );
      await rejects(
        HighlightAnchor.fromJson({...replacement.toJson(), 'quote': 'source'}),
      );
      await rejects(
        HighlightAnchor.fromJson({
          ...replacement.toJson(),
          'startOffset': 0,
          'endOffset': 9,
        }),
      );
      await rejects(
        HighlightAnchor.fromJson({...replacement.toJson(), 'id': 'old'}),
      );
      await rejects(replacement, oldId: 'attached');
      expect(await repository.readAnchor('new'), isNull);
      expect(
        (await repository.readAnchor('old'))?.status,
        HighlightAnchorStatus.detached,
      );
    },
  );

  test(
    'repair fails closed on stale hash and tombstone without partial insert',
    () async {
      final (db, block) = await seededAnnotationDb();
      addTearDown(db.close);
      final repository = LocalAnnotationRepository(db);
      await repository.putAnchor(
        HighlightAnchor.fromJson({
          ...anchorJson(id: 'old', status: 'detached'),
          'contentHashAtCreation': 'b' * 64,
        }),
      );
      final stale = HighlightAnchor.fromJson({
        ...anchorJson(id: 'fresh'),
        'contentHashAtCreation': 'c' * 64,
      });
      await expectLater(
        repository.repairAnchor('old', stale),
        throwsStateError,
      );
      expect(await repository.readAnchor('fresh'), isNull);
      await repository.deleteAnchor('old', '2026-09-28T12:00:00Z');
      final valid = HighlightAnchor.fromJson({
        ...stale.toJson(),
        'contentHashAtCreation': block.sourceHash,
      });
      await expectLater(
        repository.repairAnchor('old', valid),
        throwsStateError,
      );
      expect(await repository.readAnchor('fresh'), isNull);
    },
  );
}
