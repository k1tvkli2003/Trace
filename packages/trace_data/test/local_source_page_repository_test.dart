import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final page = SourcePage.fromJson({
    'id': 'page-1',
    'documentId': 'source-1',
    'version': 1,
    'pageNumber': 1,
    'pixelHash': 'a' * 64,
    'renderProfile': 'preview-v1',
    'thumbnailPath': 'thumbs/page-1.webp',
    'visionStatus': 'not_started',
  });

  test(
    'same document page with distinct render profiles keeps both rasters',
    () async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
      final source = await LocalPdfSourceRepository(db).importPdf(
        libraryId: 'lib',
        name: 'book.pdf',
        bytes: Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF')),
      );
      final repository = LocalSourcePageRepository(db);
      await repository.putPage(
        SourcePage.fromJson({...page.toJson(), 'documentId': source.id}),
      );
      await repository.putPage(
        SourcePage.fromJson({
          ...page.toJson(),
          'id': 'page-1-hi',
          'documentId': source.id,
          'renderProfile': 'hires-v1',
          'pixelHash': 'c' * 64,
        }),
      );
      expect(await repository.listForDocument(source.id), hasLength(2));
      await expectLater(
        repository.putPage(
          SourcePage.fromJson({
            ...page.toJson(),
            'id': 'page-1-duplicate',
            'documentId': source.id,
            'pixelHash': 'd' * 64,
          }),
        ),
        throwsStateError,
      );
      expect(await repository.listForDocument(source.id), hasLength(2));
    },
  );

  test(
    'persisted page survives DB read and identical replay; conflict fails',
    () async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
      final source = await LocalPdfSourceRepository(db).importPdf(
        libraryId: 'lib',
        name: 'book.pdf',
        bytes: Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF')),
      );
      final saved = SourcePage.fromJson({
        ...page.toJson(),
        'documentId': source.id,
      });
      final repository = LocalSourcePageRepository(db);
      await repository.putPage(saved);
      await repository.putPage(saved);
      expect(
        (await repository.listForDocument(source.id)).single.toJson(),
        saved.toJson(),
      );
      await expectLater(
        repository.putPage(
          SourcePage.fromJson({...saved.toJson(), 'pixelHash': 'b' * 64}),
        ),
        throwsStateError,
      );
      expect(
        (await repository.listForDocument(source.id)).single.pixelHash,
        'a' * 64,
      );
    },
  );
}
