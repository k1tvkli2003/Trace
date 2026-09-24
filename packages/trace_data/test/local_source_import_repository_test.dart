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

  test('conflicting provenance for one source identity rejects entire batch', () async {
    final db = createDatabase();
    addTearDown(db.close);
    await addLibrary(db);
    final importer = LocalSourceImportRepository(db);
    final bytes = Uint8List.fromList(utf8.encode('# Same bytes'));
    for (final reversed in [false, true]) {
      final conflicting = [
        SourceImportItem(relativePath: 'same.md', bytes: bytes),
        SourceImportItem(
          relativePath: 'same.md',
          bytes: bytes,
          logicalRole: 'reference',
          exclusionReason: 'not_lesson_source',
        ),
      ];
      await expectLater(
        importer.importBatch(
          libraryId: 'lib',
          items: reversed ? conflicting.reversed : conflicting,
        ),
        throwsFormatException,
      );
    }
    expect(await importer.listForLibrary('lib'), isEmpty);
  });

  test('re-import cannot rewrite provenance of existing hash identity', () async {
    final db = createDatabase();
    addTearDown(db.close);
    await addLibrary(db);
    final importer = LocalSourceImportRepository(db);
    final bytes = Uint8List.fromList(utf8.encode('# Existing'));
    final original = await importer.importOne(
      libraryId: 'lib',
      item: SourceImportItem(relativePath: 'same.md', bytes: bytes),
    );
    await expectLater(
      importer.importOne(
        libraryId: 'lib',
        item: SourceImportItem(
          relativePath: 'same.md',
          bytes: bytes,
          logicalRole: 'reference',
        ),
      ),
      throwsFormatException,
    );
    expect((await importer.listForLibrary('lib')).single.toJson(), original.toJson());
  });

  test('persists immutable source provenance metadata', () async {
    final db = createDatabase();
    addTearDown(db.close);
    await addLibrary(db);
    final modifiedAt = DateTime.utc(2026, 9, 24, 12, 34, 56);
    final saved = await LocalSourceImportRepository(db).importOne(
      libraryId: 'lib',
      item: SourceImportItem(
        relativePath: 'references/guide.md',
        bytes: Uint8List.fromList(utf8.encode('# Guide')),
        modifiedAt: modifiedAt,
        logicalRole: 'reference',
        exclusionReason: 'not_lesson_source',
      ),
    );

    expect(saved.modifiedAt, modifiedAt);
    expect(saved.logicalRole, 'reference');
    expect(saved.exclusionReason, 'not_lesson_source');
    final listed = (await LocalSourceImportRepository(db).listForLibrary('lib'))
        .single;
    expect(listed.toJson(), saved.toJson());
  });

  test(
    'rejects unsupported, empty, oversized, unsafe, and provenance batch before write',
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
        SourceImportItem(
          relativePath: 'blank-role.txt',
          bytes: Uint8List.fromList([65]),
          logicalRole: '   ',
        ),
        SourceImportItem(
          relativePath: 'blank-exclusion.txt',
          bytes: Uint8List.fromList([65]),
          exclusionReason: '',
        ),
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
