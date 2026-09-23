import 'dart:io';

import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('library survives close and reopen on disk', () async {
    final directory = await Directory.systemTemp.createTemp('trace-db-');
    final file = File('${directory.path}/library.sqlite');
    try {
      final first = TraceDatabase(NativeDatabase.createInBackground(file));
      await LocalLibraryRepository(first).putEntry(
        const LibraryEntrySummary(id: 'persisted', title: 'Offline book'),
      );
      await first.close();
      final second = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        final rows = await LocalLibraryRepository(second).listEntries();
        expect(rows, hasLength(1));
        expect(rows.single.title, 'Offline book');
      } finally {
        await second.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
