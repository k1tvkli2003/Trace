import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  Future<(TraceDatabase, String)> setup() async {
    final db = TraceDatabase(NativeDatabase.memory());
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
    final source = await LocalPdfSourceRepository(db).importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF')),
    );
    await LocalSourcePageRepository(db).putPage(
      SourcePage.fromJson({
        'id': 'page-1',
        'documentId': source.id,
        'version': 1,
        'pageNumber': 1,
        'pixelHash': 'a' * 64,
        'renderProfile': 'preview-v1',
        'thumbnailPath': 'thumbs/page-1.webp',
        'visionStatus': 'complete',
      }),
    );
    return (db, source.id);
  }

  Map<String, Object?> block({
    required String id,
    required int order,
    String text = 'خام',
  }) => {
    'id': id,
    'documentId': 'source-placeholder',
    'pageId': 'page-1',
    'version': 1,
    'sourceHash': sha256.convert(utf8.encode('%PDF-1.4\n%%EOF')).toString(),
    'order': order,
    'kind': 'paragraph',
    'rawText': text,
    'normalizedText': text,
    'bbox': {'x': 0.1, 'y': 0.1, 'w': 0.8, 'h': 0.1},
  };

  test(
    'batch persists blocks in reading order and identical replay is safe',
    () async {
      final (db, sourceId) = await setup();
      addTearDown(db.close);
      final repository = LocalSourceBlockRepository(db);
      final first = SourceBlock.fromJson({
        ...block(id: 'block-1', order: 0),
        'documentId': sourceId,
      });
      final second = SourceBlock.fromJson({
        ...block(id: 'block-2', order: 1),
        'documentId': sourceId,
      });
      await repository.putBlocks([second, first]);
      await repository.putBlocks([first, second]);
      final rows = await repository.listForPage('page-1');
      expect(rows.map((row) => row.id), ['block-1', 'block-2']);
      expect(rows.first.bbox!.width, closeTo(0.8, 0.0001));
    },
  );

  test('failed block batch rolls back earlier inserts', () async {
    final (db, sourceId) = await setup();
    addTearDown(db.close);
    final repository = LocalSourceBlockRepository(db);
    final first = SourceBlock.fromJson({
      ...block(id: 'block-1', order: 0),
      'documentId': sourceId,
    });
    final invalid = SourceBlock.fromJson({
      ...block(id: 'block-2', order: 1),
      'documentId': sourceId,
      'sourceHash': 'c' * 64,
    });
    await expectLater(repository.putBlocks([first, invalid]), throwsStateError);
    expect(await repository.listForPage('page-1'), isEmpty);
  });

  test(
    'same page/version/order or block ID cannot be silently replaced',
    () async {
      final (db, sourceId) = await setup();
      addTearDown(db.close);
      final repository = LocalSourceBlockRepository(db);
      final first = SourceBlock.fromJson({
        ...block(id: 'block-1', order: 0),
        'documentId': sourceId,
      });
      await repository.putBlock(first);
      await expectLater(
        repository.putBlock(
          SourceBlock.fromJson({
            ...block(id: 'block-2', order: 0, text: 'تغییر'),
            'documentId': sourceId,
          }),
        ),
        throwsStateError,
      );
      await expectLater(
        repository.putBlock(
          SourceBlock.fromJson({
            ...block(id: 'block-1', order: 0, text: 'تغییر'),
            'documentId': sourceId,
          }),
        ),
        throwsStateError,
      );
      expect((await repository.listForPage('page-1')).single.rawText, 'خام');
    },
  );
}
