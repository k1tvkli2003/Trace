// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trace_database.dart';

// ignore_for_file: type=lint
class $LibraryEntriesTable extends LibraryEntries
    with TableInfo<$LibraryEntriesTable, LibraryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $LibraryEntriesTable createAlias(String alias) {
    return $LibraryEntriesTable(attachedDatabase, alias);
  }
}

class LibraryEntry extends DataClass implements Insertable<LibraryEntry> {
  final String id;
  final String title;
  const LibraryEntry({required this.id, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    return map;
  }

  LibraryEntriesCompanion toCompanion(bool nullToAbsent) {
    return LibraryEntriesCompanion(id: Value(id), title: Value(title));
  }

  factory LibraryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  LibraryEntry copyWith({String? id, String? title}) =>
      LibraryEntry(id: id ?? this.id, title: title ?? this.title);
  LibraryEntry copyWithCompanion(LibraryEntriesCompanion data) {
    return LibraryEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntry(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryEntry &&
          other.id == this.id &&
          other.title == this.title);
}

class LibraryEntriesCompanion extends UpdateCompanion<LibraryEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> rowid;
  const LibraryEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryEntriesCompanion.insert({
    required String id,
    required String title,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<LibraryEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? rowid,
  }) {
    return LibraryEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceEntriesTable extends SourceEntries
    with TableInfo<$SourceEntriesTable, SourceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryIdMeta = const VerificationMeta(
    'libraryId',
  );
  @override
  late final GeneratedColumn<String> libraryId = GeneratedColumn<String>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES library_entries (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sourceHashMeta = const VerificationMeta(
    'sourceHash',
  );
  @override
  late final GeneratedColumn<String> sourceHash = GeneratedColumn<String>(
    'source_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalBytesMeta = const VerificationMeta(
    'originalBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> originalBytes =
      GeneratedColumn<Uint8List>(
        'original_bytes',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    libraryId,
    name,
    version,
    sourceHash,
    mimeType,
    format,
    originalBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(
        _libraryIdMeta,
        libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('source_hash')) {
      context.handle(
        _sourceHashMeta,
        sourceHash.isAcceptableOrUnknown(data['source_hash']!, _sourceHashMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceHashMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('original_bytes')) {
      context.handle(
        _originalBytesMeta,
        originalBytes.isAcceptableOrUnknown(
          data['original_bytes']!,
          _originalBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalBytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      originalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}original_bytes'],
      )!,
    );
  }

  @override
  $SourceEntriesTable createAlias(String alias) {
    return $SourceEntriesTable(attachedDatabase, alias);
  }
}

class SourceEntry extends DataClass implements Insertable<SourceEntry> {
  final String id;
  final String libraryId;
  final String name;
  final int version;
  final String sourceHash;
  final String mimeType;
  final String format;
  final Uint8List originalBytes;
  const SourceEntry({
    required this.id,
    required this.libraryId,
    required this.name,
    required this.version,
    required this.sourceHash,
    required this.mimeType,
    required this.format,
    required this.originalBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['library_id'] = Variable<String>(libraryId);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<int>(version);
    map['source_hash'] = Variable<String>(sourceHash);
    map['mime_type'] = Variable<String>(mimeType);
    map['format'] = Variable<String>(format);
    map['original_bytes'] = Variable<Uint8List>(originalBytes);
    return map;
  }

  SourceEntriesCompanion toCompanion(bool nullToAbsent) {
    return SourceEntriesCompanion(
      id: Value(id),
      libraryId: Value(libraryId),
      name: Value(name),
      version: Value(version),
      sourceHash: Value(sourceHash),
      mimeType: Value(mimeType),
      format: Value(format),
      originalBytes: Value(originalBytes),
    );
  }

  factory SourceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceEntry(
      id: serializer.fromJson<String>(json['id']),
      libraryId: serializer.fromJson<String>(json['libraryId']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<int>(json['version']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      format: serializer.fromJson<String>(json['format']),
      originalBytes: serializer.fromJson<Uint8List>(json['originalBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'libraryId': serializer.toJson<String>(libraryId),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<int>(version),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'mimeType': serializer.toJson<String>(mimeType),
      'format': serializer.toJson<String>(format),
      'originalBytes': serializer.toJson<Uint8List>(originalBytes),
    };
  }

  SourceEntry copyWith({
    String? id,
    String? libraryId,
    String? name,
    int? version,
    String? sourceHash,
    String? mimeType,
    String? format,
    Uint8List? originalBytes,
  }) => SourceEntry(
    id: id ?? this.id,
    libraryId: libraryId ?? this.libraryId,
    name: name ?? this.name,
    version: version ?? this.version,
    sourceHash: sourceHash ?? this.sourceHash,
    mimeType: mimeType ?? this.mimeType,
    format: format ?? this.format,
    originalBytes: originalBytes ?? this.originalBytes,
  );
  SourceEntry copyWithCompanion(SourceEntriesCompanion data) {
    return SourceEntry(
      id: data.id.present ? data.id.value : this.id,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      name: data.name.present ? data.name.value : this.name,
      version: data.version.present ? data.version.value : this.version,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      format: data.format.present ? data.format.value : this.format,
      originalBytes: data.originalBytes.present
          ? data.originalBytes.value
          : this.originalBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceEntry(')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('mimeType: $mimeType, ')
          ..write('format: $format, ')
          ..write('originalBytes: $originalBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    libraryId,
    name,
    version,
    sourceHash,
    mimeType,
    format,
    $driftBlobEquality.hash(originalBytes),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceEntry &&
          other.id == this.id &&
          other.libraryId == this.libraryId &&
          other.name == this.name &&
          other.version == this.version &&
          other.sourceHash == this.sourceHash &&
          other.mimeType == this.mimeType &&
          other.format == this.format &&
          $driftBlobEquality.equals(other.originalBytes, this.originalBytes));
}

class SourceEntriesCompanion extends UpdateCompanion<SourceEntry> {
  final Value<String> id;
  final Value<String> libraryId;
  final Value<String> name;
  final Value<int> version;
  final Value<String> sourceHash;
  final Value<String> mimeType;
  final Value<String> format;
  final Value<Uint8List> originalBytes;
  final Value<int> rowid;
  const SourceEntriesCompanion({
    this.id = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.format = const Value.absent(),
    this.originalBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceEntriesCompanion.insert({
    required String id,
    required String libraryId,
    required String name,
    this.version = const Value.absent(),
    required String sourceHash,
    required String mimeType,
    required String format,
    required Uint8List originalBytes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       libraryId = Value(libraryId),
       name = Value(name),
       sourceHash = Value(sourceHash),
       mimeType = Value(mimeType),
       format = Value(format),
       originalBytes = Value(originalBytes);
  static Insertable<SourceEntry> custom({
    Expression<String>? id,
    Expression<String>? libraryId,
    Expression<String>? name,
    Expression<int>? version,
    Expression<String>? sourceHash,
    Expression<String>? mimeType,
    Expression<String>? format,
    Expression<Uint8List>? originalBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (libraryId != null) 'library_id': libraryId,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (mimeType != null) 'mime_type': mimeType,
      if (format != null) 'format': format,
      if (originalBytes != null) 'original_bytes': originalBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? libraryId,
    Value<String>? name,
    Value<int>? version,
    Value<String>? sourceHash,
    Value<String>? mimeType,
    Value<String>? format,
    Value<Uint8List>? originalBytes,
    Value<int>? rowid,
  }) {
    return SourceEntriesCompanion(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      name: name ?? this.name,
      version: version ?? this.version,
      sourceHash: sourceHash ?? this.sourceHash,
      mimeType: mimeType ?? this.mimeType,
      format: format ?? this.format,
      originalBytes: originalBytes ?? this.originalBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<String>(libraryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (originalBytes.present) {
      map['original_bytes'] = Variable<Uint8List>(originalBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('mimeType: $mimeType, ')
          ..write('format: $format, ')
          ..write('originalBytes: $originalBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TraceDatabase extends GeneratedDatabase {
  _$TraceDatabase(QueryExecutor e) : super(e);
  $TraceDatabaseManager get managers => $TraceDatabaseManager(this);
  late final $LibraryEntriesTable libraryEntries = $LibraryEntriesTable(this);
  late final $SourceEntriesTable sourceEntries = $SourceEntriesTable(this);
  late final Index sourceVersionUnique = Index(
    'source_version_unique',
    'CREATE UNIQUE INDEX source_version_unique ON source_entries (library_id, name, version)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    libraryEntries,
    sourceEntries,
    sourceVersionUnique,
  ];
}

typedef $$LibraryEntriesTableCreateCompanionBuilder =
    LibraryEntriesCompanion Function({
      required String id,
      required String title,
      Value<int> rowid,
    });
typedef $$LibraryEntriesTableUpdateCompanionBuilder =
    LibraryEntriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> rowid,
    });

final class $$LibraryEntriesTableReferences
    extends
        BaseReferences<_$TraceDatabase, $LibraryEntriesTable, LibraryEntry> {
  $$LibraryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SourceEntriesTable, List<SourceEntry>>
  _sourceEntriesRefsTable(_$TraceDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceEntries,
    aliasName: 'library_entries__id__source_entries__library_id',
  );

  $$SourceEntriesTableProcessedTableManager get sourceEntriesRefs {
    final manager = $$SourceEntriesTableTableManager(
      $_db,
      $_db.sourceEntries,
    ).filter((f) => f.libraryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LibraryEntriesTableFilterComposer
    extends Composer<_$TraceDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sourceEntriesRefs(
    Expression<bool> Function($$SourceEntriesTableFilterComposer f) f,
  ) {
    final $$SourceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.libraryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.sourceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LibraryEntriesTableOrderingComposer
    extends Composer<_$TraceDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryEntriesTableAnnotationComposer
    extends Composer<_$TraceDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> sourceEntriesRefs<T extends Object>(
    Expression<T> Function($$SourceEntriesTableAnnotationComposer a) f,
  ) {
    final $$SourceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.libraryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LibraryEntriesTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $LibraryEntriesTable,
          LibraryEntry,
          $$LibraryEntriesTableFilterComposer,
          $$LibraryEntriesTableOrderingComposer,
          $$LibraryEntriesTableAnnotationComposer,
          $$LibraryEntriesTableCreateCompanionBuilder,
          $$LibraryEntriesTableUpdateCompanionBuilder,
          (LibraryEntry, $$LibraryEntriesTableReferences),
          LibraryEntry,
          PrefetchHooks Function({bool sourceEntriesRefs})
        > {
  $$LibraryEntriesTableTableManager(
    _$TraceDatabase db,
    $LibraryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryEntriesCompanion(id: id, title: title, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<int> rowid = const Value.absent(),
              }) => LibraryEntriesCompanion.insert(
                id: id,
                title: title,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryEntriesTable, LibraryEntry>(table),
                  $$LibraryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sourceEntriesRefs) db.sourceEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sourceEntriesRefs)
                    await $_getPrefetchedData<
                      LibraryEntry,
                      $LibraryEntriesTable,
                      SourceEntry
                    >(
                      currentTable: table,
                      referencedTable: $$LibraryEntriesTableReferences
                          ._sourceEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LibraryEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).sourceEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.libraryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LibraryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $LibraryEntriesTable,
      LibraryEntry,
      $$LibraryEntriesTableFilterComposer,
      $$LibraryEntriesTableOrderingComposer,
      $$LibraryEntriesTableAnnotationComposer,
      $$LibraryEntriesTableCreateCompanionBuilder,
      $$LibraryEntriesTableUpdateCompanionBuilder,
      (LibraryEntry, $$LibraryEntriesTableReferences),
      LibraryEntry,
      PrefetchHooks Function({bool sourceEntriesRefs})
    >;
typedef $$SourceEntriesTableCreateCompanionBuilder =
    SourceEntriesCompanion Function({
      required String id,
      required String libraryId,
      required String name,
      Value<int> version,
      required String sourceHash,
      required String mimeType,
      required String format,
      required Uint8List originalBytes,
      Value<int> rowid,
    });
typedef $$SourceEntriesTableUpdateCompanionBuilder =
    SourceEntriesCompanion Function({
      Value<String> id,
      Value<String> libraryId,
      Value<String> name,
      Value<int> version,
      Value<String> sourceHash,
      Value<String> mimeType,
      Value<String> format,
      Value<Uint8List> originalBytes,
      Value<int> rowid,
    });

final class $$SourceEntriesTableReferences
    extends BaseReferences<_$TraceDatabase, $SourceEntriesTable, SourceEntry> {
  $$SourceEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LibraryEntriesTable _libraryIdTable(_$TraceDatabase db) => db
      .libraryEntries
      .createAlias('source_entries__library_id__library_entries__id');

  $$LibraryEntriesTableProcessedTableManager get libraryId {
    final $_column = $_itemColumn<String>('library_id')!;

    final manager = $$LibraryEntriesTableTableManager(
      $_db,
      $_db.libraryEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_libraryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceEntriesTableFilterComposer
    extends Composer<_$TraceDatabase, $SourceEntriesTable> {
  $$SourceEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get originalBytes => $composableBuilder(
    column: $table.originalBytes,
    builder: (column) => ColumnFilters(column),
  );

  $$LibraryEntriesTableFilterComposer get libraryId {
    final $$LibraryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.libraryId,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceEntriesTableOrderingComposer
    extends Composer<_$TraceDatabase, $SourceEntriesTable> {
  $$SourceEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get originalBytes => $composableBuilder(
    column: $table.originalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  $$LibraryEntriesTableOrderingComposer get libraryId {
    final $$LibraryEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.libraryId,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceEntriesTableAnnotationComposer
    extends Composer<_$TraceDatabase, $SourceEntriesTable> {
  $$SourceEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<Uint8List> get originalBytes => $composableBuilder(
    column: $table.originalBytes,
    builder: (column) => column,
  );

  $$LibraryEntriesTableAnnotationComposer get libraryId {
    final $$LibraryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.libraryId,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceEntriesTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $SourceEntriesTable,
          SourceEntry,
          $$SourceEntriesTableFilterComposer,
          $$SourceEntriesTableOrderingComposer,
          $$SourceEntriesTableAnnotationComposer,
          $$SourceEntriesTableCreateCompanionBuilder,
          $$SourceEntriesTableUpdateCompanionBuilder,
          (SourceEntry, $$SourceEntriesTableReferences),
          SourceEntry,
          PrefetchHooks Function({bool libraryId})
        > {
  $$SourceEntriesTableTableManager(
    _$TraceDatabase db,
    $SourceEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> libraryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<Uint8List> originalBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceEntriesCompanion(
                id: id,
                libraryId: libraryId,
                name: name,
                version: version,
                sourceHash: sourceHash,
                mimeType: mimeType,
                format: format,
                originalBytes: originalBytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String libraryId,
                required String name,
                Value<int> version = const Value.absent(),
                required String sourceHash,
                required String mimeType,
                required String format,
                required Uint8List originalBytes,
                Value<int> rowid = const Value.absent(),
              }) => SourceEntriesCompanion.insert(
                id: id,
                libraryId: libraryId,
                name: name,
                version: version,
                sourceHash: sourceHash,
                mimeType: mimeType,
                format: format,
                originalBytes: originalBytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceEntriesTable, SourceEntry>(table),
                  $$SourceEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({libraryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (libraryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.libraryId,
                                referencedTable: $$SourceEntriesTableReferences
                                    ._libraryIdTable(db),
                                referencedColumn: $$SourceEntriesTableReferences
                                    ._libraryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SourceEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $SourceEntriesTable,
      SourceEntry,
      $$SourceEntriesTableFilterComposer,
      $$SourceEntriesTableOrderingComposer,
      $$SourceEntriesTableAnnotationComposer,
      $$SourceEntriesTableCreateCompanionBuilder,
      $$SourceEntriesTableUpdateCompanionBuilder,
      (SourceEntry, $$SourceEntriesTableReferences),
      SourceEntry,
      PrefetchHooks Function({bool libraryId})
    >;

class $TraceDatabaseManager {
  final _$TraceDatabase _db;
  $TraceDatabaseManager(this._db);
  $$LibraryEntriesTableTableManager get libraryEntries =>
      $$LibraryEntriesTableTableManager(_db, _db.libraryEntries);
  $$SourceEntriesTableTableManager get sourceEntries =>
      $$SourceEntriesTableTableManager(_db, _db.sourceEntries);
}
