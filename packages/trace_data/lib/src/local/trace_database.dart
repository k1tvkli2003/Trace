import 'package:drift/drift.dart';

part 'trace_database.g.dart';

/// First local table: only the library summary, not imported source bytes.
class LibraryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(
  name: 'source_version_unique',
  columns: {#libraryId, #name, #version},
  unique: true,
)
class SourceEntries extends Table {
  TextColumn get id => text()();
  TextColumn get libraryId => text().references(LibraryEntries, #id)();
  TextColumn get name => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get sourceHash => text()();
  TextColumn get mimeType => text()();
  TextColumn get format => text()();
  BlobColumn get originalBytes => blob()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LibraryEntries, SourceEntries])
class TraceDatabase extends _$TraceDatabase {
  TraceDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(sourceEntries);
      if (from < 3) {
        if (from >= 2) {
          await m.addColumn(sourceEntries, sourceEntries.version);
          // v2 allowed repeated filenames. Preserve all rows and assign each
          // immutable original a stable revision before enforcing uniqueness.
          await customStatement('''
            UPDATE source_entries SET version = (
              SELECT COUNT(*) FROM source_entries AS older
              WHERE older.library_id = source_entries.library_id
                AND older.name = source_entries.name
                AND older.rowid <= source_entries.rowid
            )
          ''');
        }
        await m.createIndex(sourceVersionUnique);
      }
    },
    beforeOpen: (_) async => customStatement('PRAGMA foreign_keys = ON'),
  );
}
