import 'package:drift/drift.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

import 'local_annotation_repository_test.dart'
    show anchorJson, seededAnnotationDb;

void main() {
  test('rehydrate keeps exact anchor attached without writing', () async {
    final (db, block) = await seededAnnotationDb();
    addTearDown(db.close);
    final repository = LocalAnnotationRepository(db);
    final anchor = HighlightAnchor.fromJson({
      ...anchorJson(),
      'contentHashAtCreation': block.sourceHash,
    });
    await repository.putAnchor(anchor);

    final outcome = await repository.rehydrateAnchor(anchor.id);

    expect(outcome.attached, isTrue);
    expect(outcome.reason, 'exact-block-hash-quote');
  });

  test('rehydrate surfaces quote-moved outcome inside same block', () async {
    final (db, block) = await seededAnnotationDb();
    addTearDown(db.close);
    final repository = LocalAnnotationRepository(db);
    final anchor = HighlightAnchor.fromJson({
      ...anchorJson(),
      'contentHashAtCreation': block.sourceHash,
    });
    await repository.putAnchor(anchor);

    // Rewrites are forbidden, so edit raw/normalized text through a second
    // immutable block version on the same page and point the anchor row at it.
    final moved = SourceBlock.fromJson({
      'id': 'block-2',
      'version': 1,
      'documentId': block.documentId,
      'pageId': block.pageId,
      'order': 1,
      'kind': 'paragraph',
      'rawText': 'Today the source mechanism is here.',
      'normalizedText': 'Today the source mechanism is here.',
      'sourceHash': block.sourceHash,
      'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.8, 'h': 0.1},
    });
    await LocalSourceBlockRepository(db).putBlock(moved);
    await (db.update(
      db.highlightAnchors,
    )..where((entry) => entry.id.equals(anchor.id))).write(
      HighlightAnchorsCompanion(sourceBlockId: const Value('block-2')),
    );

    final outcome = await repository.rehydrateAnchor(anchor.id);

    // Raw and normalized text are concatenated, so the quote occurs twice
    // and the ladder correctly settles on prefix/suffix disambiguation.
    expect(outcome.attached, isTrue);
    expect(outcome.reason, 'prefix-suffix-disambiguation');
    // Anchor storage stays unchanged: only the verdict moves, never silently.
    expect((await repository.readAnchor(anchor.id))?.startOffset, 11);
  });

  test('rehydrate with changed hash detaches explicitly with repair', () async {
    final (db, block) = await seededAnnotationDb();
    addTearDown(db.close);
    final repository = LocalAnnotationRepository(db);
    final anchor = HighlightAnchor.fromJson({
      ...anchorJson(),
      'contentHashAtCreation': 'b' * 64,
      'status': 'detached',
    });
    // Detached rows bypass attached-source validation and stay repairable.
    await repository.putAnchor(anchor);
    expect(block.sourceHash, isNot('b' * 64));

    final verdict = await repository.rehydrateAnchor(anchor.id);
    expect(verdict.attached, isFalse);
    expect(verdict.reason, 'already-detached');

    final attachedAnchor = HighlightAnchor.fromJson({
      ...anchorJson(id: 'anchor-2'),
      'contentHashAtCreation': block.sourceHash,
    });
    await repository.putAnchor(attachedAnchor);
    await repository.markDetached(attachedAnchor.id);
    expect(
      (await repository.readAnchor(attachedAnchor.id))?.status,
      HighlightAnchorStatus.detached,
    );
    await expectLater(
      repository.markDetached(attachedAnchor.id),
      throwsStateError,
    );
  });

  test(
    'rehydrate matches Persian quote after whitespace change only',
    () async {
      final (db, block) = await seededAnnotationDb();
      addTearDown(db.close);
      final repository = LocalAnnotationRepository(db);
      final faBlock = SourceBlock.fromJson({
        'id': 'block-fa',
        'version': 1,
        'documentId': block.documentId,
        'pageId': block.pageId,
        'order': 2,
        'kind': 'paragraph',
        'rawText': 'منبع مکانیسم پایدار است',
        'normalizedText': 'منبع مکانیسم پایدار است',
        'sourceHash': block.sourceHash,
        'bbox': {'x': 0.1, 'y': 0.3, 'w': 0.8, 'h': 0.1},
      });
      await LocalSourceBlockRepository(db).putBlock(faBlock);
      final anchor = HighlightAnchor.fromJson({
        'id': 'anchor-fa',
        'version': 1,
        'contentHashAtCreation': block.sourceHash,
        'sourceBlockId': 'block-fa',
        'pageId': 'page-1',
        'lessonBlockId': null,
        'quote': 'مکانیسم  پایدار',
        'prefix': 'منبع ',
        'suffix': ' است',
        'startOffset': 5,
        'endOffset': 18,
        'bbox': {'x': 0.2, 'y': 0.3, 'w': 0.3, 'h': 0.05},
        'color': 'yellow',
        'status': 'attached',
      });
      // putAnchor requires exact quote containment, so seed the stored row.
      await db
          .into(db.highlightAnchors)
          .insert(
            HighlightAnchorsCompanion.insert(
              id: anchor.id,
              version: anchor.version,
              contentHashAtCreation: anchor.contentHashAtCreation,
              sourceBlockId: anchor.sourceBlockId,
              pageId: anchor.pageId,
              quote: anchor.quote,
              prefix: anchor.prefix,
              suffix: anchor.suffix,
              startOffset: anchor.startOffset,
              endOffset: anchor.endOffset,
              color: anchor.color,
              status: anchor.rawStatus,
            ),
          );

      final outcome = await repository.rehydrateAnchor(anchor.id);
      expect(outcome.attached, isTrue);
      expect(outcome.reason, 'quote-inside-verified-block');
    },
  );
}
