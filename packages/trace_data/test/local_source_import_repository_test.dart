import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  TraceDatabase createDatabase() => TraceDatabase(NativeDatabase.memory());

  Future<void> addLibrary(TraceDatabase db) => LocalLibraryRepository(
    db,
  ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));

  test('imports PNG as immutable image evidence', () async {
    final db = createDatabase();
    addTearDown(db.close);
    await addLibrary(db);
    final bytes = Uint8List.fromList([
      0x89,
      0x50,
      0x4e,
      0x47,
      0x0d,
      0x0a,
      0x1a,
      0x0a,
    ]);

    final saved = await LocalSourceImportRepository(db).importOne(
      libraryId: 'lib',
      item: SourceImportItem(relativePath: 'pages/001.png', bytes: bytes),
    );

    expect(saved.format, SourceDocumentFormat.image);
    expect(saved.mimeType, 'image/png');
    bytes[0] = 0;
    expect(await LocalSourceImportRepository(db).readOriginal(saved.id), [
      0x89,
      0x50,
      0x4e,
      0x47,
      0x0d,
      0x0a,
      0x1a,
      0x0a,
    ]);
  });

  test(
    'batch sorts paths, collapses duplicate identity, and preserves revisions',
    () async {
      final db = createDatabase();
      addTearDown(db.close);
      await addLibrary(db);
      final importer = LocalSourceImportRepository(db);

      final saved = await importer.importBatch(
        libraryId: 'lib',
        items: [
          SourceImportItem(
            relativePath: 'b.md',
            bytes: Uint8List.fromList(utf8.encode('B')),
          ),
          SourceImportItem(
            relativePath: 'a.txt',
            bytes: Uint8List.fromList(utf8.encode('A')),
          ),
          SourceImportItem(
            relativePath: 'b.md',
            bytes: Uint8List.fromList(utf8.encode('B')),
          ),
        ],
      );

      expect(saved.map((item) => item.relativePath).toList(), [
        'a.txt',
        'b.md',
      ]);
      expect(saved.map((item) => item.version).toList(), [1, 1]);

      final revision = await importer.importBatch(
        libraryId: 'lib',
        items: [
          SourceImportItem(
            relativePath: 'b.md',
            bytes: Uint8List.fromList(utf8.encode('B2')),
          ),
        ],
      );
      expect(revision.single.version, 2);
      expect(await importer.listForLibrary('lib'), hasLength(3));
    },
  );

  test(
    'rejects unsupported, empty, oversized, and unsafe batch before write',
    () async {
      final db = createDatabase();
      addTearDown(db.close);
      await addLibrary(db);
      final importer = LocalSourceImportRepository(db);

      for (final item in [
        SourceImportItem(
          relativePath: '../escape.txt',
          bytes: Uint8List.fromList([65]),
        ),
        SourceImportItem(
          relativePath: 'book.zip',
          bytes: Uint8List.fromList([80, 75, 3, 4]),
        ),
        SourceImportItem(relativePath: 'empty.txt', bytes: Uint8List(0)),
      ]) {
        await expectLater(
          importer.importBatch(libraryId: 'lib', items: [item]),
          throwsFormatException,
        );
      }

      await expectLater(
        importer.importBatch(
          libraryId: 'lib',
          items: [
            SourceImportItem(
              relativePath: 'good.txt',
              bytes: Uint8List.fromList([65]),
            ),
            SourceImportItem(
              relativePath: 'bad.bin',
              bytes: Uint8List.fromList([66]),
            ),
          ],
        ),
        throwsFormatException,
      );
      expect(await importer.listForLibrary('lib'), isEmpty);
    },
  );
}
