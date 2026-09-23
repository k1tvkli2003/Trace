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
    final bytes = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
    final source = await LocalPdfSourceRepository(
      db,
    ).importPdf(libraryId: 'lib', name: 'book.pdf', bytes: bytes);
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
    final sourceHash = sha256.convert(bytes).toString();
    await LocalSourceBlockRepository(db).putBlock(
      SourceBlock.fromJson({
        'id': 'block-1',
        'documentId': source.id,
        'pageId': 'page-1',
        'version': 1,
        'sourceHash': sourceHash,
        'order': 0,
        'kind': 'paragraph',
        'rawText': 'متن',
        'normalizedText': 'متن',
      }),
    );
    return (db, sourceHash);
  }

  Map<String, Object?> citation({
    String id = 'citation-1',
    String quote = 'متن',
  }) => {
    'id': id,
    'version': 1,
    'contentHash': 'b' * 64,
    'sourceBlockId': 'block-1',
    'pageId': 'page-1',
    'figureId': null,
    'quote': quote,
    'locator': 'page:1/block:0',
    'confidence': 0.98,
    'extractionVersion': 'vision-v1',
  };

  test(
    'citation persists, lists by block, and identical replay is safe',
    () async {
      final (db, _) = await setup();
      addTearDown(db.close);
      final repository = LocalSourceCitationRepository(db);
      final value = SourceCitation.fromJson(citation());
      await repository.putCitation(value);
      await repository.putCitation(value);
      expect(
        (await repository.listForBlock('block-1')).single.toJson(),
        value.toJson(),
      );
    },
  );

  test('citation cannot mutate or reference a missing block', () async {
    final (db, _) = await setup();
    addTearDown(db.close);
    final repository = LocalSourceCitationRepository(db);
    await repository.putCitation(SourceCitation.fromJson(citation()));
    await expectLater(
      repository.putCitation(SourceCitation.fromJson(citation(quote: 'تغییر'))),
      throwsStateError,
    );
    await expectLater(
      repository.putCitation(
        SourceCitation.fromJson({
          ...citation(id: 'missing'),
          'sourceBlockId': 'nope',
        }),
      ),
      throwsStateError,
    );
    await expectLater(
      repository.putCitation(
        SourceCitation.fromJson(citation(id: 'forged', quote: 'بیگانه')),
      ),
      throwsStateError,
    );
    expect((await repository.listForBlock('block-1')).single.quote, 'متن');
  });
}
