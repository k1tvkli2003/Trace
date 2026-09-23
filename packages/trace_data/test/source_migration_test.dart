import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';

void main() {
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
