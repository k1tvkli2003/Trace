import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

Future<(TraceDatabase, SourceBlock)> seededAnnotationDb() async {
  final db = TraceDatabase(NativeDatabase.memory());
  const bytes = '%PDF-1.4\n%%EOF';
  final sourceHash = sha256.convert(utf8.encode(bytes)).toString();
  await LocalLibraryRepository(
    db,
  ).putEntry(const LibraryEntrySummary(id: 'library-1', title: 'Test'));
  final source = await LocalPdfSourceRepository(db).importPdf(
    libraryId: 'library-1',
    name: 'book.pdf',
    bytes: Uint8List.fromList(utf8.encode(bytes)),
  );
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
  await LocalSourcePageRepository(db).putPage(page);
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
  await LocalSourceBlockRepository(db).putBlock(block);
  return (db, block);
}

Map<String, Object?> anchorJson({
  String id = 'anchor-1',
  String status = 'attached',
  String quote = 'mechanism',
}) => {
  'id': id,
  'version': 1,
  'contentHashAtCreation': 'b' * 64,
  'sourceBlockId': 'block-1',
  'pageId': 'page-1',
  'lessonBlockId': null,
  'quote': quote,
  'prefix': 'source ',
  'suffix': ' is',
  'startOffset': 11,
  'endOffset': 20,
  'bbox': {'x': 0.2, 'y': 0.1, 'w': 0.3, 'h': 0.05},
  'color': 'yellow',
  'status': status,
};

Map<String, Object?> noteJson({
  String id = 'note-1',
  String? anchorId = 'anchor-1',
}) => {
  'id': id,
  'version': 1,
  'contentHash': 'c' * 64,
  'anchorId': anchorId,
  'sourceBlockId': null,
  'figureId': null,
  'lessonBlockId': null,
  'body': 'Remember this.',
  'pinned': false,
  'createdAt': '2026-09-23T12:00:00Z',
  'updatedAt': '2026-09-23T12:00:00Z',
};

void main() {
  test('anchor and note persist with source validation and replay', () async {
    final (db, block) = await seededAnnotationDb();
    addTearDown(db.close);
    final repository = LocalAnnotationRepository(db);
    final anchor = HighlightAnchor.fromJson({
      ...anchorJson(),
      'contentHashAtCreation': block.sourceHash,
    });
    await repository.putAnchor(anchor);
    await repository.putNote(StudyNote.fromJson(noteJson()));
    expect((await repository.readAnchor(anchor.id))?.quote, 'mechanism');
    expect((await repository.readNote('note-1'))?.anchorId, anchor.id);
    await repository.putAnchor(anchor);
    await repository.putNote(StudyNote.fromJson(noteJson()));
  });

  test('attached anchor with wrong quote is rejected', () async {
    final (db, block) = await seededAnnotationDb();
    addTearDown(db.close);
    final repository = LocalAnnotationRepository(db);
    final anchor = HighlightAnchor.fromJson({
      ...anchorJson(quote: 'not in source'),
      'contentHashAtCreation': block.sourceHash,
    });
    await expectLater(repository.putAnchor(anchor), throwsStateError);
  });

  test('delete creates tombstone and blocks new notes', () async {
    final (db, block) = await seededAnnotationDb();
    addTearDown(db.close);
    final repository = LocalAnnotationRepository(db);
    final anchor = HighlightAnchor.fromJson({
      ...anchorJson(),
      'contentHashAtCreation': block.sourceHash,
    });
    await repository.putAnchor(anchor);
    await repository.deleteAnchor(anchor.id, '2026-09-23T13:00:00Z');
    expect(await repository.readAnchor(anchor.id), isNull);
    expect(await repository.isAnchorTombstoned(anchor.id), isTrue);
    await expectLater(
      repository.putNote(StudyNote.fromJson(noteJson(id: 'note-2'))),
      throwsStateError,
    );
  });
}
