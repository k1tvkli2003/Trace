import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'v5-equivalent DB retains original and gains lesson/state tables',
    () async {
      final directory = await Directory.systemTemp.createTemp('trace-v5-');
      final file = File('${directory.path}/library.sqlite');
      final original = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
      try {
        final created = TraceDatabase(NativeDatabase.createInBackground(file));
        await LocalLibraryRepository(created).putEntry(
          const LibraryEntrySummary(id: 'library-1', title: 'Preserved'),
        );
        final source = await LocalPdfSourceRepository(
          created,
        ).importPdf(libraryId: 'library-1', name: 'book.pdf', bytes: original);
        await created.close();

        // Reconstruct exact v5 schema delta: v6 added only these two tables.
        final old = sqlite3.open(file.path);
        old.execute('DROP TABLE learner_states');
        old.execute('DROP TABLE lesson_artifacts');
        old.execute('PRAGMA user_version = 5');
        old.close();

        final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
        expect(
          await LocalPdfSourceRepository(upgraded).readOriginal(source.id),
          original,
        );
        expect(
          (await LocalLibraryRepository(upgraded).listEntries()).single.title,
          'Preserved',
        );
        expect(
          await LocalLessonRepository(upgraded).readArtifact('absent'),
          isNull,
        );
        expect(
          await LocalLessonRepository(upgraded).readState('absent'),
          isNull,
        );
        await upgraded.close();

        final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
        try {
          expect(
            await LocalPdfSourceRepository(reopened).readOriginal(source.id),
            original,
          );
          expect(
            await LocalLessonRepository(reopened).readState('absent'),
            isNull,
          );
        } finally {
          await reopened.close();
        }
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );
}
