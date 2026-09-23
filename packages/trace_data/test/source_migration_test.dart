import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

// Migration fixture uses only synthetic bytes; no source content leaves this test.

void main() {
  test('v3 database preserves source and gains source-pages table', () async {
    final directory = await Directory.systemTemp.createTemp('trace-v3-');
    final file = File('${directory.path}/library.sqlite');
    try {
      final old = sqlite3.open(file.path);
      old.execute(
        'CREATE TABLE library_entries (id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL)',
      );
      old.execute("INSERT INTO library_entries VALUES ('lib','Prior book')");
      old.execute('''CREATE TABLE source_entries (
        id TEXT NOT NULL PRIMARY KEY, library_id TEXT NOT NULL,
        name TEXT NOT NULL, version INTEGER NOT NULL DEFAULT 1,
        source_hash TEXT NOT NULL, mime_type TEXT NOT NULL,
        format TEXT NOT NULL, original_bytes BLOB NOT NULL
      )''');
      old.execute(
        'CREATE UNIQUE INDEX source_version_unique ON source_entries (library_id, name, version)',
      );
      final bytes = utf8.encode('%PDF-1.4\n%%EOF');
      old.execute('INSERT INTO source_entries VALUES (?,?,?,?,?,?,?,?)', [
        'source-1',
        'lib',
        'book.pdf',
        1,
        sha256.convert(bytes).toString(),
        'application/pdf',
        'pdf',
        bytes,
      ]);
      old.execute('PRAGMA user_version = 3');
      old.close();
      final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
      final pages = LocalSourcePageRepository(upgraded);
      await pages.putPage(
        SourcePage.fromJson({
          'id': 'page-1',
          'documentId': 'source-1',
          'version': 1,
          'pageNumber': 1,
          'pixelHash': 'a' * 64,
          'renderProfile': 'preview-v1',
          'thumbnailPath': 'thumbs/page-1.webp',
          'visionStatus': 'not_started',
        }),
      );
      expect((await pages.listForDocument('source-1')).single.id, 'page-1');
      final blocks = LocalSourceBlockRepository(upgraded);
      await blocks.putBlock(
        SourceBlock.fromJson({
          'id': 'block-1',
          'documentId': 'source-1',
          'pageId': 'page-1',
          'version': 1,
          'sourceHash': sha256.convert(bytes).toString(),
          'order': 0,
          'kind': 'paragraph',
          'rawText': 'evidence',
          'normalizedText': 'evidence',
        }),
      );
      final citations = LocalSourceCitationRepository(upgraded);
      await citations.putCitation(
        SourceCitation.fromJson({
          'id': 'citation-1',
          'version': 1,
          'contentHash': 'b' * 64,
          'sourceBlockId': 'block-1',
          'pageId': 'page-1',
          'figureId': null,
          'quote': 'evidence',
          'locator': 'page:1/block:0',
          'confidence': 1.0,
          'extractionVersion': 'vision-v1',
        }),
      );
      expect(
        await LocalPdfSourceRepository(upgraded).readOriginal('source-1'),
        bytes,
      );
      await upgraded.close();
      final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        expect(
          (await LocalSourcePageRepository(
            reopened,
          ).listForDocument('source-1')).single.id,
          'page-1',
        );
        expect(
          (await LocalSourceBlockRepository(
            reopened,
          ).listForPage('page-1')).single.rawText,
          'evidence',
        );
        expect(
          (await LocalSourceCitationRepository(
            reopened,
          ).listForBlock('block-1')).single.quote,
          'evidence',
        );
        expect(
          (await LocalLibraryRepository(reopened).listEntries()).single.title,
          'Prior book',
        );
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });

  test(
    'v2 duplicate filenames migrate to distinct v3 revisions without loss',
    () async {
      final directory = await Directory.systemTemp.createTemp('trace-v2-');
      final file = File('${directory.path}/library.sqlite');
      try {
        final old = sqlite3.open(file.path);
        old.execute(
          'CREATE TABLE library_entries (id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL)',
        );
        old.execute(
          "INSERT INTO library_entries VALUES ('lib','Prior collection')",
        );
        old.execute('''CREATE TABLE source_entries (
        id TEXT NOT NULL PRIMARY KEY, library_id TEXT NOT NULL,
        name TEXT NOT NULL, source_hash TEXT NOT NULL,
        mime_type TEXT NOT NULL, format TEXT NOT NULL,
        original_bytes BLOB NOT NULL
      )''');
        for (final value in [65, 66]) {
          final bytes = [value];
          old.execute('INSERT INTO source_entries VALUES (?,?,?,?,?,?,?)', [
            'id-$value',
            'lib',
            'note.md',
            sha256.convert(bytes).toString(),
            'text/markdown',
            'markdown',
            bytes,
          ]);
        }
        old.execute('PRAGMA user_version = 2');
        old.close();
        final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
        final importer = LocalTextSourceRepository(upgraded);
        final rows = await importer.listForLibrary('lib');
        expect(rows.map((row) => row.version).toSet(), {1, 2});
        expect(await importer.readOriginal('id-65'), [65]);
        expect(await importer.readOriginal('id-66'), [66]);
        final added = await importer.importText(
          libraryId: 'lib',
          name: 'note.md',
          bytes: Uint8List.fromList([67]),
        );
        expect(added.version, 3);
        await upgraded.close();
        final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
        try {
          expect(
            (await LocalTextSourceRepository(
              reopened,
            ).listForLibrary('lib')).length,
            3,
          );
        } finally {
          await reopened.close();
        }
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );

  test('upgrades existing v1 library without deleting collection', () async {
    final directory = await Directory.systemTemp.createTemp('trace-v1-');
    final file = File('${directory.path}/library.sqlite');
    try {
      final old = sqlite3.open(file.path);
      old.execute(
        'CREATE TABLE library_entries (id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL)',
      );
      old.execute(
        "INSERT INTO library_entries VALUES ('saved','Prior collection')",
      );
      old.execute('PRAGMA user_version = 1');
      old.close();
      final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
      final importer = LocalTextSourceRepository(upgraded);
      expect(
        (await LocalLibraryRepository(upgraded).listEntries()).single.title,
        'Prior collection',
      );
      final source = await importer.importText(
        libraryId: 'saved',
        name: 'old.md',
        bytes: Uint8List.fromList(utf8.encode('# Kept')),
      );
      await upgraded.close();
      final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        expect(
          (await LocalLibraryRepository(reopened).listEntries()).single.id,
          'saved',
        );
        expect(
          await LocalTextSourceRepository(reopened).readOriginal(source.id),
          utf8.encode('# Kept'),
        );
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
