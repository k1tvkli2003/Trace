import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final pdfBytes = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
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
  final hash = sha256.convert(utf8.encode(jsonEncode(lesson))).toString();
  final artifact = <String, Object?>{
    'id': 'artifact-1',
    'version': 1,
    'contentHash': hash,
    'sliceId': 'slice-1',
    'lessonAstJson': lesson,
    'citationIds': ['cite-1'],
    'figureIds': <String>[],
    'modelProfile': 'personal-route',
    'promptVersion': 'teacher-fa-v1',
    'createdAt': '2026-09-24T10:00:00Z',
  };
  final state = <String, Object?>{
    'id': 'state-1',
    'version': 1,
    'contentHash': 'a' * 64,
    'sliceId': 'slice-1',
    'lessonArtifactId': 'artifact-1',
    'status': 'in_progress',
    'confidence': 0.25,
    'lastReadAt': null,
    'lastActionAt': '2026-09-24T10:00:00Z',
  };

  Future<TraceDatabase> seededDb() async {
    final db = TraceDatabase(NativeDatabase.memory());
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'library-1', title: 'Test'));
    final source = await LocalPdfSourceRepository(
      db,
    ).importPdf(libraryId: 'library-1', name: 'book.pdf', bytes: pdfBytes);
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
    return db;
  }

  test(
    'rejects a citation whose stored quote no longer appears in source',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      await db.customStatement(
        'UPDATE source_citations SET quote = ? WHERE id = ?',
        ['invented quote', 'cite-1'],
      );
      final repository = LocalLessonRepository(db);
      await expectLater(
        repository.putLessonWithState(artifact, state),
        throwsA(anyOf(isA<StateError>(), isA<FormatException>())),
      );
      expect(await repository.readArtifact('artifact-1'), isNull);
      expect(await repository.readState('state-1'), isNull);
    },
  );

  test(
    'missing citation or changed AST hash leaves no lesson or state',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      final repository = LocalLessonRepository(db);
      for (final invalid in [
        {
          ...artifact,
          'citationIds': ['missing-citation'],
        },
        {...artifact, 'contentHash': 'f' * 64},
      ]) {
        await expectLater(
          repository.putLessonWithState(invalid, state),
          throwsA(anyOf(isA<StateError>(), isA<FormatException>())),
        );
      }
      expect(await repository.readArtifact('artifact-1'), isNull);
      expect(await repository.readState('state-1'), isNull);
    },
  );

  test('state ID conflict rolls back newly inserted artifact', () async {
    final db = await seededDb();
    addTearDown(db.close);
    final repository = LocalLessonRepository(db);
    await repository.putLessonWithState(artifact, state);
    final newArtifact = {...artifact, 'id': 'artifact-2', 'version': 2};
    final conflictingState = {
      ...state,
      'version': 2,
      'lessonArtifactId': 'artifact-2',
    };
    await expectLater(
      repository.putLessonWithState(newArtifact, conflictingState),
      throwsStateError,
    );
    expect(await repository.readArtifact('artifact-2'), isNull);
    expect((await repository.readArtifact('artifact-1'))?.id, 'artifact-1');
    expect(
      (await repository.readState('state-1'))?.lessonArtifactId,
      'artifact-1',
    );
  });

  test(
    'persists source-verified lesson and state atomically, replay-safe',
    () async {
      final db = await seededDb();
      addTearDown(db.close);
      final repository = LocalLessonRepository(db);
      await repository.putLessonWithState(artifact, state);
      await repository.putLessonWithState(artifact, state);
      expect((await repository.readArtifact('artifact-1'))?.toJson(), artifact);
      expect((await repository.readState('state-1'))?.toJson(), state);
    },
  );
}
