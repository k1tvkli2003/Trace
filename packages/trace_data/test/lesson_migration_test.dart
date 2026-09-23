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

        // Reconstruct exact v5 schema delta by dropping every later table.
        // Dropping tables also drops their indexes, which matters because
        // dropping only lesson tables would leave review/oplog indexes
        // behind and mislabel the migration (it would fail with
        // "review_item_state_due already exists" when upgrading to v9).
        final old = sqlite3.open(file.path);
        old.execute('DROP TABLE learner_states');
        old.execute('DROP TABLE lesson_artifacts');
        old.execute('DROP TABLE study_notes');
        old.execute('DROP TABLE highlight_anchors');
        old.execute('DROP TABLE review_events');
        old.execute('DROP TABLE review_items');
        old.execute('DROP TABLE sync_operations');
        old.execute('DROP TABLE ai_run_ledgers');
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
        await _deleteTemp(directory);
      }
    },
  );
}

Future<void> _deleteTemp(Directory directory) async {
  // Windows releases the SQLite file lock slightly after close() returns;
  // retry briefly, then leave cleanup best-effort so a green migration
  // proof never fails on temp-folder lock timing.
  for (var attempt = 0; attempt < 100; attempt++) {
    try {
      await directory.delete(recursive: true);
      return;
    } on PathAccessException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  try {
    await directory.delete(recursive: true);
  } on PathAccessException {
    // Best-effort only: assertions already passed above.
    print('WARNING: temp cleanup skipped, still locked: ${directory.path}');
  }
}
