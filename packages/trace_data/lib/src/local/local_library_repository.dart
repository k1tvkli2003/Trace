import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart';

import 'trace_database.dart';

/// Local-first repository; one transaction per batch, no network dependency.
final class LocalLibraryRepository implements LibraryRepository {
  LocalLibraryRepository(this.database);

  final TraceDatabase database;

  @override
  Future<List<LibraryEntrySummary>> listEntries() async {
    final rows = await (database.select(
      database.libraryEntries,
    )..orderBy([(table) => OrderingTerm.asc(table.id)])).get();
    return [
      for (final row in rows) LibraryEntrySummary(id: row.id, title: row.title),
    ];
  }

  Future<void> putEntry(LibraryEntrySummary entry) async {
    if (entry.id.trim().isEmpty || entry.title.trim().isEmpty) {
      throw const FormatException('Library entry needs id and title');
    }
    await database
        .into(database.libraryEntries)
        .insertOnConflictUpdate(
          LibraryEntriesCompanion.insert(id: entry.id, title: entry.title),
        );
  }

  Future<void> putEntries(List<LibraryEntrySummary> entries) async {
    await database.transaction(() async {
      for (final entry in entries) {
        if (entry.id.trim().isEmpty || entry.title.trim().isEmpty) {
          throw const FormatException('Library entry needs id and title');
        }
        await database
            .into(database.libraryEntries)
            .insertOnConflictUpdate(
              LibraryEntriesCompanion.insert(id: entry.id, title: entry.title),
            );
      }
    });
  }
}
