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
  test('v9 source upgrades to v10 provenance without replacing original', () async {
    final directory = await Directory.systemTemp.createTemp('trace-manifest-v9-');
    final file = File('${directory.path}/library.sqlite');
    final original = utf8.encode('Original source');
    try {
      final old = sqlite3.open(file.path);
      try {
        old.execute(
          'CREATE TABLE library_entries (id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL)',
        );
        old.execute("INSERT INTO library_entries VALUES ('lib', 'Book')");
        old.execute('''CREATE TABLE source_entries (
          id TEXT NOT NULL PRIMARY KEY, library_id TEXT NOT NULL,
          name TEXT NOT NULL, version INTEGER NOT NULL DEFAULT 1,
          source_hash TEXT NOT NULL, mime_type TEXT NOT NULL,
          format TEXT NOT NULL, original_bytes BLOB NOT NULL
        )''');
        old.execute(
          'CREATE UNIQUE INDEX source_version_unique ON source_entries (library_id, name, version)',
        );
        old.execute(
          'INSERT INTO source_entries VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            'old-source', 'lib', 'chapter.txt', 1,
            sha256.convert(original).toString(), 'text/plain', 'text', original,
          ],
        );
        old.execute('PRAGMA user_version = 9');
      } finally {
        old.close();
      }

      final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        final importer = LocalSourceImportRepository(upgraded);
        final prior = (await importer.listForLibrary('lib')).single;
        expect(prior.id, 'old-source');
        expect(prior.modifiedAt, isNull);
        expect(prior.logicalRole, 'primary');
        expect(prior.exclusionReason, isNull);
        expect(await importer.readOriginal(prior.id), original);
        final next = await importer.importOne(
          libraryId: 'lib',
          item: SourceImportItem(
            relativePath: 'chapter.txt',
            bytes: Uint8List.fromList(utf8.encode('Changed source')),
            modifiedAt: DateTime.utc(2026, 9, 24),
            logicalRole: 'reference',
            exclusionReason: 'not_lesson_source',
          ),
        );
        expect(next.version, 2);
        expect(next.logicalRole, 'reference');
        expect((await importer.listForLibrary('lib')).map((e) => e.version), [1, 2]);
        expect(await importer.readOriginal(prior.id), original);
      } finally {
        await upgraded.close();
      }

      final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        final entries = await LocalSourceImportRepository(reopened).listForLibrary('lib');
        expect(entries.map((e) => e.version), [1, 2]);
        expect(entries.last.exclusionReason, 'not_lesson_source');
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
