import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('TXT original bytes and manifest survive a repository reload', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final library = LocalLibraryRepository(db);
    await library.putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
    final bytes = Uint8List.fromList(utf8.encode('سلام Trace ۱۲۳'));
    final importer = LocalTextSourceRepository(db);
    final saved = await importer.importText(
      libraryId: 'lib',
      name: 'notes.txt',
      bytes: bytes,
    );
    bytes[0] = 0;
    expect(saved.format, SourceDocumentFormat.text);
    expect(
      saved.sourceHash,
      sha256.convert(utf8.encode('سلام Trace ۱۲۳')).toString(),
    );
    expect(saved.relativePath, 'notes.txt');
    expect(
      (await LocalTextSourceRepository(db).readOriginal(saved.id)),
      utf8.encode('سلام Trace ۱۲۳'),
    );
    expect(
      (await LocalTextSourceRepository(db).listForLibrary('lib')).single.id,
      saved.id,
    );
    final duplicate = await importer.importText(
      libraryId: 'lib',
      name: 'notes.txt',
      bytes: Uint8List.fromList(utf8.encode('سلام Trace ۱۲۳')),
    );
    expect(duplicate.id, saved.id);
    expect((await importer.listForLibrary('lib')).length, 1);
  });

  test('concurrent duplicate imports return one immutable manifest', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
    final importer = LocalTextSourceRepository(db);
    final results = await Future.wait([
      importer.importText(
        libraryId: 'lib',
        name: 'note.md',
        bytes: Uint8List.fromList([65]),
      ),
      importer.importText(
        libraryId: 'lib',
        name: 'note.md',
        bytes: Uint8List.fromList([65]),
      ),
    ]);
    expect(results[0].id, results[1].id);
    expect(await importer.listForLibrary('lib'), hasLength(1));
  });

  test(
    'changed bytes under same filename retain both immutable versions',
    () async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
      final importer = LocalTextSourceRepository(db);
      final first = await importer.importText(
        libraryId: 'lib',
        name: 'note.md',
        bytes: Uint8List.fromList([65]),
      );
      final second = await importer.importText(
        libraryId: 'lib',
        name: 'note.md',
        bytes: Uint8List.fromList([66]),
      );
      expect(first.version, 1);
      expect(second.version, 2);
      expect(first.id, isNot(second.id));
      expect(await importer.readOriginal(first.id), [65]);
      expect(await importer.readOriginal(second.id), [66]);
      expect(await importer.listForLibrary('lib'), hasLength(2));
    },
  );

  test('corrupted original is never returned as verified text', () async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
    final importer = LocalTextSourceRepository(db);
    final saved = await importer.importText(
      libraryId: 'lib',
      name: 'chapter.txt',
      bytes: Uint8List.fromList(utf8.encode('Verified')),
    );
    await db.customUpdate(
      'UPDATE source_entries SET original_bytes = ? WHERE id = ?',
      variables: [
        Variable.withBlob(Uint8List.fromList([0x58])),
        Variable.withString(saved.id),
      ],
      updates: {db.sourceEntries},
    );
    await expectLater(importer.readOriginal(saved.id), throwsStateError);
    await expectLater(
      importer.importText(
        libraryId: 'lib',
        name: 'chapter.txt',
        bytes: Uint8List.fromList(utf8.encode('Verified')),
      ),
      throwsStateError,
    );
  });

  test(
    'invalid path, binary bytes, and unknown library never create a manifest',
    () async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final importer = LocalTextSourceRepository(db);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
      for (final name in ['../escape.txt', 'bad.pdf', 'C:\\secret.md']) {
        await expectLater(
          importer.importText(
            libraryId: 'lib',
            name: name,
            bytes: Uint8List.fromList([65]),
          ),
          throwsFormatException,
        );
      }
      await expectLater(
        importer.importText(
          libraryId: 'lib',
          name: 'binary.txt',
          bytes: Uint8List.fromList([0xff]),
        ),
        throwsFormatException,
      );
      await expectLater(
        importer.importText(
          libraryId: 'missing',
          name: 'valid.md',
          bytes: Uint8List.fromList([65]),
        ),
        throwsStateError,
      );
      expect(await importer.listForLibrary('lib'), isEmpty);
    },
  );
}
