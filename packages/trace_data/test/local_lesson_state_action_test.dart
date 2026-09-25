import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> lessonJson() => {
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

Future<TraceDatabase> seededDb() async {
  final db = TraceDatabase(NativeDatabase.memory());
  await LocalLibraryRepository(
    db,
  ).putEntry(const LibraryEntrySummary(id: 'library-1', title: 'Test'));
  final source = await LocalPdfSourceRepository(db).importPdf(
    libraryId: 'library-1',
    name: 'book.pdf',
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
  final lesson = lessonJson();
  final artifact = <String, Object?>{
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
  };
  await LocalLessonRepository(db).putLessonWithState(artifact, {
    'id': 'state-1',
    'version': 1,
    'contentHash': 'a' * 64,
    'sliceId': 'slice-1',
    'lessonArtifactId': 'artifact-1',
    'status': 'in_progress',
    'confidence': 0.25,
    'lastReadAt': null,
    'lastActionAt': '2026-09-24T10:00:00Z',
  });
  return db;
}

LearnerStateActionRequest request({
  String actionId = 'action-1',
  LearnerStateAction action = LearnerStateAction.studied,
  String occurredAt = '2026-09-25T10:00:00Z',
  String sliceId = 'slice-1',
  String lessonArtifactId = 'artifact-1',
}) => LearnerStateActionRequest(
  actionId: actionId,
  stateId: 'state-1',
  sliceId: sliceId,
  lessonArtifactId: lessonArtifactId,
  action: action,
  occurredAt: occurredAt,
  deviceId: 'device-1',
);

void main() {
  test(
    'studied action updates projection and queues one sync operation',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      final repository = LocalLessonRepository(db);

      final receipt = await repository.applyStateAction(request());

      expect(receipt.replayed, isFalse);
      expect(receipt.state.status, LearnerStateStatus.studied);
      expect(receipt.state.version, 2);
      expect(receipt.state.lastActionAt, DateTime.utc(2026, 9, 25, 10));
      final stored = await repository.readState('state-1');
      expect(stored?.status, LearnerStateStatus.studied);
      final operations = await LocalOplogRepository(db).listOperations();
      expect(operations, hasLength(1));
      expect(operations.single.operationId, 'action-1');
      expect(operations.single.entityType, 'learner_state');
      expect(operations.single.entityId, 'state-1');
      expect(operations.single.mutationType, SyncMutationType.update);
      final nextState = Map<String, Object?>.from(
        operations.single.payload['nextState']! as Map,
      );
      expect(operations.single.payload['action'], 'studied');
      expect(nextState['status'], 'studied');
      expect(operations.single.createdAt, '2026-09-25T10:00:00Z');
    },
  );

  test('first studied action creates one v2 review due the next day', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final lessons = LocalLessonRepository(db);
    final reviews = LocalReviewRepository(db);

    final receipt = await lessons.applyStateAction(request());

    expect(receipt.replayed, isFalse);
    final item = await reviews.readReviewItem('review:state-1');
    expect(item, isNotNull);
    expect(
      item!.schedulerVersion,
      LocalReviewRepository.offsetSchedulerVersion,
    );
    expect(item.targetType, ReviewTargetType.lessonBox);
    expect(item.targetId, 'artifact-1');
    expect(item.rawDueAt, '2026-09-26T10:00:00Z');
    expect(item.intervalDays, 1);
    expect(item.lapses, 0);
    final artifact = await lessons.readArtifact('artifact-1');
    expect(item.contentHash, artifact!.contentHash);
    expect(
      (await reviews.listDueItems('2026-09-26T10:00:00Z')).map((e) => e.id),
      ['review:state-1'],
    );
  });

  test('non-studied action does not create a review', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final lessons = LocalLessonRepository(db);
    final reviews = LocalReviewRepository(db);

    final receipt = await lessons.applyStateAction(
      request(actionId: 'action-skip', action: LearnerStateAction.skipped),
    );

    expect(receipt.replayed, isFalse);
    expect(await reviews.readReviewItem('review:state-1'), isNull);
    expect(await reviews.listDueItems('2026-09-26T10:00:00Z'), isEmpty);
  });

  test('replay keeps exactly one review and one outbox row', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final lessons = LocalLessonRepository(db);
    final reviews = LocalReviewRepository(db);

    final applied = await lessons.applyStateAction(request());
    final replay = await lessons.applyStateAction(request());

    expect(replay.replayed, isTrue);
    expect(replay.state.toJson(), applied.state.toJson());
    expect(
      (await reviews.readReviewItem('review:state-1'))?.rawDueAt,
      '2026-09-26T10:00:00Z',
    );
    expect(await LocalOplogRepository(db).listOperations(), hasLength(1));
  });

  test('later studied action does not reset first review', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final lessons = LocalLessonRepository(db);
    final reviews = LocalReviewRepository(db);

    await lessons.applyStateAction(request());
    await lessons.applyStateAction(
      request(
        actionId: 'action-2',
        action: LearnerStateAction.notLearned,
        occurredAt: '2026-09-26T10:00:00Z',
      ),
    );
    await lessons.applyStateAction(
      request(
        actionId: 'action-3',
        action: LearnerStateAction.studied,
        occurredAt: '2026-09-27T10:00:00Z',
      ),
    );

    final item = await reviews.readReviewItem('review:state-1');
    expect(item?.rawDueAt, '2026-09-26T10:00:00Z');
    expect(item?.intervalDays, 1);
    expect(await LocalOplogRepository(db).listOperations(), hasLength(3));
  });

  test('review insert failure rolls back state and outbox write', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final lessons = LocalLessonRepository(db);
    await db.customStatement('''
      CREATE TRIGGER reject_review_insert BEFORE INSERT ON review_items
      BEGIN SELECT RAISE(ABORT, 'injected review failure'); END;
    ''');

    await expectLater(
      lessons.applyStateAction(request()),
      throwsA(isA<Exception>()),
    );

    expect(
      (await lessons.readState('state-1'))?.status,
      LearnerStateStatus.inProgress,
    );
    expect(await LocalOplogRepository(db).listOperations(), isEmpty);
    expect(
      await LocalReviewRepository(db).readReviewItem('review:state-1'),
      isNull,
    );
  });

  test('conflicting review receipt rolls back state and outbox row', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final lessons = LocalLessonRepository(db);
    final reviews = LocalReviewRepository(db);
    final artifact = await lessons.readArtifact('artifact-1');

    await reviews.putReviewItem(
      LocalReviewRepository.firstStudyItem(
        id: 'review:state-1',
        targetId: 'artifact-1',
        targetType: ReviewTargetType.lessonBox,
        contentHash: artifact!.contentHash,
        firstStudiedAt: DateTime.utc(2026, 9, 20, 10),
      ),
    );

    await expectLater(lessons.applyStateAction(request()), throwsStateError);
    expect(
      (await lessons.readState('state-1'))?.status,
      LearnerStateStatus.inProgress,
    );
    expect(await LocalOplogRepository(db).listOperations(), isEmpty);
    expect(
      (await reviews.readReviewItem('review:state-1'))?.rawDueAt,
      '2026-09-21T10:00:00Z',
    );
  });

  test(
    'same action replays without duplicating mutation or outbox row',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      final repository = LocalLessonRepository(db);
      final first = request();

      final applied = await repository.applyStateAction(first);
      final replay = await repository.applyStateAction(first);

      expect(applied.replayed, isFalse);
      expect(replay.replayed, isTrue);
      expect(replay.state.toJson(), applied.state.toJson());
      expect(await LocalOplogRepository(db).listOperations(), hasLength(1));
    },
  );

  test('replay returns original receipt after a later action', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final repository = LocalLessonRepository(db);
    final first = request();
    final applied = await repository.applyStateAction(first);
    await repository.applyStateAction(
      request(
        actionId: 'action-2',
        action: LearnerStateAction.notLearned,
        occurredAt: '2026-09-26T10:00:00Z',
      ),
    );

    final replay = await repository.applyStateAction(first);
    expect(replay.replayed, isTrue);
    expect(replay.state.toJson(), applied.state.toJson());
    expect(
      (await repository.readState('state-1'))?.status,
      LearnerStateStatus.notLearned,
    );
    expect(await LocalOplogRepository(db).listOperations(), hasLength(2));
  });

  test('two states in one slice remain separate projections', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final repository = LocalLessonRepository(db);
    final original = (await repository.readState('state-1'))!;
    await db
        .into(db.learnerStates)
        .insert(
          LearnerStatesCompanion.insert(
            id: 'state-2',
            sliceId: original.sliceId,
            lessonArtifactId: original.lessonArtifactId!,
            version: 1,
            contentHash: original.contentHash,
            payloadJson: jsonEncode({...original.toJson(), 'id': 'state-2'}),
          ),
        );
    await repository.applyStateAction(request());
    expect(
      (await repository.readState('state-1'))?.status,
      LearnerStateStatus.studied,
    );
    expect(
      (await repository.readState('state-2'))?.status,
      LearnerStateStatus.inProgress,
    );
  });

  test('unknown state ID cannot alias a slice ID', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final repository = LocalLessonRepository(db);
    expect(await repository.readState('slice-1'), isNull);
  });

  test(
    'conflicting action reuse fails closed and preserves projection',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      final repository = LocalLessonRepository(db);
      await repository.applyStateAction(request());

      await expectLater(
        repository.applyStateAction(
          request(action: LearnerStateAction.notLearned),
        ),
        throwsStateError,
      );
      expect(
        (await repository.readState('state-1'))?.status,
        LearnerStateStatus.studied,
      );
      expect(await LocalOplogRepository(db).listOperations(), hasLength(1));
    },
  );

  test(
    'identity mismatch and stale time do not create an outbox row',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      final repository = LocalLessonRepository(db);

      await expectLater(
        repository.applyStateAction(request(sliceId: 'other-slice')),
        throwsFormatException,
      );
      await expectLater(
        repository.applyStateAction(
          request(occurredAt: '2026-09-24T09:00:00Z'),
        ),
        throwsStateError,
      );
      expect(await LocalOplogRepository(db).listOperations(), isEmpty);
      expect(
        (await repository.readState('state-1'))?.status,
        LearnerStateStatus.inProgress,
      );
    },
  );
}
