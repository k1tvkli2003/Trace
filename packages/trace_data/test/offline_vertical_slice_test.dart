import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'offline source-to-learning loop imports, teaches, reviews, and backlinks',
    () async {
      final database = TraceDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      const sourceText = 'سلول واحد بنیادی حیات است.';
      final sourceBytes = Uint8List.fromList(utf8.encode(sourceText));
      await LocalLibraryRepository(database).putEntry(
        const LibraryEntrySummary(id: 'library-1', title: 'زیست شناسی'),
      );

      final source = await LocalTextSourceRepository(database).importText(
        libraryId: 'library-1',
        name: 'chapter.md',
        bytes: sourceBytes,
      );
      final sourceHash = source.sourceHash;
      final page = SourcePage.fromJson({
        'id': 'page-1',
        'documentId': source.id,
        'version': 1,
        'pageNumber': 1,
        'pixelHash': 'a' * 64,
        'renderProfile': 'markdown-v1',
        'thumbnailPath': 'pages/page-1.webp',
        'visionStatus': 'complete',
      });
      await LocalSourcePageRepository(database).putPage(page);
      final block = SourceBlock.fromJson({
        'id': 'block-1',
        'documentId': source.id,
        'pageId': page.id,
        'version': 1,
        'sourceHash': sourceHash,
        'order': 0,
        'kind': 'paragraph',
        'rawText': sourceText,
        'normalizedText': sourceText,
        'bbox': {'x': 0.1, 'y': 0.1, 'w': 0.8, 'h': 0.1},
      });
      await LocalSourceBlockRepository(database).putBlock(block);
      final citation = SourceCitation.fromJson({
        'id': 'citation-1',
        'version': 1,
        'contentHash': 'b' * 64,
        'sourceBlockId': block.id,
        'pageId': page.id,
        'figureId': null,
        'quote': sourceText,
        'locator': 'chapter.md:p1:block0',
        'confidence': 1.0,
        'extractionVersion': 'markdown-v1',
      });
      await LocalSourceCitationRepository(database).putCitation(citation);

      final lessonAst = <String, Object?>{
        'schemaVersion': 'lesson-ast-v1',
        'sliceId': 'slice-1',
        'language': 'fa',
        'blocks': [
          {
            'id': 'lesson-block-1',
            'type': 'definition_box',
            'text': 'سلول، واحد بنیادی حیات است.',
            'sourceCitationIds': [citation.id],
          },
        ],
      };
      final artifact = <String, Object?>{
        'id': 'artifact-1',
        'version': 1,
        'contentHash': sha256
            .convert(utf8.encode(jsonEncode(lessonAst)))
            .toString(),
        'sliceId': 'slice-1',
        'lessonAstJson': lessonAst,
        'citationIds': [citation.id],
        'figureIds': <String>[],
        'modelProfile': 'offline-fixture',
        'promptVersion': 'teacher-fa-v1',
        'createdAt': '2026-09-25T10:00:00Z',
      };
      await LocalLessonRepository(database).putLessonWithState(artifact, {
        'id': 'state-1',
        'version': 1,
        'contentHash': 'c' * 64,
        'sliceId': 'slice-1',
        'lessonArtifactId': artifact['id'],
        'status': 'in_progress',
        'confidence': 1.0,
        'lastReadAt': null,
        'lastActionAt': '2026-09-25T10:00:00Z',
      });

      final lessons = LocalLessonRepository(database);
      final receipt = await lessons.applyStateAction(
        const LearnerStateActionRequest(
          actionId: 'action-1',
          stateId: 'state-1',
          sliceId: 'slice-1',
          lessonArtifactId: 'artifact-1',
          action: LearnerStateAction.studied,
          occurredAt: '2026-09-25T10:01:00Z',
          deviceId: 'device-1',
        ),
      );
      expect(receipt.state.status, LearnerStateStatus.studied);

      final reviews = LocalReviewRepository(database);
      final due = await reviews.listDueItems('2026-09-26T10:01:00Z');
      expect(due.map((item) => item.id), ['review:state-1']);
      final replay = await LocalReviewInboxRepository(
        database,
      ).openDue('review:state-1', '2026-09-26T10:01:00Z');
      expect(replay.artifact.id, 'artifact-1');
      expect(replay.citations[citation.id]!.citation.quote, sourceText);

      final annotations = LocalAnnotationRepository(database);
      final anchor = HighlightAnchor.fromJson({
        'id': 'anchor-1',
        'version': 1,
        'contentHashAtCreation': sourceHash,
        'sourceBlockId': block.id,
        'pageId': page.id,
        'lessonBlockId': 'lesson-block-1',
        'quote': 'واحد بنیادی',
        'prefix': 'سلول ',
        'suffix': ' حیات',
        'startOffset': sourceText.indexOf('واحد بنیادی'),
        'endOffset': sourceText.indexOf('واحد بنیادی') + 'واحد بنیادی'.length,
        'bbox': {'x': 0.2, 'y': 0.1, 'w': 0.3, 'h': 0.05},
        'color': 'yellow',
        'status': 'attached',
      });
      await annotations.putAnchor(anchor);
      final note = StudyNote.fromJson({
        'id': 'note-1',
        'version': 1,
        'contentHash': 'd' * 64,
        'anchorId': anchor.id,
        'sourceBlockId': null,
        'figureId': null,
        'lessonBlockId': 'lesson-block-1',
        'body': 'تعریف پایه را مرور کن.',
        'pinned': true,
        'createdAt': '2026-09-25T10:02:00Z',
        'updatedAt': '2026-09-25T10:02:00Z',
      });
      await annotations.putNote(note);
      expect((await annotations.rehydrateAnchor(anchor.id)).attached, isTrue);
      expect(
        (await annotations.listNotesForAnchor(anchor.id)).single.id,
        note.id,
      );
    },
  );
}
