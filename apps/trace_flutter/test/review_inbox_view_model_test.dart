import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/app/review_inbox_view_model.dart';
import 'package:trace_flutter/review_inbox_page.dart';

Future<TraceDatabase> seededReviewDb() async {
  final db = TraceDatabase(NativeDatabase.memory());
  await LocalLibraryRepository(
    db,
  ).putEntry(const LibraryEntrySummary(id: 'library-1', title: 'Evidence'));
  final source = await LocalPdfSourceRepository(db).importPdf(
    libraryId: 'library-1',
    name: 'chapter.pdf',
    bytes: Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF')),
  );
  await LocalSourcePageRepository(db).putPage(
    SourcePage.fromJson({
      'id': 'page-1',
      'documentId': source.id,
      'version': 1,
      'pageNumber': 1,
      'pixelHash': 'b' * 64,
      'renderProfile': 'page-v1',
      'thumbnailPath': 'pages/1.webp',
      'visionStatus': 'verified',
    }),
  );
  await LocalSourceBlockRepository(db).putBlock(
    SourceBlock.fromJson({
      'id': 'block-1',
      'documentId': source.id,
      'pageId': 'page-1',
      'version': 1,
      'sourceHash': source.sourceHash,
      'order': 0,
      'kind': 'paragraph',
      'rawText': 'متن منبع.',
      'normalizedText': 'متن منبع.',
      'bbox': null,
    }),
  );
  await LocalSourceCitationRepository(db).putCitation(
    SourceCitation.fromJson({
      'id': 'cite-1',
      'version': 1,
      'contentHash': 'c' * 64,
      'sourceBlockId': 'block-1',
      'pageId': 'page-1',
      'figureId': null,
      'quote': 'متن منبع.',
      'locator': 'p.1',
      'confidence': 1.0,
      'extractionVersion': 'vision-v1',
    }),
  );
  final lesson = <String, Object?>{
    'schemaVersion': 'lesson-ast-v1',
    'sliceId': 'slice-1',
    'language': 'fa',
    'blocks': [
      {
        'id': 'intro',
        'type': 'paragraph',
        'text': 'متن منبع.',
        'sourceCitationIds': ['cite-1'],
      },
    ],
  };
  await LocalLessonRepository(db).putLessonWithState(
    {
      'id': 'artifact-1',
      'version': 1,
      'contentHash': sha256.convert(utf8.encode(jsonEncode(lesson))).toString(),
      'sliceId': 'slice-1',
      'lessonAstJson': lesson,
      'citationIds': ['cite-1'],
      'figureIds': <String>[],
      'modelProfile': 'personal-route',
      'promptVersion': 'teacher-fa-v1',
      'createdAt': '2026-09-24T10:00:00Z',
    },
    {
      'id': 'state-1',
      'version': 1,
      'contentHash': 'a' * 64,
      'sliceId': 'slice-1',
      'lessonArtifactId': 'artifact-1',
      'status': 'in_progress',
      'confidence': 0.25,
      'lastReadAt': null,
      'lastActionAt': '2026-09-24T10:00:00Z',
    },
  );
  await LocalLessonRepository(db).applyStateAction(
    const LearnerStateActionRequest(
      actionId: 'action-1',
      stateId: 'state-1',
      sliceId: 'slice-1',
      lessonArtifactId: 'artifact-1',
      action: LearnerStateAction.studied,
      occurredAt: '2026-09-25T10:00:00Z',
      deviceId: 'device-1',
    ),
  );
  return db;
}

void main() {
  test(
    'fractional UTC clock includes a review due within the same second',
    () async {
      final db = await seededReviewDb();
      addTearDown(db.close);
      final review = (await LocalReviewRepository(
        db,
      ).readReviewItem('review:state-1'))!;
      // Due changes only for this clock precision fixture; no AI or event mutation.
      await db.customStatement(
        'UPDATE review_items SET due_at = ? WHERE id = ?',
        ['2026-09-26T10:00:00.250Z', review.id],
      );
      final model = ReviewInboxViewModel(
        LocalReviewInboxRepository(db),
        nowUtc: () => DateTime.utc(2026, 9, 26, 10, 0, 0, 500),
      );
      addTearDown(model.dispose);
      await model.load();
      expect(model.items.map((item) => item.id), ['review:state-1']);
    },
  );

  testWidgets('due item renders cached lesson and citation locator', (
    tester,
  ) async {
    final db = await seededReviewDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      MaterialApp(
        home: ReviewInboxPage(
          database: db,
          nowUtc: () => DateTime.utc(2026, 9, 26, 10),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lesson due · review:state-1'), findsOneWidget);
    await tester.tap(find.text('Open cached lesson'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('review-cached-lesson')), findsOneWidget);
    expect(find.text('متن منبع.'), findsOneWidget);
    expect(find.text('p.1 · chapter.pdf'), findsOneWidget);
    await tester.tap(find.text('p.1 · chapter.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('Source evidence'), findsOneWidget);
    expect(find.text('chapter.pdf · p.1'), findsOneWidget);
    expect(find.text('متن منبع.', skipOffstage: false), findsWidgets);
    expect(find.textContaining('Page ID: page-1'), findsOneWidget);
  });

  test(
    'view model loads due review and opens cached lesson without network',
    () async {
      final db = await seededReviewDb();
      addTearDown(db.close);
      final model = ReviewInboxViewModel(
        LocalReviewInboxRepository(db),
        nowUtc: () => DateTime.utc(2026, 9, 26, 10),
      );
      addTearDown(model.dispose);

      await model.load();
      expect(model.status, ReviewInboxStatus.ready);
      expect(model.items.map((item) => item.id), ['review:state-1']);
      await model.open('review:state-1');
      expect(model.opened?.artifact.id, 'artifact-1');
      expect(model.opened?.citations['cite-1']?.locator, 'p.1');
      expect(model.errorMessage, isNull);
    },
  );
}
