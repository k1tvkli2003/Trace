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
  TextColumn get modifiedAt => text().nullable()();
  TextColumn get logicalRole =>
      text().withDefault(const Constant('primary'))();
  TextColumn get exclusionReason => text().nullable()();
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

class FigureAssets extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get assetHash => text()();
  TextColumn get sourceHash => text()();
  TextColumn get pagePixelHash => text()();
  TextColumn get pageId => text().references(SourcePages, #id)();
  RealColumn get bboxX => real()();
  RealColumn get bboxY => real()();
  RealColumn get bboxWidth => real()();
  RealColumn get bboxHeight => real()();
  IntColumn get widthPx => integer()();
  IntColumn get heightPx => integer()();
  TextColumn get caption => text()();
  TextColumn get altText => text()();
  TextColumn get reviewStatus => text()();
  BlobColumn get cropBytes => blob()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(
  name: 'lesson_artifact_slice_version_unique',
  columns: {#sliceId, #version},
  unique: true,
)
class LessonArtifacts extends Table {
  TextColumn get id => text()();
  TextColumn get sliceId => text()();
  IntColumn get version => integer()();
  TextColumn get contentHash => text()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class LearnerStates extends Table {
  TextColumn get id => text()();
  TextColumn get sliceId => text()();
  TextColumn get lessonArtifactId => text().references(LessonArtifacts, #id)();
  IntColumn get version => integer()();
  TextColumn get contentHash => text()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class HighlightAnchors extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get contentHashAtCreation => text()();
  TextColumn get sourceBlockId => text()();
  TextColumn get pageId => text()();
  TextColumn get lessonBlockId => text().nullable()();
  TextColumn get quote => text()();
  TextColumn get prefix => text()();
  TextColumn get suffix => text()();
  IntColumn get startOffset => integer()();
  IntColumn get endOffset => integer()();
  RealColumn get bboxX => real().nullable()();
  RealColumn get bboxY => real().nullable()();
  RealColumn get bboxW => real().nullable()();
  RealColumn get bboxH => real().nullable()();
  TextColumn get color => text()();
  TextColumn get status => text()();
  BoolColumn get tombstone => boolean().withDefault(const Constant(false))();
  TextColumn get tombstonedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StudyNotes extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get contentHash => text()();
  TextColumn get anchorId => text().nullable()();
  TextColumn get sourceBlockId => text().nullable()();
  TextColumn get figureId => text().nullable()();
  TextColumn get lessonBlockId => text().nullable()();
  TextColumn get body => text()();
  BoolColumn get pinned => boolean()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get tombstone => boolean().withDefault(const Constant(false))();
  TextColumn get tombstonedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'review_item_state_due', columns: {#state, #dueAt})
class ReviewItems extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get contentHash => text()();
  TextColumn get targetType => text()();
  TextColumn get targetId => text()();
  TextColumn get dueAt => text()();
  IntColumn get intervalDays => integer()();
  RealColumn get ease => real()();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  TextColumn get state => text()();
  TextColumn get schedulerVersion => text()();
  // Immutable creation receipt; due/interval/lapses are mutable projections.
  TextColumn get initialPayloadJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReviewEvents extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get contentHash => text()();
  TextColumn get reviewItemId => text().references(ReviewItems, #id)();
  TextColumn get rating => text()();
  TextColumn get occurredAt => text()();
  TextColumn get previousDueAt => text().nullable()();
  TextColumn get nextDueAt => text()();
  TextColumn get deviceId => text()();
  TextColumn get schedulerVersion => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(
  name: 'sync_operations_state_created',
  columns: {#syncState, #createdAt},
)
class SyncOperations extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get contentHash => text()();
  TextColumn get syncState => text()();
  TextColumn get createdAt => text()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class AiRunLedgers extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get contentHash => text()();
  TextColumn get createdAt => text()();
  TextColumn get payloadJson => text()();

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
    FigureAssets,
    LessonArtifacts,
    LearnerStates,
    HighlightAnchors,
    StudyNotes,
    ReviewItems,
    ReviewEvents,
    SyncOperations,
    AiRunLedgers,
  ],
)
class TraceDatabase extends _$TraceDatabase {
  TraceDatabase(super.executor);

  @override
  int get schemaVersion => 10;

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
      if (from < 5) await m.createTable(figureAssets);
      if (from < 6) {
        await m.createTable(lessonArtifacts);
        await m.createTable(learnerStates);
      }
      if (from < 7) {
        await m.createTable(highlightAnchors);
        await m.createTable(studyNotes);
      }
      if (from < 8) {
        await m.createTable(reviewItems);
        await m.createTable(reviewEvents);
        await m.createIndex(reviewItemStateDue);
      }
      if (from < 9) {
        await m.createTable(syncOperations);
        await m.createTable(aiRunLedgers);
        await m.createIndex(syncOperationsStateCreated);
      }
      if (from < 10) {
        // Older migration fixtures may already carry Stage 11 columns while
        // still advertising their historical schema version. SQLite has no
        // ADD COLUMN IF NOT EXISTS, so inspect table metadata first.
        final columns = await customSelect(
          'PRAGMA table_info(source_entries)',
        ).get();
        final names = columns.map((row) => row.read<String>('name')).toSet();
        if (!names.contains('modified_at')) {
          await customStatement(
            'ALTER TABLE source_entries ADD COLUMN modified_at TEXT',
          );
        }
        if (!names.contains('logical_role')) {
          await customStatement(
            "ALTER TABLE source_entries ADD COLUMN logical_role TEXT NOT NULL DEFAULT 'primary'",
          );
        }
        if (!names.contains('exclusion_reason')) {
          await customStatement(
            'ALTER TABLE source_entries ADD COLUMN exclusion_reason TEXT',
          );
        }
      }
    },
    beforeOpen: (_) async => customStatement('PRAGMA foreign_keys = ON'),
  );
}
