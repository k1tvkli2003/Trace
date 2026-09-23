import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final pdf = Uint8List.fromList(
    ascii.encode('%PDF-1.4\n1 0 obj\n<<>>\nendobj\n%%EOF\n'),
  );

  Future<(TraceDatabase, LocalPdfSourceRepository)> setup() async {
    final db = TraceDatabase(NativeDatabase.memory());
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
    return (db, LocalPdfSourceRepository(db));
  }

  test('PDF original is hash-bound and replay does not duplicate it', () async {
    final (db, sources) = await setup();
    addTearDown(db.close);
    final saved = await sources.importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: pdf,
    );
    expect(saved.format, SourceDocumentFormat.pdf);
    expect(saved.mimeType, 'application/pdf');
    expect(saved.sourceHash, sha256.convert(pdf).toString());
    pdf[0] = 0;
    expect((await sources.readOriginal(saved.id)).first, 0x25);
    final replay = await sources.importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: Uint8List.fromList(
        ascii.encode('%PDF-1.4\n1 0 obj\n<<>>\nendobj\n%%EOF\n'),
      ),
    );
    expect(replay.id, saved.id);
    expect(await sources.listForLibrary('lib'), hasLength(1));
  });

  test('changed PDF keeps prior original as a separate revision', () async {
    final (db, sources) = await setup();
    addTearDown(db.close);
    final first = await sources.importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: Uint8List.fromList(ascii.encode('%PDF-1.4\nfirst\n%%EOF')),
    );
    final second = await sources.importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: Uint8List.fromList(ascii.encode('%PDF-1.4\nsecond\n%%EOF')),
    );
    expect((first.version, second.version), (1, 2));
    expect(
      utf8.decode(await sources.readOriginal(first.id)),
      contains('first'),
    );
    expect(
      utf8.decode(await sources.readOriginal(second.id)),
      contains('second'),
    );
  });

  test(
    'invalid name, bytes and missing collection cannot create PDF manifest',
    () async {
      final (db, sources) = await setup();
      addTearDown(db.close);
      for (final (name, bytes) in [
        ('../escape.pdf', Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF'))),
        ('book.txt', Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF'))),
        ('bad.pdf', Uint8List.fromList(ascii.encode('not a pdf'))),
        ('empty.pdf', Uint8List(0)),
      ]) {
        await expectLater(
          sources.importPdf(libraryId: 'lib', name: name, bytes: bytes),
          throwsFormatException,
        );
      }
      await expectLater(
        sources.importPdf(
          libraryId: 'missing',
          name: 'book.pdf',
          bytes: Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF')),
        ),
        throwsStateError,
      );
      expect(await sources.listForLibrary('lib'), isEmpty);
    },
  );

  test('corrupted PDF original is rejected on read and replay', () async {
    final (db, sources) = await setup();
    addTearDown(db.close);
    final original = Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF'));
    final saved = await sources.importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: original,
    );
    await db.customUpdate(
      'UPDATE source_entries SET original_bytes = ? WHERE id = ?',
      variables: [
        Variable.withBlob(Uint8List.fromList([65])),
        Variable.withString(saved.id),
      ],
      updates: {db.sourceEntries},
    );
    await expectLater(sources.readOriginal(saved.id), throwsStateError);
    await expectLater(
      sources.importPdf(libraryId: 'lib', name: 'book.pdf', bytes: original),
      throwsStateError,
    );
  });
}
