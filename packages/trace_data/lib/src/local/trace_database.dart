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

@TableIndex(
  name: 'source_page_document_page_version_profile_unique',
  columns: {#documentId, #pageNumber, #version, #renderProfile},
  unique: true,
)
class SourcePages extends Table {
  TextColumn get id => text()();
  TextColumn get documentId => text().references(SourceEntries, #id)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get pageNumber => integer()();
  TextColumn get pixelHash => text()();
  TextColumn get renderProfile => text()();
  TextColumn get thumbnailPath => text()();
  TextColumn get visionStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(
  name: 'source_block_page_version_order_unique',
  columns: {#pageId, #version, #order},
  unique: true,
)
class SourceBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get documentId => text().references(SourceEntries, #id)();
  TextColumn get pageId => text().references(SourcePages, #id)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get sourceHash => text()();
  IntColumn get order => integer()();
  TextColumn get kind => text()();
  TextColumn get rawText => text()();
  TextColumn get normalizedText => text()();
  RealColumn get bboxX => real().nullable()();
  RealColumn get bboxY => real().nullable()();
  RealColumn get bboxWidth => real().nullable()();
  RealColumn get bboxHeight => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SourceCitations extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get contentHash => text()();
  TextColumn get sourceBlockId => text().references(SourceBlocks, #id)();
  TextColumn get pageId => text().references(SourcePages, #id)();
  TextColumn get figureId => text().nullable()();
  TextColumn get quote => text()();
  TextColumn get locator => text()();
  RealColumn get confidence => real()();
  TextColumn get extractionVersion => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LibraryEntries,
    SourceEntries,
    SourcePages,
    SourceBlocks,
    SourceCitations,
  ],
)
class TraceDatabase extends _$TraceDatabase {
  TraceDatabase(super.executor);

  @override
  int get schemaVersion => 4;

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
      if (from < 4) {
        await m.createTable(sourcePages);
        await m.createTable(sourceBlocks);
        await m.createTable(sourceCitations);
      }
    },
    beforeOpen: (_) async => customStatement('PRAGMA foreign_keys = ON'),
  );
}
