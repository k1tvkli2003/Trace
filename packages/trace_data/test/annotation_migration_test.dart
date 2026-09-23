import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'v6-equivalent DB retains original and gains annotation tables',
    () async {
      final directory = await Directory.systemTemp.createTemp('trace-v6-');
      final file = File('${directory.path}/library.sqlite');
      final original = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
      final sourceHash = sha256.convert(original).toString();
      try {
        final created = TraceDatabase(NativeDatabase.createInBackground(file));
        await LocalLibraryRepository(created).putEntry(
          const LibraryEntrySummary(id: 'library-1', title: 'Preserved'),
        );
        final source = await LocalPdfSourceRepository(
          created,
        ).importPdf(libraryId: 'library-1', name: 'book.pdf', bytes: original);
        await created.close();

        // Reconstruct exact v6 schema delta: v7 added only these two tables.
        final old = sqlite3.open(file.path);
        old.execute('DROP TABLE study_notes');
        old.execute('DROP TABLE highlight_anchors');
        old.execute('PRAGMA user_version = 6');
        old.close();

        final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
        expect(
          await LocalPdfSourceRepository(upgraded).readOriginal(source.id),
          original,
        );
        expect(
          (await LocalLibraryRepository(upgraded).listEntries()).single.title,
          'Preserved',
        );
        final annotations = LocalAnnotationRepository(upgraded);
        expect(await annotations.readAnchor('absent'), isNull);
        expect(await annotations.readNote('absent'), isNull);

        final page = SourcePage.fromJson({
          'id': 'page-1',
          'version': 1,
          'documentId': source.id,
          'pageNumber': 1,
          'pixelHash': 'a' * 64,
          'renderProfile': 'thumb-v1',
          'thumbnailPath': 'thumb/page-1.webp',
          'visionStatus': 'complete',
        });
        await LocalSourcePageRepository(upgraded).putPage(page);
        final block = SourceBlock.fromJson({
          'id': 'block-1',
          'version': 1,
          'documentId': source.id,
          'pageId': page.id,
          'order': 0,
          'kind': 'paragraph',
          'rawText': 'The source mechanism is stable.',
          'normalizedText': 'The source mechanism is stable.',
          'sourceHash': sourceHash,
          'bbox': {'x': 0.1, 'y': 0.1, 'w': 0.8, 'h': 0.1},
        });
        await LocalSourceBlockRepository(upgraded).putBlock(block);
        final anchor = HighlightAnchor.fromJson({
          'id': 'anchor-1',
          'version': 1,
          'contentHashAtCreation': sourceHash,
          'sourceBlockId': 'block-1',
          'pageId': 'page-1',
          'lessonBlockId': null,
          'quote': 'mechanism',
          'prefix': 'source ',
          'suffix': ' is',
          'startOffset': 11,
          'endOffset': 20,
          'bbox': {'x': 0.2, 'y': 0.1, 'w': 0.3, 'h': 0.05},
          'color': 'yellow',
          'status': 'attached',
        });
        await annotations.putAnchor(anchor);
        await annotations.putNote(
          StudyNote.fromJson({
            'id': 'note-1',
            'version': 1,
            'contentHash': 'c' * 64,
            'anchorId': 'anchor-1',
            'sourceBlockId': null,
            'figureId': null,
            'lessonBlockId': null,
            'body': 'Remember this.',
            'pinned': false,
            'createdAt': '2026-09-23T12:00:00Z',
            'updatedAt': '2026-09-23T12:00:00Z',
          }),
        );
        expect((await annotations.readAnchor('anchor-1'))?.quote, 'mechanism');
        expect((await annotations.readNote('note-1'))?.anchorId, 'anchor-1');
        await upgraded.close();

        final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
        try {
          expect(
            await LocalPdfSourceRepository(reopened).readOriginal(source.id),
            original,
          );
          final reopenedAnnotations = LocalAnnotationRepository(reopened);
          expect(
            (await reopenedAnnotations.readAnchor('anchor-1'))?.quote,
            'mechanism',
          );
          expect(
            (await reopenedAnnotations.readNote('note-1'))?.anchorId,
            'anchor-1',
          );
        } finally {
          await reopened.close();
        }
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );
}
