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

class $SourcePagesTable extends SourcePages
    with TableInfo<$SourcePagesTable, SourcePage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcePagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_entries (id)',
    ),
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
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pixelHashMeta = const VerificationMeta(
    'pixelHash',
  );
  @override
  late final GeneratedColumn<String> pixelHash = GeneratedColumn<String>(
    'pixel_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _renderProfileMeta = const VerificationMeta(
    'renderProfile',
  );
  @override
  late final GeneratedColumn<String> renderProfile = GeneratedColumn<String>(
    'render_profile',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visionStatusMeta = const VerificationMeta(
    'visionStatus',
  );
  @override
  late final GeneratedColumn<String> visionStatus = GeneratedColumn<String>(
    'vision_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    version,
    pageNumber,
    pixelHash,
    renderProfile,
    thumbnailPath,
    visionStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourcePage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('pixel_hash')) {
      context.handle(
        _pixelHashMeta,
        pixelHash.isAcceptableOrUnknown(data['pixel_hash']!, _pixelHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pixelHashMeta);
    }
    if (data.containsKey('render_profile')) {
      context.handle(
        _renderProfileMeta,
        renderProfile.isAcceptableOrUnknown(
          data['render_profile']!,
          _renderProfileMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_renderProfileMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbnailPathMeta);
    }
    if (data.containsKey('vision_status')) {
      context.handle(
        _visionStatusMeta,
        visionStatus.isAcceptableOrUnknown(
          data['vision_status']!,
          _visionStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_visionStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourcePage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourcePage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      pixelHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pixel_hash'],
      )!,
      renderProfile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}render_profile'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      )!,
      visionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vision_status'],
      )!,
    );
  }

  @override
  $SourcePagesTable createAlias(String alias) {
    return $SourcePagesTable(attachedDatabase, alias);
  }
}

class SourcePage extends DataClass implements Insertable<SourcePage> {
  final String id;
  final String documentId;
  final int version;
  final int pageNumber;
  final String pixelHash;
  final String renderProfile;
  final String thumbnailPath;
  final String visionStatus;
  const SourcePage({
    required this.id,
    required this.documentId,
    required this.version,
    required this.pageNumber,
    required this.pixelHash,
    required this.renderProfile,
    required this.thumbnailPath,
    required this.visionStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['version'] = Variable<int>(version);
    map['page_number'] = Variable<int>(pageNumber);
    map['pixel_hash'] = Variable<String>(pixelHash);
    map['render_profile'] = Variable<String>(renderProfile);
    map['thumbnail_path'] = Variable<String>(thumbnailPath);
    map['vision_status'] = Variable<String>(visionStatus);
    return map;
  }

  SourcePagesCompanion toCompanion(bool nullToAbsent) {
    return SourcePagesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      version: Value(version),
      pageNumber: Value(pageNumber),
      pixelHash: Value(pixelHash),
      renderProfile: Value(renderProfile),
      thumbnailPath: Value(thumbnailPath),
      visionStatus: Value(visionStatus),
    );
  }

  factory SourcePage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourcePage(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      version: serializer.fromJson<int>(json['version']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      pixelHash: serializer.fromJson<String>(json['pixelHash']),
      renderProfile: serializer.fromJson<String>(json['renderProfile']),
      thumbnailPath: serializer.fromJson<String>(json['thumbnailPath']),
      visionStatus: serializer.fromJson<String>(json['visionStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'version': serializer.toJson<int>(version),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'pixelHash': serializer.toJson<String>(pixelHash),
      'renderProfile': serializer.toJson<String>(renderProfile),
      'thumbnailPath': serializer.toJson<String>(thumbnailPath),
      'visionStatus': serializer.toJson<String>(visionStatus),
    };
  }

  SourcePage copyWith({
    String? id,
    String? documentId,
    int? version,
    int? pageNumber,
    String? pixelHash,
    String? renderProfile,
    String? thumbnailPath,
    String? visionStatus,
  }) => SourcePage(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    version: version ?? this.version,
    pageNumber: pageNumber ?? this.pageNumber,
    pixelHash: pixelHash ?? this.pixelHash,
    renderProfile: renderProfile ?? this.renderProfile,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    visionStatus: visionStatus ?? this.visionStatus,
  );
  SourcePage copyWithCompanion(SourcePagesCompanion data) {
    return SourcePage(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      version: data.version.present ? data.version.value : this.version,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      pixelHash: data.pixelHash.present ? data.pixelHash.value : this.pixelHash,
      renderProfile: data.renderProfile.present
          ? data.renderProfile.value
          : this.renderProfile,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      visionStatus: data.visionStatus.present
          ? data.visionStatus.value
          : this.visionStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourcePage(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('version: $version, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('pixelHash: $pixelHash, ')
          ..write('renderProfile: $renderProfile, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('visionStatus: $visionStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    version,
    pageNumber,
    pixelHash,
    renderProfile,
    thumbnailPath,
    visionStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourcePage &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.version == this.version &&
          other.pageNumber == this.pageNumber &&
          other.pixelHash == this.pixelHash &&
          other.renderProfile == this.renderProfile &&
          other.thumbnailPath == this.thumbnailPath &&
          other.visionStatus == this.visionStatus);
}

class SourcePagesCompanion extends UpdateCompanion<SourcePage> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<int> version;
  final Value<int> pageNumber;
  final Value<String> pixelHash;
  final Value<String> renderProfile;
  final Value<String> thumbnailPath;
  final Value<String> visionStatus;
  final Value<int> rowid;
  const SourcePagesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.version = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.pixelHash = const Value.absent(),
    this.renderProfile = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.visionStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcePagesCompanion.insert({
    required String id,
    required String documentId,
    this.version = const Value.absent(),
    required int pageNumber,
    required String pixelHash,
    required String renderProfile,
    required String thumbnailPath,
    required String visionStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentId = Value(documentId),
       pageNumber = Value(pageNumber),
       pixelHash = Value(pixelHash),
       renderProfile = Value(renderProfile),
       thumbnailPath = Value(thumbnailPath),
       visionStatus = Value(visionStatus);
  static Insertable<SourcePage> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<int>? version,
    Expression<int>? pageNumber,
    Expression<String>? pixelHash,
    Expression<String>? renderProfile,
    Expression<String>? thumbnailPath,
    Expression<String>? visionStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (version != null) 'version': version,
      if (pageNumber != null) 'page_number': pageNumber,
      if (pixelHash != null) 'pixel_hash': pixelHash,
      if (renderProfile != null) 'render_profile': renderProfile,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (visionStatus != null) 'vision_status': visionStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcePagesCompanion copyWith({
    Value<String>? id,
    Value<String>? documentId,
    Value<int>? version,
    Value<int>? pageNumber,
    Value<String>? pixelHash,
    Value<String>? renderProfile,
    Value<String>? thumbnailPath,
    Value<String>? visionStatus,
    Value<int>? rowid,
  }) {
    return SourcePagesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      version: version ?? this.version,
      pageNumber: pageNumber ?? this.pageNumber,
      pixelHash: pixelHash ?? this.pixelHash,
      renderProfile: renderProfile ?? this.renderProfile,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      visionStatus: visionStatus ?? this.visionStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (pixelHash.present) {
      map['pixel_hash'] = Variable<String>(pixelHash.value);
    }
    if (renderProfile.present) {
      map['render_profile'] = Variable<String>(renderProfile.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (visionStatus.present) {
      map['vision_status'] = Variable<String>(visionStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcePagesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('version: $version, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('pixelHash: $pixelHash, ')
          ..write('renderProfile: $renderProfile, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('visionStatus: $visionStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceBlocksTable extends SourceBlocks
    with TableInfo<$SourceBlocksTable, SourceBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_entries (id)',
    ),
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_pages (id)',
    ),
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
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedTextMeta = const VerificationMeta(
    'normalizedText',
  );
  @override
  late final GeneratedColumn<String> normalizedText = GeneratedColumn<String>(
    'normalized_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bboxXMeta = const VerificationMeta('bboxX');
  @override
  late final GeneratedColumn<double> bboxX = GeneratedColumn<double>(
    'bbox_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bboxYMeta = const VerificationMeta('bboxY');
  @override
  late final GeneratedColumn<double> bboxY = GeneratedColumn<double>(
    'bbox_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bboxWidthMeta = const VerificationMeta(
    'bboxWidth',
  );
  @override
  late final GeneratedColumn<double> bboxWidth = GeneratedColumn<double>(
    'bbox_width',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bboxHeightMeta = const VerificationMeta(
    'bboxHeight',
  );
  @override
  late final GeneratedColumn<double> bboxHeight = GeneratedColumn<double>(
    'bbox_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    pageId,
    version,
    sourceHash,
    order,
    kind,
    rawText,
    normalizedText,
    bboxX,
    bboxY,
    bboxWidth,
    bboxHeight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIdMeta);
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
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('normalized_text')) {
      context.handle(
        _normalizedTextMeta,
        normalizedText.isAcceptableOrUnknown(
          data['normalized_text']!,
          _normalizedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedTextMeta);
    }
    if (data.containsKey('bbox_x')) {
      context.handle(
        _bboxXMeta,
        bboxX.isAcceptableOrUnknown(data['bbox_x']!, _bboxXMeta),
      );
    }
    if (data.containsKey('bbox_y')) {
      context.handle(
        _bboxYMeta,
        bboxY.isAcceptableOrUnknown(data['bbox_y']!, _bboxYMeta),
      );
    }
    if (data.containsKey('bbox_width')) {
      context.handle(
        _bboxWidthMeta,
        bboxWidth.isAcceptableOrUnknown(data['bbox_width']!, _bboxWidthMeta),
      );
    }
    if (data.containsKey('bbox_height')) {
      context.handle(
        _bboxHeightMeta,
        bboxHeight.isAcceptableOrUnknown(data['bbox_height']!, _bboxHeightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceBlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      )!,
      normalizedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_text'],
      )!,
      bboxX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_x'],
      ),
      bboxY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_y'],
      ),
      bboxWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_width'],
      ),
      bboxHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_height'],
      ),
    );
  }

  @override
  $SourceBlocksTable createAlias(String alias) {
    return $SourceBlocksTable(attachedDatabase, alias);
  }
}

class SourceBlock extends DataClass implements Insertable<SourceBlock> {
  final String id;
  final String documentId;
  final String pageId;
  final int version;
  final String sourceHash;
  final int order;
  final String kind;
  final String rawText;
  final String normalizedText;
  final double? bboxX;
  final double? bboxY;
  final double? bboxWidth;
  final double? bboxHeight;
  const SourceBlock({
    required this.id,
    required this.documentId,
    required this.pageId,
    required this.version,
    required this.sourceHash,
    required this.order,
    required this.kind,
    required this.rawText,
    required this.normalizedText,
    this.bboxX,
    this.bboxY,
    this.bboxWidth,
    this.bboxHeight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['page_id'] = Variable<String>(pageId);
    map['version'] = Variable<int>(version);
    map['source_hash'] = Variable<String>(sourceHash);
    map['order'] = Variable<int>(order);
    map['kind'] = Variable<String>(kind);
    map['raw_text'] = Variable<String>(rawText);
    map['normalized_text'] = Variable<String>(normalizedText);
    if (!nullToAbsent || bboxX != null) {
      map['bbox_x'] = Variable<double>(bboxX);
    }
    if (!nullToAbsent || bboxY != null) {
      map['bbox_y'] = Variable<double>(bboxY);
    }
    if (!nullToAbsent || bboxWidth != null) {
      map['bbox_width'] = Variable<double>(bboxWidth);
    }
    if (!nullToAbsent || bboxHeight != null) {
      map['bbox_height'] = Variable<double>(bboxHeight);
    }
    return map;
  }

  SourceBlocksCompanion toCompanion(bool nullToAbsent) {
    return SourceBlocksCompanion(
      id: Value(id),
      documentId: Value(documentId),
      pageId: Value(pageId),
      version: Value(version),
      sourceHash: Value(sourceHash),
      order: Value(order),
      kind: Value(kind),
      rawText: Value(rawText),
      normalizedText: Value(normalizedText),
      bboxX: bboxX == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxX),
      bboxY: bboxY == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxY),
      bboxWidth: bboxWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxWidth),
      bboxHeight: bboxHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxHeight),
    );
  }

  factory SourceBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceBlock(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      pageId: serializer.fromJson<String>(json['pageId']),
      version: serializer.fromJson<int>(json['version']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      order: serializer.fromJson<int>(json['order']),
      kind: serializer.fromJson<String>(json['kind']),
      rawText: serializer.fromJson<String>(json['rawText']),
      normalizedText: serializer.fromJson<String>(json['normalizedText']),
      bboxX: serializer.fromJson<double?>(json['bboxX']),
      bboxY: serializer.fromJson<double?>(json['bboxY']),
      bboxWidth: serializer.fromJson<double?>(json['bboxWidth']),
      bboxHeight: serializer.fromJson<double?>(json['bboxHeight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'pageId': serializer.toJson<String>(pageId),
      'version': serializer.toJson<int>(version),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'order': serializer.toJson<int>(order),
      'kind': serializer.toJson<String>(kind),
      'rawText': serializer.toJson<String>(rawText),
      'normalizedText': serializer.toJson<String>(normalizedText),
      'bboxX': serializer.toJson<double?>(bboxX),
      'bboxY': serializer.toJson<double?>(bboxY),
      'bboxWidth': serializer.toJson<double?>(bboxWidth),
      'bboxHeight': serializer.toJson<double?>(bboxHeight),
    };
  }

  SourceBlock copyWith({
    String? id,
    String? documentId,
    String? pageId,
    int? version,
    String? sourceHash,
    int? order,
    String? kind,
    String? rawText,
    String? normalizedText,
    Value<double?> bboxX = const Value.absent(),
    Value<double?> bboxY = const Value.absent(),
    Value<double?> bboxWidth = const Value.absent(),
    Value<double?> bboxHeight = const Value.absent(),
  }) => SourceBlock(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    pageId: pageId ?? this.pageId,
    version: version ?? this.version,
    sourceHash: sourceHash ?? this.sourceHash,
    order: order ?? this.order,
    kind: kind ?? this.kind,
    rawText: rawText ?? this.rawText,
    normalizedText: normalizedText ?? this.normalizedText,
    bboxX: bboxX.present ? bboxX.value : this.bboxX,
    bboxY: bboxY.present ? bboxY.value : this.bboxY,
    bboxWidth: bboxWidth.present ? bboxWidth.value : this.bboxWidth,
    bboxHeight: bboxHeight.present ? bboxHeight.value : this.bboxHeight,
  );
  SourceBlock copyWithCompanion(SourceBlocksCompanion data) {
    return SourceBlock(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      version: data.version.present ? data.version.value : this.version,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      order: data.order.present ? data.order.value : this.order,
      kind: data.kind.present ? data.kind.value : this.kind,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      normalizedText: data.normalizedText.present
          ? data.normalizedText.value
          : this.normalizedText,
      bboxX: data.bboxX.present ? data.bboxX.value : this.bboxX,
      bboxY: data.bboxY.present ? data.bboxY.value : this.bboxY,
      bboxWidth: data.bboxWidth.present ? data.bboxWidth.value : this.bboxWidth,
      bboxHeight: data.bboxHeight.present
          ? data.bboxHeight.value
          : this.bboxHeight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceBlock(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('pageId: $pageId, ')
          ..write('version: $version, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('order: $order, ')
          ..write('kind: $kind, ')
          ..write('rawText: $rawText, ')
          ..write('normalizedText: $normalizedText, ')
          ..write('bboxX: $bboxX, ')
          ..write('bboxY: $bboxY, ')
          ..write('bboxWidth: $bboxWidth, ')
          ..write('bboxHeight: $bboxHeight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    pageId,
    version,
    sourceHash,
    order,
    kind,
    rawText,
    normalizedText,
    bboxX,
    bboxY,
    bboxWidth,
    bboxHeight,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceBlock &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.pageId == this.pageId &&
          other.version == this.version &&
          other.sourceHash == this.sourceHash &&
          other.order == this.order &&
          other.kind == this.kind &&
          other.rawText == this.rawText &&
          other.normalizedText == this.normalizedText &&
          other.bboxX == this.bboxX &&
          other.bboxY == this.bboxY &&
          other.bboxWidth == this.bboxWidth &&
          other.bboxHeight == this.bboxHeight);
}

class SourceBlocksCompanion extends UpdateCompanion<SourceBlock> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<String> pageId;
  final Value<int> version;
  final Value<String> sourceHash;
  final Value<int> order;
  final Value<String> kind;
  final Value<String> rawText;
  final Value<String> normalizedText;
  final Value<double?> bboxX;
  final Value<double?> bboxY;
  final Value<double?> bboxWidth;
  final Value<double?> bboxHeight;
  final Value<int> rowid;
  const SourceBlocksCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.pageId = const Value.absent(),
    this.version = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.order = const Value.absent(),
    this.kind = const Value.absent(),
    this.rawText = const Value.absent(),
    this.normalizedText = const Value.absent(),
    this.bboxX = const Value.absent(),
    this.bboxY = const Value.absent(),
    this.bboxWidth = const Value.absent(),
    this.bboxHeight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceBlocksCompanion.insert({
    required String id,
    required String documentId,
    required String pageId,
    this.version = const Value.absent(),
    required String sourceHash,
    required int order,
    required String kind,
    required String rawText,
    required String normalizedText,
    this.bboxX = const Value.absent(),
    this.bboxY = const Value.absent(),
    this.bboxWidth = const Value.absent(),
    this.bboxHeight = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentId = Value(documentId),
       pageId = Value(pageId),
       sourceHash = Value(sourceHash),
       order = Value(order),
       kind = Value(kind),
       rawText = Value(rawText),
       normalizedText = Value(normalizedText);
  static Insertable<SourceBlock> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<String>? pageId,
    Expression<int>? version,
    Expression<String>? sourceHash,
    Expression<int>? order,
    Expression<String>? kind,
    Expression<String>? rawText,
    Expression<String>? normalizedText,
    Expression<double>? bboxX,
    Expression<double>? bboxY,
    Expression<double>? bboxWidth,
    Expression<double>? bboxHeight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (pageId != null) 'page_id': pageId,
      if (version != null) 'version': version,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (order != null) 'order': order,
      if (kind != null) 'kind': kind,
      if (rawText != null) 'raw_text': rawText,
      if (normalizedText != null) 'normalized_text': normalizedText,
      if (bboxX != null) 'bbox_x': bboxX,
      if (bboxY != null) 'bbox_y': bboxY,
      if (bboxWidth != null) 'bbox_width': bboxWidth,
      if (bboxHeight != null) 'bbox_height': bboxHeight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? documentId,
    Value<String>? pageId,
    Value<int>? version,
    Value<String>? sourceHash,
    Value<int>? order,
    Value<String>? kind,
    Value<String>? rawText,
    Value<String>? normalizedText,
    Value<double?>? bboxX,
    Value<double?>? bboxY,
    Value<double?>? bboxWidth,
    Value<double?>? bboxHeight,
    Value<int>? rowid,
  }) {
    return SourceBlocksCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      pageId: pageId ?? this.pageId,
      version: version ?? this.version,
      sourceHash: sourceHash ?? this.sourceHash,
      order: order ?? this.order,
      kind: kind ?? this.kind,
      rawText: rawText ?? this.rawText,
      normalizedText: normalizedText ?? this.normalizedText,
      bboxX: bboxX ?? this.bboxX,
      bboxY: bboxY ?? this.bboxY,
      bboxWidth: bboxWidth ?? this.bboxWidth,
      bboxHeight: bboxHeight ?? this.bboxHeight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (normalizedText.present) {
      map['normalized_text'] = Variable<String>(normalizedText.value);
    }
    if (bboxX.present) {
      map['bbox_x'] = Variable<double>(bboxX.value);
    }
    if (bboxY.present) {
      map['bbox_y'] = Variable<double>(bboxY.value);
    }
    if (bboxWidth.present) {
      map['bbox_width'] = Variable<double>(bboxWidth.value);
    }
    if (bboxHeight.present) {
      map['bbox_height'] = Variable<double>(bboxHeight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceBlocksCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('pageId: $pageId, ')
          ..write('version: $version, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('order: $order, ')
          ..write('kind: $kind, ')
          ..write('rawText: $rawText, ')
          ..write('normalizedText: $normalizedText, ')
          ..write('bboxX: $bboxX, ')
          ..write('bboxY: $bboxY, ')
          ..write('bboxWidth: $bboxWidth, ')
          ..write('bboxHeight: $bboxHeight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceCitationsTable extends SourceCitations
    with TableInfo<$SourceCitationsTable, SourceCitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceCitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceBlockIdMeta = const VerificationMeta(
    'sourceBlockId',
  );
  @override
  late final GeneratedColumn<String> sourceBlockId = GeneratedColumn<String>(
    'source_block_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_blocks (id)',
    ),
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_pages (id)',
    ),
  );
  static const VerificationMeta _figureIdMeta = const VerificationMeta(
    'figureId',
  );
  @override
  late final GeneratedColumn<String> figureId = GeneratedColumn<String>(
    'figure_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteMeta = const VerificationMeta('quote');
  @override
  late final GeneratedColumn<String> quote = GeneratedColumn<String>(
    'quote',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locatorMeta = const VerificationMeta(
    'locator',
  );
  @override
  late final GeneratedColumn<String> locator = GeneratedColumn<String>(
    'locator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractionVersionMeta = const VerificationMeta(
    'extractionVersion',
  );
  @override
  late final GeneratedColumn<String> extractionVersion =
      GeneratedColumn<String>(
        'extraction_version',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    contentHash,
    sourceBlockId,
    pageId,
    figureId,
    quote,
    locator,
    confidence,
    extractionVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_citations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceCitation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('source_block_id')) {
      context.handle(
        _sourceBlockIdMeta,
        sourceBlockId.isAcceptableOrUnknown(
          data['source_block_id']!,
          _sourceBlockIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceBlockIdMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('figure_id')) {
      context.handle(
        _figureIdMeta,
        figureId.isAcceptableOrUnknown(data['figure_id']!, _figureIdMeta),
      );
    }
    if (data.containsKey('quote')) {
      context.handle(
        _quoteMeta,
        quote.isAcceptableOrUnknown(data['quote']!, _quoteMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteMeta);
    }
    if (data.containsKey('locator')) {
      context.handle(
        _locatorMeta,
        locator.isAcceptableOrUnknown(data['locator']!, _locatorMeta),
      );
    } else if (isInserting) {
      context.missing(_locatorMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('extraction_version')) {
      context.handle(
        _extractionVersionMeta,
        extractionVersion.isAcceptableOrUnknown(
          data['extraction_version']!,
          _extractionVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractionVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceCitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceCitation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      sourceBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_block_id'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      )!,
      figureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}figure_id'],
      ),
      quote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote'],
      )!,
      locator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locator'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      extractionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_version'],
      )!,
    );
  }

  @override
  $SourceCitationsTable createAlias(String alias) {
    return $SourceCitationsTable(attachedDatabase, alias);
  }
}

class SourceCitation extends DataClass implements Insertable<SourceCitation> {
  final String id;
  final int version;
  final String contentHash;
  final String sourceBlockId;
  final String pageId;
  final String? figureId;
  final String quote;
  final String locator;
  final double confidence;
  final String extractionVersion;
  const SourceCitation({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.sourceBlockId,
    required this.pageId,
    this.figureId,
    required this.quote,
    required this.locator,
    required this.confidence,
    required this.extractionVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<int>(version);
    map['content_hash'] = Variable<String>(contentHash);
    map['source_block_id'] = Variable<String>(sourceBlockId);
    map['page_id'] = Variable<String>(pageId);
    if (!nullToAbsent || figureId != null) {
      map['figure_id'] = Variable<String>(figureId);
    }
    map['quote'] = Variable<String>(quote);
    map['locator'] = Variable<String>(locator);
    map['confidence'] = Variable<double>(confidence);
    map['extraction_version'] = Variable<String>(extractionVersion);
    return map;
  }

  SourceCitationsCompanion toCompanion(bool nullToAbsent) {
    return SourceCitationsCompanion(
      id: Value(id),
      version: Value(version),
      contentHash: Value(contentHash),
      sourceBlockId: Value(sourceBlockId),
      pageId: Value(pageId),
      figureId: figureId == null && nullToAbsent
          ? const Value.absent()
          : Value(figureId),
      quote: Value(quote),
      locator: Value(locator),
      confidence: Value(confidence),
      extractionVersion: Value(extractionVersion),
    );
  }

  factory SourceCitation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceCitation(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      sourceBlockId: serializer.fromJson<String>(json['sourceBlockId']),
      pageId: serializer.fromJson<String>(json['pageId']),
      figureId: serializer.fromJson<String?>(json['figureId']),
      quote: serializer.fromJson<String>(json['quote']),
      locator: serializer.fromJson<String>(json['locator']),
      confidence: serializer.fromJson<double>(json['confidence']),
      extractionVersion: serializer.fromJson<String>(json['extractionVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<int>(version),
      'contentHash': serializer.toJson<String>(contentHash),
      'sourceBlockId': serializer.toJson<String>(sourceBlockId),
      'pageId': serializer.toJson<String>(pageId),
      'figureId': serializer.toJson<String?>(figureId),
      'quote': serializer.toJson<String>(quote),
      'locator': serializer.toJson<String>(locator),
      'confidence': serializer.toJson<double>(confidence),
      'extractionVersion': serializer.toJson<String>(extractionVersion),
    };
  }

  SourceCitation copyWith({
    String? id,
    int? version,
    String? contentHash,
    String? sourceBlockId,
    String? pageId,
    Value<String?> figureId = const Value.absent(),
    String? quote,
    String? locator,
    double? confidence,
    String? extractionVersion,
  }) => SourceCitation(
    id: id ?? this.id,
    version: version ?? this.version,
    contentHash: contentHash ?? this.contentHash,
    sourceBlockId: sourceBlockId ?? this.sourceBlockId,
    pageId: pageId ?? this.pageId,
    figureId: figureId.present ? figureId.value : this.figureId,
    quote: quote ?? this.quote,
    locator: locator ?? this.locator,
    confidence: confidence ?? this.confidence,
    extractionVersion: extractionVersion ?? this.extractionVersion,
  );
  SourceCitation copyWithCompanion(SourceCitationsCompanion data) {
    return SourceCitation(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      sourceBlockId: data.sourceBlockId.present
          ? data.sourceBlockId.value
          : this.sourceBlockId,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      figureId: data.figureId.present ? data.figureId.value : this.figureId,
      quote: data.quote.present ? data.quote.value : this.quote,
      locator: data.locator.present ? data.locator.value : this.locator,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      extractionVersion: data.extractionVersion.present
          ? data.extractionVersion.value
          : this.extractionVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceCitation(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('pageId: $pageId, ')
          ..write('figureId: $figureId, ')
          ..write('quote: $quote, ')
          ..write('locator: $locator, ')
          ..write('confidence: $confidence, ')
          ..write('extractionVersion: $extractionVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    version,
    contentHash,
    sourceBlockId,
    pageId,
    figureId,
    quote,
    locator,
    confidence,
    extractionVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceCitation &&
          other.id == this.id &&
          other.version == this.version &&
          other.contentHash == this.contentHash &&
          other.sourceBlockId == this.sourceBlockId &&
          other.pageId == this.pageId &&
          other.figureId == this.figureId &&
          other.quote == this.quote &&
          other.locator == this.locator &&
          other.confidence == this.confidence &&
          other.extractionVersion == this.extractionVersion);
}

class SourceCitationsCompanion extends UpdateCompanion<SourceCitation> {
  final Value<String> id;
  final Value<int> version;
  final Value<String> contentHash;
  final Value<String> sourceBlockId;
  final Value<String> pageId;
  final Value<String?> figureId;
  final Value<String> quote;
  final Value<String> locator;
  final Value<double> confidence;
  final Value<String> extractionVersion;
  final Value<int> rowid;
  const SourceCitationsCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.sourceBlockId = const Value.absent(),
    this.pageId = const Value.absent(),
    this.figureId = const Value.absent(),
    this.quote = const Value.absent(),
    this.locator = const Value.absent(),
    this.confidence = const Value.absent(),
    this.extractionVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceCitationsCompanion.insert({
    required String id,
    this.version = const Value.absent(),
    required String contentHash,
    required String sourceBlockId,
    required String pageId,
    this.figureId = const Value.absent(),
    required String quote,
    required String locator,
    required double confidence,
    required String extractionVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contentHash = Value(contentHash),
       sourceBlockId = Value(sourceBlockId),
       pageId = Value(pageId),
       quote = Value(quote),
       locator = Value(locator),
       confidence = Value(confidence),
       extractionVersion = Value(extractionVersion);
  static Insertable<SourceCitation> custom({
    Expression<String>? id,
    Expression<int>? version,
    Expression<String>? contentHash,
    Expression<String>? sourceBlockId,
    Expression<String>? pageId,
    Expression<String>? figureId,
    Expression<String>? quote,
    Expression<String>? locator,
    Expression<double>? confidence,
    Expression<String>? extractionVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (contentHash != null) 'content_hash': contentHash,
      if (sourceBlockId != null) 'source_block_id': sourceBlockId,
      if (pageId != null) 'page_id': pageId,
      if (figureId != null) 'figure_id': figureId,
      if (quote != null) 'quote': quote,
      if (locator != null) 'locator': locator,
      if (confidence != null) 'confidence': confidence,
      if (extractionVersion != null) 'extraction_version': extractionVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceCitationsCompanion copyWith({
    Value<String>? id,
    Value<int>? version,
    Value<String>? contentHash,
    Value<String>? sourceBlockId,
    Value<String>? pageId,
    Value<String?>? figureId,
    Value<String>? quote,
    Value<String>? locator,
    Value<double>? confidence,
    Value<String>? extractionVersion,
    Value<int>? rowid,
  }) {
    return SourceCitationsCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      contentHash: contentHash ?? this.contentHash,
      sourceBlockId: sourceBlockId ?? this.sourceBlockId,
      pageId: pageId ?? this.pageId,
      figureId: figureId ?? this.figureId,
      quote: quote ?? this.quote,
      locator: locator ?? this.locator,
      confidence: confidence ?? this.confidence,
      extractionVersion: extractionVersion ?? this.extractionVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (sourceBlockId.present) {
      map['source_block_id'] = Variable<String>(sourceBlockId.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (figureId.present) {
      map['figure_id'] = Variable<String>(figureId.value);
    }
    if (quote.present) {
      map['quote'] = Variable<String>(quote.value);
    }
    if (locator.present) {
      map['locator'] = Variable<String>(locator.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (extractionVersion.present) {
      map['extraction_version'] = Variable<String>(extractionVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceCitationsCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('pageId: $pageId, ')
          ..write('figureId: $figureId, ')
          ..write('quote: $quote, ')
          ..write('locator: $locator, ')
          ..write('confidence: $confidence, ')
          ..write('extractionVersion: $extractionVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FigureAssetsTable extends FigureAssets
    with TableInfo<$FigureAssetsTable, FigureAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FigureAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetHashMeta = const VerificationMeta(
    'assetHash',
  );
  @override
  late final GeneratedColumn<String> assetHash = GeneratedColumn<String>(
    'asset_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _pagePixelHashMeta = const VerificationMeta(
    'pagePixelHash',
  );
  @override
  late final GeneratedColumn<String> pagePixelHash = GeneratedColumn<String>(
    'page_pixel_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_pages (id)',
    ),
  );
  static const VerificationMeta _bboxXMeta = const VerificationMeta('bboxX');
  @override
  late final GeneratedColumn<double> bboxX = GeneratedColumn<double>(
    'bbox_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bboxYMeta = const VerificationMeta('bboxY');
  @override
  late final GeneratedColumn<double> bboxY = GeneratedColumn<double>(
    'bbox_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bboxWidthMeta = const VerificationMeta(
    'bboxWidth',
  );
  @override
  late final GeneratedColumn<double> bboxWidth = GeneratedColumn<double>(
    'bbox_width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bboxHeightMeta = const VerificationMeta(
    'bboxHeight',
  );
  @override
  late final GeneratedColumn<double> bboxHeight = GeneratedColumn<double>(
    'bbox_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthPxMeta = const VerificationMeta(
    'widthPx',
  );
  @override
  late final GeneratedColumn<int> widthPx = GeneratedColumn<int>(
    'width_px',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightPxMeta = const VerificationMeta(
    'heightPx',
  );
  @override
  late final GeneratedColumn<int> heightPx = GeneratedColumn<int>(
    'height_px',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altTextMeta = const VerificationMeta(
    'altText',
  );
  @override
  late final GeneratedColumn<String> altText = GeneratedColumn<String>(
    'alt_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropBytesMeta = const VerificationMeta(
    'cropBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> cropBytes = GeneratedColumn<Uint8List>(
    'crop_bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    assetHash,
    sourceHash,
    pagePixelHash,
    pageId,
    bboxX,
    bboxY,
    bboxWidth,
    bboxHeight,
    widthPx,
    heightPx,
    caption,
    altText,
    reviewStatus,
    cropBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'figure_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<FigureAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('asset_hash')) {
      context.handle(
        _assetHashMeta,
        assetHash.isAcceptableOrUnknown(data['asset_hash']!, _assetHashMeta),
      );
    } else if (isInserting) {
      context.missing(_assetHashMeta);
    }
    if (data.containsKey('source_hash')) {
      context.handle(
        _sourceHashMeta,
        sourceHash.isAcceptableOrUnknown(data['source_hash']!, _sourceHashMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceHashMeta);
    }
    if (data.containsKey('page_pixel_hash')) {
      context.handle(
        _pagePixelHashMeta,
        pagePixelHash.isAcceptableOrUnknown(
          data['page_pixel_hash']!,
          _pagePixelHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pagePixelHashMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('bbox_x')) {
      context.handle(
        _bboxXMeta,
        bboxX.isAcceptableOrUnknown(data['bbox_x']!, _bboxXMeta),
      );
    } else if (isInserting) {
      context.missing(_bboxXMeta);
    }
    if (data.containsKey('bbox_y')) {
      context.handle(
        _bboxYMeta,
        bboxY.isAcceptableOrUnknown(data['bbox_y']!, _bboxYMeta),
      );
    } else if (isInserting) {
      context.missing(_bboxYMeta);
    }
    if (data.containsKey('bbox_width')) {
      context.handle(
        _bboxWidthMeta,
        bboxWidth.isAcceptableOrUnknown(data['bbox_width']!, _bboxWidthMeta),
      );
    } else if (isInserting) {
      context.missing(_bboxWidthMeta);
    }
    if (data.containsKey('bbox_height')) {
      context.handle(
        _bboxHeightMeta,
        bboxHeight.isAcceptableOrUnknown(data['bbox_height']!, _bboxHeightMeta),
      );
    } else if (isInserting) {
      context.missing(_bboxHeightMeta);
    }
    if (data.containsKey('width_px')) {
      context.handle(
        _widthPxMeta,
        widthPx.isAcceptableOrUnknown(data['width_px']!, _widthPxMeta),
      );
    } else if (isInserting) {
      context.missing(_widthPxMeta);
    }
    if (data.containsKey('height_px')) {
      context.handle(
        _heightPxMeta,
        heightPx.isAcceptableOrUnknown(data['height_px']!, _heightPxMeta),
      );
    } else if (isInserting) {
      context.missing(_heightPxMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    } else if (isInserting) {
      context.missing(_captionMeta);
    }
    if (data.containsKey('alt_text')) {
      context.handle(
        _altTextMeta,
        altText.isAcceptableOrUnknown(data['alt_text']!, _altTextMeta),
      );
    } else if (isInserting) {
      context.missing(_altTextMeta);
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewStatusMeta);
    }
    if (data.containsKey('crop_bytes')) {
      context.handle(
        _cropBytesMeta,
        cropBytes.isAcceptableOrUnknown(data['crop_bytes']!, _cropBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_cropBytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FigureAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FigureAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      assetHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_hash'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      pagePixelHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_pixel_hash'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      )!,
      bboxX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_x'],
      )!,
      bboxY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_y'],
      )!,
      bboxWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_width'],
      )!,
      bboxHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_height'],
      )!,
      widthPx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width_px'],
      )!,
      heightPx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_px'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      )!,
      altText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt_text'],
      )!,
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      cropBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}crop_bytes'],
      )!,
    );
  }

  @override
  $FigureAssetsTable createAlias(String alias) {
    return $FigureAssetsTable(attachedDatabase, alias);
  }
}

class FigureAsset extends DataClass implements Insertable<FigureAsset> {
  final String id;
  final int version;
  final String assetHash;
  final String sourceHash;
  final String pagePixelHash;
  final String pageId;
  final double bboxX;
  final double bboxY;
  final double bboxWidth;
  final double bboxHeight;
  final int widthPx;
  final int heightPx;
  final String caption;
  final String altText;
  final String reviewStatus;
  final Uint8List cropBytes;
  const FigureAsset({
    required this.id,
    required this.version,
    required this.assetHash,
    required this.sourceHash,
    required this.pagePixelHash,
    required this.pageId,
    required this.bboxX,
    required this.bboxY,
    required this.bboxWidth,
    required this.bboxHeight,
    required this.widthPx,
    required this.heightPx,
    required this.caption,
    required this.altText,
    required this.reviewStatus,
    required this.cropBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<int>(version);
    map['asset_hash'] = Variable<String>(assetHash);
    map['source_hash'] = Variable<String>(sourceHash);
    map['page_pixel_hash'] = Variable<String>(pagePixelHash);
    map['page_id'] = Variable<String>(pageId);
    map['bbox_x'] = Variable<double>(bboxX);
    map['bbox_y'] = Variable<double>(bboxY);
    map['bbox_width'] = Variable<double>(bboxWidth);
    map['bbox_height'] = Variable<double>(bboxHeight);
    map['width_px'] = Variable<int>(widthPx);
    map['height_px'] = Variable<int>(heightPx);
    map['caption'] = Variable<String>(caption);
    map['alt_text'] = Variable<String>(altText);
    map['review_status'] = Variable<String>(reviewStatus);
    map['crop_bytes'] = Variable<Uint8List>(cropBytes);
    return map;
  }

  FigureAssetsCompanion toCompanion(bool nullToAbsent) {
    return FigureAssetsCompanion(
      id: Value(id),
      version: Value(version),
      assetHash: Value(assetHash),
      sourceHash: Value(sourceHash),
      pagePixelHash: Value(pagePixelHash),
      pageId: Value(pageId),
      bboxX: Value(bboxX),
      bboxY: Value(bboxY),
      bboxWidth: Value(bboxWidth),
      bboxHeight: Value(bboxHeight),
      widthPx: Value(widthPx),
      heightPx: Value(heightPx),
      caption: Value(caption),
      altText: Value(altText),
      reviewStatus: Value(reviewStatus),
      cropBytes: Value(cropBytes),
    );
  }

  factory FigureAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FigureAsset(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      assetHash: serializer.fromJson<String>(json['assetHash']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      pagePixelHash: serializer.fromJson<String>(json['pagePixelHash']),
      pageId: serializer.fromJson<String>(json['pageId']),
      bboxX: serializer.fromJson<double>(json['bboxX']),
      bboxY: serializer.fromJson<double>(json['bboxY']),
      bboxWidth: serializer.fromJson<double>(json['bboxWidth']),
      bboxHeight: serializer.fromJson<double>(json['bboxHeight']),
      widthPx: serializer.fromJson<int>(json['widthPx']),
      heightPx: serializer.fromJson<int>(json['heightPx']),
      caption: serializer.fromJson<String>(json['caption']),
      altText: serializer.fromJson<String>(json['altText']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      cropBytes: serializer.fromJson<Uint8List>(json['cropBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<int>(version),
      'assetHash': serializer.toJson<String>(assetHash),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'pagePixelHash': serializer.toJson<String>(pagePixelHash),
      'pageId': serializer.toJson<String>(pageId),
      'bboxX': serializer.toJson<double>(bboxX),
      'bboxY': serializer.toJson<double>(bboxY),
      'bboxWidth': serializer.toJson<double>(bboxWidth),
      'bboxHeight': serializer.toJson<double>(bboxHeight),
      'widthPx': serializer.toJson<int>(widthPx),
      'heightPx': serializer.toJson<int>(heightPx),
      'caption': serializer.toJson<String>(caption),
      'altText': serializer.toJson<String>(altText),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'cropBytes': serializer.toJson<Uint8List>(cropBytes),
    };
  }

  FigureAsset copyWith({
    String? id,
    int? version,
    String? assetHash,
    String? sourceHash,
    String? pagePixelHash,
    String? pageId,
    double? bboxX,
    double? bboxY,
    double? bboxWidth,
    double? bboxHeight,
    int? widthPx,
    int? heightPx,
    String? caption,
    String? altText,
    String? reviewStatus,
    Uint8List? cropBytes,
  }) => FigureAsset(
    id: id ?? this.id,
    version: version ?? this.version,
    assetHash: assetHash ?? this.assetHash,
    sourceHash: sourceHash ?? this.sourceHash,
    pagePixelHash: pagePixelHash ?? this.pagePixelHash,
    pageId: pageId ?? this.pageId,
    bboxX: bboxX ?? this.bboxX,
    bboxY: bboxY ?? this.bboxY,
    bboxWidth: bboxWidth ?? this.bboxWidth,
    bboxHeight: bboxHeight ?? this.bboxHeight,
    widthPx: widthPx ?? this.widthPx,
    heightPx: heightPx ?? this.heightPx,
    caption: caption ?? this.caption,
    altText: altText ?? this.altText,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    cropBytes: cropBytes ?? this.cropBytes,
  );
  FigureAsset copyWithCompanion(FigureAssetsCompanion data) {
    return FigureAsset(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      assetHash: data.assetHash.present ? data.assetHash.value : this.assetHash,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      pagePixelHash: data.pagePixelHash.present
          ? data.pagePixelHash.value
          : this.pagePixelHash,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      bboxX: data.bboxX.present ? data.bboxX.value : this.bboxX,
      bboxY: data.bboxY.present ? data.bboxY.value : this.bboxY,
      bboxWidth: data.bboxWidth.present ? data.bboxWidth.value : this.bboxWidth,
      bboxHeight: data.bboxHeight.present
          ? data.bboxHeight.value
          : this.bboxHeight,
      widthPx: data.widthPx.present ? data.widthPx.value : this.widthPx,
      heightPx: data.heightPx.present ? data.heightPx.value : this.heightPx,
      caption: data.caption.present ? data.caption.value : this.caption,
      altText: data.altText.present ? data.altText.value : this.altText,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      cropBytes: data.cropBytes.present ? data.cropBytes.value : this.cropBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FigureAsset(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('assetHash: $assetHash, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('pagePixelHash: $pagePixelHash, ')
          ..write('pageId: $pageId, ')
          ..write('bboxX: $bboxX, ')
          ..write('bboxY: $bboxY, ')
          ..write('bboxWidth: $bboxWidth, ')
          ..write('bboxHeight: $bboxHeight, ')
          ..write('widthPx: $widthPx, ')
          ..write('heightPx: $heightPx, ')
          ..write('caption: $caption, ')
          ..write('altText: $altText, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('cropBytes: $cropBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    version,
    assetHash,
    sourceHash,
    pagePixelHash,
    pageId,
    bboxX,
    bboxY,
    bboxWidth,
    bboxHeight,
    widthPx,
    heightPx,
    caption,
    altText,
    reviewStatus,
    $driftBlobEquality.hash(cropBytes),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FigureAsset &&
          other.id == this.id &&
          other.version == this.version &&
          other.assetHash == this.assetHash &&
          other.sourceHash == this.sourceHash &&
          other.pagePixelHash == this.pagePixelHash &&
          other.pageId == this.pageId &&
          other.bboxX == this.bboxX &&
          other.bboxY == this.bboxY &&
          other.bboxWidth == this.bboxWidth &&
          other.bboxHeight == this.bboxHeight &&
          other.widthPx == this.widthPx &&
          other.heightPx == this.heightPx &&
          other.caption == this.caption &&
          other.altText == this.altText &&
          other.reviewStatus == this.reviewStatus &&
          $driftBlobEquality.equals(other.cropBytes, this.cropBytes));
}

class FigureAssetsCompanion extends UpdateCompanion<FigureAsset> {
  final Value<String> id;
  final Value<int> version;
  final Value<String> assetHash;
  final Value<String> sourceHash;
  final Value<String> pagePixelHash;
  final Value<String> pageId;
  final Value<double> bboxX;
  final Value<double> bboxY;
  final Value<double> bboxWidth;
  final Value<double> bboxHeight;
  final Value<int> widthPx;
  final Value<int> heightPx;
  final Value<String> caption;
  final Value<String> altText;
  final Value<String> reviewStatus;
  final Value<Uint8List> cropBytes;
  final Value<int> rowid;
  const FigureAssetsCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.assetHash = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.pagePixelHash = const Value.absent(),
    this.pageId = const Value.absent(),
    this.bboxX = const Value.absent(),
    this.bboxY = const Value.absent(),
    this.bboxWidth = const Value.absent(),
    this.bboxHeight = const Value.absent(),
    this.widthPx = const Value.absent(),
    this.heightPx = const Value.absent(),
    this.caption = const Value.absent(),
    this.altText = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.cropBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FigureAssetsCompanion.insert({
    required String id,
    required int version,
    required String assetHash,
    required String sourceHash,
    required String pagePixelHash,
    required String pageId,
    required double bboxX,
    required double bboxY,
    required double bboxWidth,
    required double bboxHeight,
    required int widthPx,
    required int heightPx,
    required String caption,
    required String altText,
    required String reviewStatus,
    required Uint8List cropBytes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       version = Value(version),
       assetHash = Value(assetHash),
       sourceHash = Value(sourceHash),
       pagePixelHash = Value(pagePixelHash),
       pageId = Value(pageId),
       bboxX = Value(bboxX),
       bboxY = Value(bboxY),
       bboxWidth = Value(bboxWidth),
       bboxHeight = Value(bboxHeight),
       widthPx = Value(widthPx),
       heightPx = Value(heightPx),
       caption = Value(caption),
       altText = Value(altText),
       reviewStatus = Value(reviewStatus),
       cropBytes = Value(cropBytes);
  static Insertable<FigureAsset> custom({
    Expression<String>? id,
    Expression<int>? version,
    Expression<String>? assetHash,
    Expression<String>? sourceHash,
    Expression<String>? pagePixelHash,
    Expression<String>? pageId,
    Expression<double>? bboxX,
    Expression<double>? bboxY,
    Expression<double>? bboxWidth,
    Expression<double>? bboxHeight,
    Expression<int>? widthPx,
    Expression<int>? heightPx,
    Expression<String>? caption,
    Expression<String>? altText,
    Expression<String>? reviewStatus,
    Expression<Uint8List>? cropBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (assetHash != null) 'asset_hash': assetHash,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (pagePixelHash != null) 'page_pixel_hash': pagePixelHash,
      if (pageId != null) 'page_id': pageId,
      if (bboxX != null) 'bbox_x': bboxX,
      if (bboxY != null) 'bbox_y': bboxY,
      if (bboxWidth != null) 'bbox_width': bboxWidth,
      if (bboxHeight != null) 'bbox_height': bboxHeight,
      if (widthPx != null) 'width_px': widthPx,
      if (heightPx != null) 'height_px': heightPx,
      if (caption != null) 'caption': caption,
      if (altText != null) 'alt_text': altText,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (cropBytes != null) 'crop_bytes': cropBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FigureAssetsCompanion copyWith({
    Value<String>? id,
    Value<int>? version,
    Value<String>? assetHash,
    Value<String>? sourceHash,
    Value<String>? pagePixelHash,
    Value<String>? pageId,
    Value<double>? bboxX,
    Value<double>? bboxY,
    Value<double>? bboxWidth,
    Value<double>? bboxHeight,
    Value<int>? widthPx,
    Value<int>? heightPx,
    Value<String>? caption,
    Value<String>? altText,
    Value<String>? reviewStatus,
    Value<Uint8List>? cropBytes,
    Value<int>? rowid,
  }) {
    return FigureAssetsCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      assetHash: assetHash ?? this.assetHash,
      sourceHash: sourceHash ?? this.sourceHash,
      pagePixelHash: pagePixelHash ?? this.pagePixelHash,
      pageId: pageId ?? this.pageId,
      bboxX: bboxX ?? this.bboxX,
      bboxY: bboxY ?? this.bboxY,
      bboxWidth: bboxWidth ?? this.bboxWidth,
      bboxHeight: bboxHeight ?? this.bboxHeight,
      widthPx: widthPx ?? this.widthPx,
      heightPx: heightPx ?? this.heightPx,
      caption: caption ?? this.caption,
      altText: altText ?? this.altText,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      cropBytes: cropBytes ?? this.cropBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (assetHash.present) {
      map['asset_hash'] = Variable<String>(assetHash.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (pagePixelHash.present) {
      map['page_pixel_hash'] = Variable<String>(pagePixelHash.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (bboxX.present) {
      map['bbox_x'] = Variable<double>(bboxX.value);
    }
    if (bboxY.present) {
      map['bbox_y'] = Variable<double>(bboxY.value);
    }
    if (bboxWidth.present) {
      map['bbox_width'] = Variable<double>(bboxWidth.value);
    }
    if (bboxHeight.present) {
      map['bbox_height'] = Variable<double>(bboxHeight.value);
    }
    if (widthPx.present) {
      map['width_px'] = Variable<int>(widthPx.value);
    }
    if (heightPx.present) {
      map['height_px'] = Variable<int>(heightPx.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (altText.present) {
      map['alt_text'] = Variable<String>(altText.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (cropBytes.present) {
      map['crop_bytes'] = Variable<Uint8List>(cropBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FigureAssetsCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('assetHash: $assetHash, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('pagePixelHash: $pagePixelHash, ')
          ..write('pageId: $pageId, ')
          ..write('bboxX: $bboxX, ')
          ..write('bboxY: $bboxY, ')
          ..write('bboxWidth: $bboxWidth, ')
          ..write('bboxHeight: $bboxHeight, ')
          ..write('widthPx: $widthPx, ')
          ..write('heightPx: $heightPx, ')
          ..write('caption: $caption, ')
          ..write('altText: $altText, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('cropBytes: $cropBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonArtifactsTable extends LessonArtifacts
    with TableInfo<$LessonArtifactsTable, LessonArtifact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonArtifactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sliceIdMeta = const VerificationMeta(
    'sliceId',
  );
  @override
  late final GeneratedColumn<String> sliceId = GeneratedColumn<String>(
    'slice_id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sliceId,
    version,
    contentHash,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_artifacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonArtifact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slice_id')) {
      context.handle(
        _sliceIdMeta,
        sliceId.isAcceptableOrUnknown(data['slice_id']!, _sliceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sliceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonArtifact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonArtifact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sliceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slice_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $LessonArtifactsTable createAlias(String alias) {
    return $LessonArtifactsTable(attachedDatabase, alias);
  }
}

class LessonArtifact extends DataClass implements Insertable<LessonArtifact> {
  final String id;
  final String sliceId;
  final int version;
  final String contentHash;
  final String payloadJson;
  const LessonArtifact({
    required this.id,
    required this.sliceId,
    required this.version,
    required this.contentHash,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slice_id'] = Variable<String>(sliceId);
    map['version'] = Variable<int>(version);
    map['content_hash'] = Variable<String>(contentHash);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  LessonArtifactsCompanion toCompanion(bool nullToAbsent) {
    return LessonArtifactsCompanion(
      id: Value(id),
      sliceId: Value(sliceId),
      version: Value(version),
      contentHash: Value(contentHash),
      payloadJson: Value(payloadJson),
    );
  }

  factory LessonArtifact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonArtifact(
      id: serializer.fromJson<String>(json['id']),
      sliceId: serializer.fromJson<String>(json['sliceId']),
      version: serializer.fromJson<int>(json['version']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sliceId': serializer.toJson<String>(sliceId),
      'version': serializer.toJson<int>(version),
      'contentHash': serializer.toJson<String>(contentHash),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  LessonArtifact copyWith({
    String? id,
    String? sliceId,
    int? version,
    String? contentHash,
    String? payloadJson,
  }) => LessonArtifact(
    id: id ?? this.id,
    sliceId: sliceId ?? this.sliceId,
    version: version ?? this.version,
    contentHash: contentHash ?? this.contentHash,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  LessonArtifact copyWithCompanion(LessonArtifactsCompanion data) {
    return LessonArtifact(
      id: data.id.present ? data.id.value : this.id,
      sliceId: data.sliceId.present ? data.sliceId.value : this.sliceId,
      version: data.version.present ? data.version.value : this.version,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonArtifact(')
          ..write('id: $id, ')
          ..write('sliceId: $sliceId, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sliceId, version, contentHash, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonArtifact &&
          other.id == this.id &&
          other.sliceId == this.sliceId &&
          other.version == this.version &&
          other.contentHash == this.contentHash &&
          other.payloadJson == this.payloadJson);
}

class LessonArtifactsCompanion extends UpdateCompanion<LessonArtifact> {
  final Value<String> id;
  final Value<String> sliceId;
  final Value<int> version;
  final Value<String> contentHash;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const LessonArtifactsCompanion({
    this.id = const Value.absent(),
    this.sliceId = const Value.absent(),
    this.version = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonArtifactsCompanion.insert({
    required String id,
    required String sliceId,
    required int version,
    required String contentHash,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sliceId = Value(sliceId),
       version = Value(version),
       contentHash = Value(contentHash),
       payloadJson = Value(payloadJson);
  static Insertable<LessonArtifact> custom({
    Expression<String>? id,
    Expression<String>? sliceId,
    Expression<int>? version,
    Expression<String>? contentHash,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sliceId != null) 'slice_id': sliceId,
      if (version != null) 'version': version,
      if (contentHash != null) 'content_hash': contentHash,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonArtifactsCompanion copyWith({
    Value<String>? id,
    Value<String>? sliceId,
    Value<int>? version,
    Value<String>? contentHash,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return LessonArtifactsCompanion(
      id: id ?? this.id,
      sliceId: sliceId ?? this.sliceId,
      version: version ?? this.version,
      contentHash: contentHash ?? this.contentHash,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sliceId.present) {
      map['slice_id'] = Variable<String>(sliceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonArtifactsCompanion(')
          ..write('id: $id, ')
          ..write('sliceId: $sliceId, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearnerStatesTable extends LearnerStates
    with TableInfo<$LearnerStatesTable, LearnerState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnerStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sliceIdMeta = const VerificationMeta(
    'sliceId',
  );
  @override
  late final GeneratedColumn<String> sliceId = GeneratedColumn<String>(
    'slice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonArtifactIdMeta = const VerificationMeta(
    'lessonArtifactId',
  );
  @override
  late final GeneratedColumn<String> lessonArtifactId = GeneratedColumn<String>(
    'lesson_artifact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lesson_artifacts (id)',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sliceId,
    lessonArtifactId,
    version,
    contentHash,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learner_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnerState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slice_id')) {
      context.handle(
        _sliceIdMeta,
        sliceId.isAcceptableOrUnknown(data['slice_id']!, _sliceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sliceIdMeta);
    }
    if (data.containsKey('lesson_artifact_id')) {
      context.handle(
        _lessonArtifactIdMeta,
        lessonArtifactId.isAcceptableOrUnknown(
          data['lesson_artifact_id']!,
          _lessonArtifactIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lessonArtifactIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearnerState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnerState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sliceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slice_id'],
      )!,
      lessonArtifactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_artifact_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $LearnerStatesTable createAlias(String alias) {
    return $LearnerStatesTable(attachedDatabase, alias);
  }
}

class LearnerState extends DataClass implements Insertable<LearnerState> {
  final String id;
  final String sliceId;
  final String lessonArtifactId;
  final int version;
  final String contentHash;
  final String payloadJson;
  const LearnerState({
    required this.id,
    required this.sliceId,
    required this.lessonArtifactId,
    required this.version,
    required this.contentHash,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slice_id'] = Variable<String>(sliceId);
    map['lesson_artifact_id'] = Variable<String>(lessonArtifactId);
    map['version'] = Variable<int>(version);
    map['content_hash'] = Variable<String>(contentHash);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  LearnerStatesCompanion toCompanion(bool nullToAbsent) {
    return LearnerStatesCompanion(
      id: Value(id),
      sliceId: Value(sliceId),
      lessonArtifactId: Value(lessonArtifactId),
      version: Value(version),
      contentHash: Value(contentHash),
      payloadJson: Value(payloadJson),
    );
  }

  factory LearnerState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnerState(
      id: serializer.fromJson<String>(json['id']),
      sliceId: serializer.fromJson<String>(json['sliceId']),
      lessonArtifactId: serializer.fromJson<String>(json['lessonArtifactId']),
      version: serializer.fromJson<int>(json['version']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sliceId': serializer.toJson<String>(sliceId),
      'lessonArtifactId': serializer.toJson<String>(lessonArtifactId),
      'version': serializer.toJson<int>(version),
      'contentHash': serializer.toJson<String>(contentHash),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  LearnerState copyWith({
    String? id,
    String? sliceId,
    String? lessonArtifactId,
    int? version,
    String? contentHash,
    String? payloadJson,
  }) => LearnerState(
    id: id ?? this.id,
    sliceId: sliceId ?? this.sliceId,
    lessonArtifactId: lessonArtifactId ?? this.lessonArtifactId,
    version: version ?? this.version,
    contentHash: contentHash ?? this.contentHash,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  LearnerState copyWithCompanion(LearnerStatesCompanion data) {
    return LearnerState(
      id: data.id.present ? data.id.value : this.id,
      sliceId: data.sliceId.present ? data.sliceId.value : this.sliceId,
      lessonArtifactId: data.lessonArtifactId.present
          ? data.lessonArtifactId.value
          : this.lessonArtifactId,
      version: data.version.present ? data.version.value : this.version,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnerState(')
          ..write('id: $id, ')
          ..write('sliceId: $sliceId, ')
          ..write('lessonArtifactId: $lessonArtifactId, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sliceId,
    lessonArtifactId,
    version,
    contentHash,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnerState &&
          other.id == this.id &&
          other.sliceId == this.sliceId &&
          other.lessonArtifactId == this.lessonArtifactId &&
          other.version == this.version &&
          other.contentHash == this.contentHash &&
          other.payloadJson == this.payloadJson);
}

class LearnerStatesCompanion extends UpdateCompanion<LearnerState> {
  final Value<String> id;
  final Value<String> sliceId;
  final Value<String> lessonArtifactId;
  final Value<int> version;
  final Value<String> contentHash;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const LearnerStatesCompanion({
    this.id = const Value.absent(),
    this.sliceId = const Value.absent(),
    this.lessonArtifactId = const Value.absent(),
    this.version = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnerStatesCompanion.insert({
    required String id,
    required String sliceId,
    required String lessonArtifactId,
    required int version,
    required String contentHash,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sliceId = Value(sliceId),
       lessonArtifactId = Value(lessonArtifactId),
       version = Value(version),
       contentHash = Value(contentHash),
       payloadJson = Value(payloadJson);
  static Insertable<LearnerState> custom({
    Expression<String>? id,
    Expression<String>? sliceId,
    Expression<String>? lessonArtifactId,
    Expression<int>? version,
    Expression<String>? contentHash,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sliceId != null) 'slice_id': sliceId,
      if (lessonArtifactId != null) 'lesson_artifact_id': lessonArtifactId,
      if (version != null) 'version': version,
      if (contentHash != null) 'content_hash': contentHash,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnerStatesCompanion copyWith({
    Value<String>? id,
    Value<String>? sliceId,
    Value<String>? lessonArtifactId,
    Value<int>? version,
    Value<String>? contentHash,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return LearnerStatesCompanion(
      id: id ?? this.id,
      sliceId: sliceId ?? this.sliceId,
      lessonArtifactId: lessonArtifactId ?? this.lessonArtifactId,
      version: version ?? this.version,
      contentHash: contentHash ?? this.contentHash,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sliceId.present) {
      map['slice_id'] = Variable<String>(sliceId.value);
    }
    if (lessonArtifactId.present) {
      map['lesson_artifact_id'] = Variable<String>(lessonArtifactId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearnerStatesCompanion(')
          ..write('id: $id, ')
          ..write('sliceId: $sliceId, ')
          ..write('lessonArtifactId: $lessonArtifactId, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightAnchorsTable extends HighlightAnchors
    with TableInfo<$HighlightAnchorsTable, HighlightAnchor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightAnchorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashAtCreationMeta =
      const VerificationMeta('contentHashAtCreation');
  @override
  late final GeneratedColumn<String> contentHashAtCreation =
      GeneratedColumn<String>(
        'content_hash_at_creation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceBlockIdMeta = const VerificationMeta(
    'sourceBlockId',
  );
  @override
  late final GeneratedColumn<String> sourceBlockId = GeneratedColumn<String>(
    'source_block_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonBlockIdMeta = const VerificationMeta(
    'lessonBlockId',
  );
  @override
  late final GeneratedColumn<String> lessonBlockId = GeneratedColumn<String>(
    'lesson_block_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteMeta = const VerificationMeta('quote');
  @override
  late final GeneratedColumn<String> quote = GeneratedColumn<String>(
    'quote',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
    'prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suffixMeta = const VerificationMeta('suffix');
  @override
  late final GeneratedColumn<String> suffix = GeneratedColumn<String>(
    'suffix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startOffsetMeta = const VerificationMeta(
    'startOffset',
  );
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
    'start_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endOffsetMeta = const VerificationMeta(
    'endOffset',
  );
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
    'end_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bboxXMeta = const VerificationMeta('bboxX');
  @override
  late final GeneratedColumn<double> bboxX = GeneratedColumn<double>(
    'bbox_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bboxYMeta = const VerificationMeta('bboxY');
  @override
  late final GeneratedColumn<double> bboxY = GeneratedColumn<double>(
    'bbox_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bboxWMeta = const VerificationMeta('bboxW');
  @override
  late final GeneratedColumn<double> bboxW = GeneratedColumn<double>(
    'bbox_w',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bboxHMeta = const VerificationMeta('bboxH');
  @override
  late final GeneratedColumn<double> bboxH = GeneratedColumn<double>(
    'bbox_h',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tombstoneMeta = const VerificationMeta(
    'tombstone',
  );
  @override
  late final GeneratedColumn<bool> tombstone = GeneratedColumn<bool>(
    'tombstone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tombstone" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tombstonedAtMeta = const VerificationMeta(
    'tombstonedAt',
  );
  @override
  late final GeneratedColumn<String> tombstonedAt = GeneratedColumn<String>(
    'tombstoned_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    contentHashAtCreation,
    sourceBlockId,
    pageId,
    lessonBlockId,
    quote,
    prefix,
    suffix,
    startOffset,
    endOffset,
    bboxX,
    bboxY,
    bboxW,
    bboxH,
    color,
    status,
    tombstone,
    tombstonedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlight_anchors';
  @override
  VerificationContext validateIntegrity(
    Insertable<HighlightAnchor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('content_hash_at_creation')) {
      context.handle(
        _contentHashAtCreationMeta,
        contentHashAtCreation.isAcceptableOrUnknown(
          data['content_hash_at_creation']!,
          _contentHashAtCreationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashAtCreationMeta);
    }
    if (data.containsKey('source_block_id')) {
      context.handle(
        _sourceBlockIdMeta,
        sourceBlockId.isAcceptableOrUnknown(
          data['source_block_id']!,
          _sourceBlockIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceBlockIdMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('lesson_block_id')) {
      context.handle(
        _lessonBlockIdMeta,
        lessonBlockId.isAcceptableOrUnknown(
          data['lesson_block_id']!,
          _lessonBlockIdMeta,
        ),
      );
    }
    if (data.containsKey('quote')) {
      context.handle(
        _quoteMeta,
        quote.isAcceptableOrUnknown(data['quote']!, _quoteMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteMeta);
    }
    if (data.containsKey('prefix')) {
      context.handle(
        _prefixMeta,
        prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta),
      );
    } else if (isInserting) {
      context.missing(_prefixMeta);
    }
    if (data.containsKey('suffix')) {
      context.handle(
        _suffixMeta,
        suffix.isAcceptableOrUnknown(data['suffix']!, _suffixMeta),
      );
    } else if (isInserting) {
      context.missing(_suffixMeta);
    }
    if (data.containsKey('start_offset')) {
      context.handle(
        _startOffsetMeta,
        startOffset.isAcceptableOrUnknown(
          data['start_offset']!,
          _startOffsetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startOffsetMeta);
    }
    if (data.containsKey('end_offset')) {
      context.handle(
        _endOffsetMeta,
        endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta),
      );
    } else if (isInserting) {
      context.missing(_endOffsetMeta);
    }
    if (data.containsKey('bbox_x')) {
      context.handle(
        _bboxXMeta,
        bboxX.isAcceptableOrUnknown(data['bbox_x']!, _bboxXMeta),
      );
    }
    if (data.containsKey('bbox_y')) {
      context.handle(
        _bboxYMeta,
        bboxY.isAcceptableOrUnknown(data['bbox_y']!, _bboxYMeta),
      );
    }
    if (data.containsKey('bbox_w')) {
      context.handle(
        _bboxWMeta,
        bboxW.isAcceptableOrUnknown(data['bbox_w']!, _bboxWMeta),
      );
    }
    if (data.containsKey('bbox_h')) {
      context.handle(
        _bboxHMeta,
        bboxH.isAcceptableOrUnknown(data['bbox_h']!, _bboxHMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('tombstone')) {
      context.handle(
        _tombstoneMeta,
        tombstone.isAcceptableOrUnknown(data['tombstone']!, _tombstoneMeta),
      );
    }
    if (data.containsKey('tombstoned_at')) {
      context.handle(
        _tombstonedAtMeta,
        tombstonedAt.isAcceptableOrUnknown(
          data['tombstoned_at']!,
          _tombstonedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighlightAnchor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighlightAnchor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      contentHashAtCreation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash_at_creation'],
      )!,
      sourceBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_block_id'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      )!,
      lessonBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_block_id'],
      ),
      quote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote'],
      )!,
      prefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prefix'],
      )!,
      suffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suffix'],
      )!,
      startOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset'],
      )!,
      endOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset'],
      )!,
      bboxX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_x'],
      ),
      bboxY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_y'],
      ),
      bboxW: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_w'],
      ),
      bboxH: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bbox_h'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tombstone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tombstone'],
      )!,
      tombstonedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tombstoned_at'],
      ),
    );
  }

  @override
  $HighlightAnchorsTable createAlias(String alias) {
    return $HighlightAnchorsTable(attachedDatabase, alias);
  }
}

class HighlightAnchor extends DataClass implements Insertable<HighlightAnchor> {
  final String id;
  final int version;
  final String contentHashAtCreation;
  final String sourceBlockId;
  final String pageId;
  final String? lessonBlockId;
  final String quote;
  final String prefix;
  final String suffix;
  final int startOffset;
  final int endOffset;
  final double? bboxX;
  final double? bboxY;
  final double? bboxW;
  final double? bboxH;
  final String color;
  final String status;
  final bool tombstone;
  final String? tombstonedAt;
  const HighlightAnchor({
    required this.id,
    required this.version,
    required this.contentHashAtCreation,
    required this.sourceBlockId,
    required this.pageId,
    this.lessonBlockId,
    required this.quote,
    required this.prefix,
    required this.suffix,
    required this.startOffset,
    required this.endOffset,
    this.bboxX,
    this.bboxY,
    this.bboxW,
    this.bboxH,
    required this.color,
    required this.status,
    required this.tombstone,
    this.tombstonedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<int>(version);
    map['content_hash_at_creation'] = Variable<String>(contentHashAtCreation);
    map['source_block_id'] = Variable<String>(sourceBlockId);
    map['page_id'] = Variable<String>(pageId);
    if (!nullToAbsent || lessonBlockId != null) {
      map['lesson_block_id'] = Variable<String>(lessonBlockId);
    }
    map['quote'] = Variable<String>(quote);
    map['prefix'] = Variable<String>(prefix);
    map['suffix'] = Variable<String>(suffix);
    map['start_offset'] = Variable<int>(startOffset);
    map['end_offset'] = Variable<int>(endOffset);
    if (!nullToAbsent || bboxX != null) {
      map['bbox_x'] = Variable<double>(bboxX);
    }
    if (!nullToAbsent || bboxY != null) {
      map['bbox_y'] = Variable<double>(bboxY);
    }
    if (!nullToAbsent || bboxW != null) {
      map['bbox_w'] = Variable<double>(bboxW);
    }
    if (!nullToAbsent || bboxH != null) {
      map['bbox_h'] = Variable<double>(bboxH);
    }
    map['color'] = Variable<String>(color);
    map['status'] = Variable<String>(status);
    map['tombstone'] = Variable<bool>(tombstone);
    if (!nullToAbsent || tombstonedAt != null) {
      map['tombstoned_at'] = Variable<String>(tombstonedAt);
    }
    return map;
  }

  HighlightAnchorsCompanion toCompanion(bool nullToAbsent) {
    return HighlightAnchorsCompanion(
      id: Value(id),
      version: Value(version),
      contentHashAtCreation: Value(contentHashAtCreation),
      sourceBlockId: Value(sourceBlockId),
      pageId: Value(pageId),
      lessonBlockId: lessonBlockId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonBlockId),
      quote: Value(quote),
      prefix: Value(prefix),
      suffix: Value(suffix),
      startOffset: Value(startOffset),
      endOffset: Value(endOffset),
      bboxX: bboxX == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxX),
      bboxY: bboxY == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxY),
      bboxW: bboxW == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxW),
      bboxH: bboxH == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxH),
      color: Value(color),
      status: Value(status),
      tombstone: Value(tombstone),
      tombstonedAt: tombstonedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(tombstonedAt),
    );
  }

  factory HighlightAnchor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighlightAnchor(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      contentHashAtCreation: serializer.fromJson<String>(
        json['contentHashAtCreation'],
      ),
      sourceBlockId: serializer.fromJson<String>(json['sourceBlockId']),
      pageId: serializer.fromJson<String>(json['pageId']),
      lessonBlockId: serializer.fromJson<String?>(json['lessonBlockId']),
      quote: serializer.fromJson<String>(json['quote']),
      prefix: serializer.fromJson<String>(json['prefix']),
      suffix: serializer.fromJson<String>(json['suffix']),
      startOffset: serializer.fromJson<int>(json['startOffset']),
      endOffset: serializer.fromJson<int>(json['endOffset']),
      bboxX: serializer.fromJson<double?>(json['bboxX']),
      bboxY: serializer.fromJson<double?>(json['bboxY']),
      bboxW: serializer.fromJson<double?>(json['bboxW']),
      bboxH: serializer.fromJson<double?>(json['bboxH']),
      color: serializer.fromJson<String>(json['color']),
      status: serializer.fromJson<String>(json['status']),
      tombstone: serializer.fromJson<bool>(json['tombstone']),
      tombstonedAt: serializer.fromJson<String?>(json['tombstonedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<int>(version),
      'contentHashAtCreation': serializer.toJson<String>(contentHashAtCreation),
      'sourceBlockId': serializer.toJson<String>(sourceBlockId),
      'pageId': serializer.toJson<String>(pageId),
      'lessonBlockId': serializer.toJson<String?>(lessonBlockId),
      'quote': serializer.toJson<String>(quote),
      'prefix': serializer.toJson<String>(prefix),
      'suffix': serializer.toJson<String>(suffix),
      'startOffset': serializer.toJson<int>(startOffset),
      'endOffset': serializer.toJson<int>(endOffset),
      'bboxX': serializer.toJson<double?>(bboxX),
      'bboxY': serializer.toJson<double?>(bboxY),
      'bboxW': serializer.toJson<double?>(bboxW),
      'bboxH': serializer.toJson<double?>(bboxH),
      'color': serializer.toJson<String>(color),
      'status': serializer.toJson<String>(status),
      'tombstone': serializer.toJson<bool>(tombstone),
      'tombstonedAt': serializer.toJson<String?>(tombstonedAt),
    };
  }

  HighlightAnchor copyWith({
    String? id,
    int? version,
    String? contentHashAtCreation,
    String? sourceBlockId,
    String? pageId,
    Value<String?> lessonBlockId = const Value.absent(),
    String? quote,
    String? prefix,
    String? suffix,
    int? startOffset,
    int? endOffset,
    Value<double?> bboxX = const Value.absent(),
    Value<double?> bboxY = const Value.absent(),
    Value<double?> bboxW = const Value.absent(),
    Value<double?> bboxH = const Value.absent(),
    String? color,
    String? status,
    bool? tombstone,
    Value<String?> tombstonedAt = const Value.absent(),
  }) => HighlightAnchor(
    id: id ?? this.id,
    version: version ?? this.version,
    contentHashAtCreation: contentHashAtCreation ?? this.contentHashAtCreation,
    sourceBlockId: sourceBlockId ?? this.sourceBlockId,
    pageId: pageId ?? this.pageId,
    lessonBlockId: lessonBlockId.present
        ? lessonBlockId.value
        : this.lessonBlockId,
    quote: quote ?? this.quote,
    prefix: prefix ?? this.prefix,
    suffix: suffix ?? this.suffix,
    startOffset: startOffset ?? this.startOffset,
    endOffset: endOffset ?? this.endOffset,
    bboxX: bboxX.present ? bboxX.value : this.bboxX,
    bboxY: bboxY.present ? bboxY.value : this.bboxY,
    bboxW: bboxW.present ? bboxW.value : this.bboxW,
    bboxH: bboxH.present ? bboxH.value : this.bboxH,
    color: color ?? this.color,
    status: status ?? this.status,
    tombstone: tombstone ?? this.tombstone,
    tombstonedAt: tombstonedAt.present ? tombstonedAt.value : this.tombstonedAt,
  );
  HighlightAnchor copyWithCompanion(HighlightAnchorsCompanion data) {
    return HighlightAnchor(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      contentHashAtCreation: data.contentHashAtCreation.present
          ? data.contentHashAtCreation.value
          : this.contentHashAtCreation,
      sourceBlockId: data.sourceBlockId.present
          ? data.sourceBlockId.value
          : this.sourceBlockId,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      lessonBlockId: data.lessonBlockId.present
          ? data.lessonBlockId.value
          : this.lessonBlockId,
      quote: data.quote.present ? data.quote.value : this.quote,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      suffix: data.suffix.present ? data.suffix.value : this.suffix,
      startOffset: data.startOffset.present
          ? data.startOffset.value
          : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      bboxX: data.bboxX.present ? data.bboxX.value : this.bboxX,
      bboxY: data.bboxY.present ? data.bboxY.value : this.bboxY,
      bboxW: data.bboxW.present ? data.bboxW.value : this.bboxW,
      bboxH: data.bboxH.present ? data.bboxH.value : this.bboxH,
      color: data.color.present ? data.color.value : this.color,
      status: data.status.present ? data.status.value : this.status,
      tombstone: data.tombstone.present ? data.tombstone.value : this.tombstone,
      tombstonedAt: data.tombstonedAt.present
          ? data.tombstonedAt.value
          : this.tombstonedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighlightAnchor(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('contentHashAtCreation: $contentHashAtCreation, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('pageId: $pageId, ')
          ..write('lessonBlockId: $lessonBlockId, ')
          ..write('quote: $quote, ')
          ..write('prefix: $prefix, ')
          ..write('suffix: $suffix, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('bboxX: $bboxX, ')
          ..write('bboxY: $bboxY, ')
          ..write('bboxW: $bboxW, ')
          ..write('bboxH: $bboxH, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('tombstone: $tombstone, ')
          ..write('tombstonedAt: $tombstonedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    version,
    contentHashAtCreation,
    sourceBlockId,
    pageId,
    lessonBlockId,
    quote,
    prefix,
    suffix,
    startOffset,
    endOffset,
    bboxX,
    bboxY,
    bboxW,
    bboxH,
    color,
    status,
    tombstone,
    tombstonedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighlightAnchor &&
          other.id == this.id &&
          other.version == this.version &&
          other.contentHashAtCreation == this.contentHashAtCreation &&
          other.sourceBlockId == this.sourceBlockId &&
          other.pageId == this.pageId &&
          other.lessonBlockId == this.lessonBlockId &&
          other.quote == this.quote &&
          other.prefix == this.prefix &&
          other.suffix == this.suffix &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.bboxX == this.bboxX &&
          other.bboxY == this.bboxY &&
          other.bboxW == this.bboxW &&
          other.bboxH == this.bboxH &&
          other.color == this.color &&
          other.status == this.status &&
          other.tombstone == this.tombstone &&
          other.tombstonedAt == this.tombstonedAt);
}

class HighlightAnchorsCompanion extends UpdateCompanion<HighlightAnchor> {
  final Value<String> id;
  final Value<int> version;
  final Value<String> contentHashAtCreation;
  final Value<String> sourceBlockId;
  final Value<String> pageId;
  final Value<String?> lessonBlockId;
  final Value<String> quote;
  final Value<String> prefix;
  final Value<String> suffix;
  final Value<int> startOffset;
  final Value<int> endOffset;
  final Value<double?> bboxX;
  final Value<double?> bboxY;
  final Value<double?> bboxW;
  final Value<double?> bboxH;
  final Value<String> color;
  final Value<String> status;
  final Value<bool> tombstone;
  final Value<String?> tombstonedAt;
  final Value<int> rowid;
  const HighlightAnchorsCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.contentHashAtCreation = const Value.absent(),
    this.sourceBlockId = const Value.absent(),
    this.pageId = const Value.absent(),
    this.lessonBlockId = const Value.absent(),
    this.quote = const Value.absent(),
    this.prefix = const Value.absent(),
    this.suffix = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.bboxX = const Value.absent(),
    this.bboxY = const Value.absent(),
    this.bboxW = const Value.absent(),
    this.bboxH = const Value.absent(),
    this.color = const Value.absent(),
    this.status = const Value.absent(),
    this.tombstone = const Value.absent(),
    this.tombstonedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HighlightAnchorsCompanion.insert({
    required String id,
    required int version,
    required String contentHashAtCreation,
    required String sourceBlockId,
    required String pageId,
    this.lessonBlockId = const Value.absent(),
    required String quote,
    required String prefix,
    required String suffix,
    required int startOffset,
    required int endOffset,
    this.bboxX = const Value.absent(),
    this.bboxY = const Value.absent(),
    this.bboxW = const Value.absent(),
    this.bboxH = const Value.absent(),
    required String color,
    required String status,
    this.tombstone = const Value.absent(),
    this.tombstonedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       version = Value(version),
       contentHashAtCreation = Value(contentHashAtCreation),
       sourceBlockId = Value(sourceBlockId),
       pageId = Value(pageId),
       quote = Value(quote),
       prefix = Value(prefix),
       suffix = Value(suffix),
       startOffset = Value(startOffset),
       endOffset = Value(endOffset),
       color = Value(color),
       status = Value(status);
  static Insertable<HighlightAnchor> custom({
    Expression<String>? id,
    Expression<int>? version,
    Expression<String>? contentHashAtCreation,
    Expression<String>? sourceBlockId,
    Expression<String>? pageId,
    Expression<String>? lessonBlockId,
    Expression<String>? quote,
    Expression<String>? prefix,
    Expression<String>? suffix,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<double>? bboxX,
    Expression<double>? bboxY,
    Expression<double>? bboxW,
    Expression<double>? bboxH,
    Expression<String>? color,
    Expression<String>? status,
    Expression<bool>? tombstone,
    Expression<String>? tombstonedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (contentHashAtCreation != null)
        'content_hash_at_creation': contentHashAtCreation,
      if (sourceBlockId != null) 'source_block_id': sourceBlockId,
      if (pageId != null) 'page_id': pageId,
      if (lessonBlockId != null) 'lesson_block_id': lessonBlockId,
      if (quote != null) 'quote': quote,
      if (prefix != null) 'prefix': prefix,
      if (suffix != null) 'suffix': suffix,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (bboxX != null) 'bbox_x': bboxX,
      if (bboxY != null) 'bbox_y': bboxY,
      if (bboxW != null) 'bbox_w': bboxW,
      if (bboxH != null) 'bbox_h': bboxH,
      if (color != null) 'color': color,
      if (status != null) 'status': status,
      if (tombstone != null) 'tombstone': tombstone,
      if (tombstonedAt != null) 'tombstoned_at': tombstonedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HighlightAnchorsCompanion copyWith({
    Value<String>? id,
    Value<int>? version,
    Value<String>? contentHashAtCreation,
    Value<String>? sourceBlockId,
    Value<String>? pageId,
    Value<String?>? lessonBlockId,
    Value<String>? quote,
    Value<String>? prefix,
    Value<String>? suffix,
    Value<int>? startOffset,
    Value<int>? endOffset,
    Value<double?>? bboxX,
    Value<double?>? bboxY,
    Value<double?>? bboxW,
    Value<double?>? bboxH,
    Value<String>? color,
    Value<String>? status,
    Value<bool>? tombstone,
    Value<String?>? tombstonedAt,
    Value<int>? rowid,
  }) {
    return HighlightAnchorsCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      contentHashAtCreation:
          contentHashAtCreation ?? this.contentHashAtCreation,
      sourceBlockId: sourceBlockId ?? this.sourceBlockId,
      pageId: pageId ?? this.pageId,
      lessonBlockId: lessonBlockId ?? this.lessonBlockId,
      quote: quote ?? this.quote,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      bboxX: bboxX ?? this.bboxX,
      bboxY: bboxY ?? this.bboxY,
      bboxW: bboxW ?? this.bboxW,
      bboxH: bboxH ?? this.bboxH,
      color: color ?? this.color,
      status: status ?? this.status,
      tombstone: tombstone ?? this.tombstone,
      tombstonedAt: tombstonedAt ?? this.tombstonedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (contentHashAtCreation.present) {
      map['content_hash_at_creation'] = Variable<String>(
        contentHashAtCreation.value,
      );
    }
    if (sourceBlockId.present) {
      map['source_block_id'] = Variable<String>(sourceBlockId.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (lessonBlockId.present) {
      map['lesson_block_id'] = Variable<String>(lessonBlockId.value);
    }
    if (quote.present) {
      map['quote'] = Variable<String>(quote.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (suffix.present) {
      map['suffix'] = Variable<String>(suffix.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (bboxX.present) {
      map['bbox_x'] = Variable<double>(bboxX.value);
    }
    if (bboxY.present) {
      map['bbox_y'] = Variable<double>(bboxY.value);
    }
    if (bboxW.present) {
      map['bbox_w'] = Variable<double>(bboxW.value);
    }
    if (bboxH.present) {
      map['bbox_h'] = Variable<double>(bboxH.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tombstone.present) {
      map['tombstone'] = Variable<bool>(tombstone.value);
    }
    if (tombstonedAt.present) {
      map['tombstoned_at'] = Variable<String>(tombstonedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightAnchorsCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('contentHashAtCreation: $contentHashAtCreation, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('pageId: $pageId, ')
          ..write('lessonBlockId: $lessonBlockId, ')
          ..write('quote: $quote, ')
          ..write('prefix: $prefix, ')
          ..write('suffix: $suffix, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('bboxX: $bboxX, ')
          ..write('bboxY: $bboxY, ')
          ..write('bboxW: $bboxW, ')
          ..write('bboxH: $bboxH, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('tombstone: $tombstone, ')
          ..write('tombstonedAt: $tombstonedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyNotesTable extends StudyNotes
    with TableInfo<$StudyNotesTable, StudyNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorIdMeta = const VerificationMeta(
    'anchorId',
  );
  @override
  late final GeneratedColumn<String> anchorId = GeneratedColumn<String>(
    'anchor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceBlockIdMeta = const VerificationMeta(
    'sourceBlockId',
  );
  @override
  late final GeneratedColumn<String> sourceBlockId = GeneratedColumn<String>(
    'source_block_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _figureIdMeta = const VerificationMeta(
    'figureId',
  );
  @override
  late final GeneratedColumn<String> figureId = GeneratedColumn<String>(
    'figure_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lessonBlockIdMeta = const VerificationMeta(
    'lessonBlockId',
  );
  @override
  late final GeneratedColumn<String> lessonBlockId = GeneratedColumn<String>(
    'lesson_block_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pinned" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tombstoneMeta = const VerificationMeta(
    'tombstone',
  );
  @override
  late final GeneratedColumn<bool> tombstone = GeneratedColumn<bool>(
    'tombstone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tombstone" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tombstonedAtMeta = const VerificationMeta(
    'tombstonedAt',
  );
  @override
  late final GeneratedColumn<String> tombstonedAt = GeneratedColumn<String>(
    'tombstoned_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    contentHash,
    anchorId,
    sourceBlockId,
    figureId,
    lessonBlockId,
    body,
    pinned,
    createdAt,
    updatedAt,
    tombstone,
    tombstonedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('anchor_id')) {
      context.handle(
        _anchorIdMeta,
        anchorId.isAcceptableOrUnknown(data['anchor_id']!, _anchorIdMeta),
      );
    }
    if (data.containsKey('source_block_id')) {
      context.handle(
        _sourceBlockIdMeta,
        sourceBlockId.isAcceptableOrUnknown(
          data['source_block_id']!,
          _sourceBlockIdMeta,
        ),
      );
    }
    if (data.containsKey('figure_id')) {
      context.handle(
        _figureIdMeta,
        figureId.isAcceptableOrUnknown(data['figure_id']!, _figureIdMeta),
      );
    }
    if (data.containsKey('lesson_block_id')) {
      context.handle(
        _lessonBlockIdMeta,
        lessonBlockId.isAcceptableOrUnknown(
          data['lesson_block_id']!,
          _lessonBlockIdMeta,
        ),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('pinned')) {
      context.handle(
        _pinnedMeta,
        pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta),
      );
    } else if (isInserting) {
      context.missing(_pinnedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('tombstone')) {
      context.handle(
        _tombstoneMeta,
        tombstone.isAcceptableOrUnknown(data['tombstone']!, _tombstoneMeta),
      );
    }
    if (data.containsKey('tombstoned_at')) {
      context.handle(
        _tombstonedAtMeta,
        tombstonedAt.isAcceptableOrUnknown(
          data['tombstoned_at']!,
          _tombstonedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      anchorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_id'],
      ),
      sourceBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_block_id'],
      ),
      figureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}figure_id'],
      ),
      lessonBlockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_block_id'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      pinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pinned'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      tombstone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tombstone'],
      )!,
      tombstonedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tombstoned_at'],
      ),
    );
  }

  @override
  $StudyNotesTable createAlias(String alias) {
    return $StudyNotesTable(attachedDatabase, alias);
  }
}

class StudyNote extends DataClass implements Insertable<StudyNote> {
  final String id;
  final int version;
  final String contentHash;
  final String? anchorId;
  final String? sourceBlockId;
  final String? figureId;
  final String? lessonBlockId;
  final String body;
  final bool pinned;
  final String createdAt;
  final String updatedAt;
  final bool tombstone;
  final String? tombstonedAt;
  const StudyNote({
    required this.id,
    required this.version,
    required this.contentHash,
    this.anchorId,
    this.sourceBlockId,
    this.figureId,
    this.lessonBlockId,
    required this.body,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
    required this.tombstone,
    this.tombstonedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<int>(version);
    map['content_hash'] = Variable<String>(contentHash);
    if (!nullToAbsent || anchorId != null) {
      map['anchor_id'] = Variable<String>(anchorId);
    }
    if (!nullToAbsent || sourceBlockId != null) {
      map['source_block_id'] = Variable<String>(sourceBlockId);
    }
    if (!nullToAbsent || figureId != null) {
      map['figure_id'] = Variable<String>(figureId);
    }
    if (!nullToAbsent || lessonBlockId != null) {
      map['lesson_block_id'] = Variable<String>(lessonBlockId);
    }
    map['body'] = Variable<String>(body);
    map['pinned'] = Variable<bool>(pinned);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['tombstone'] = Variable<bool>(tombstone);
    if (!nullToAbsent || tombstonedAt != null) {
      map['tombstoned_at'] = Variable<String>(tombstonedAt);
    }
    return map;
  }

  StudyNotesCompanion toCompanion(bool nullToAbsent) {
    return StudyNotesCompanion(
      id: Value(id),
      version: Value(version),
      contentHash: Value(contentHash),
      anchorId: anchorId == null && nullToAbsent
          ? const Value.absent()
          : Value(anchorId),
      sourceBlockId: sourceBlockId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBlockId),
      figureId: figureId == null && nullToAbsent
          ? const Value.absent()
          : Value(figureId),
      lessonBlockId: lessonBlockId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonBlockId),
      body: Value(body),
      pinned: Value(pinned),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      tombstone: Value(tombstone),
      tombstonedAt: tombstonedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(tombstonedAt),
    );
  }

  factory StudyNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyNote(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      anchorId: serializer.fromJson<String?>(json['anchorId']),
      sourceBlockId: serializer.fromJson<String?>(json['sourceBlockId']),
      figureId: serializer.fromJson<String?>(json['figureId']),
      lessonBlockId: serializer.fromJson<String?>(json['lessonBlockId']),
      body: serializer.fromJson<String>(json['body']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      tombstone: serializer.fromJson<bool>(json['tombstone']),
      tombstonedAt: serializer.fromJson<String?>(json['tombstonedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<int>(version),
      'contentHash': serializer.toJson<String>(contentHash),
      'anchorId': serializer.toJson<String?>(anchorId),
      'sourceBlockId': serializer.toJson<String?>(sourceBlockId),
      'figureId': serializer.toJson<String?>(figureId),
      'lessonBlockId': serializer.toJson<String?>(lessonBlockId),
      'body': serializer.toJson<String>(body),
      'pinned': serializer.toJson<bool>(pinned),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'tombstone': serializer.toJson<bool>(tombstone),
      'tombstonedAt': serializer.toJson<String?>(tombstonedAt),
    };
  }

  StudyNote copyWith({
    String? id,
    int? version,
    String? contentHash,
    Value<String?> anchorId = const Value.absent(),
    Value<String?> sourceBlockId = const Value.absent(),
    Value<String?> figureId = const Value.absent(),
    Value<String?> lessonBlockId = const Value.absent(),
    String? body,
    bool? pinned,
    String? createdAt,
    String? updatedAt,
    bool? tombstone,
    Value<String?> tombstonedAt = const Value.absent(),
  }) => StudyNote(
    id: id ?? this.id,
    version: version ?? this.version,
    contentHash: contentHash ?? this.contentHash,
    anchorId: anchorId.present ? anchorId.value : this.anchorId,
    sourceBlockId: sourceBlockId.present
        ? sourceBlockId.value
        : this.sourceBlockId,
    figureId: figureId.present ? figureId.value : this.figureId,
    lessonBlockId: lessonBlockId.present
        ? lessonBlockId.value
        : this.lessonBlockId,
    body: body ?? this.body,
    pinned: pinned ?? this.pinned,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    tombstone: tombstone ?? this.tombstone,
    tombstonedAt: tombstonedAt.present ? tombstonedAt.value : this.tombstonedAt,
  );
  StudyNote copyWithCompanion(StudyNotesCompanion data) {
    return StudyNote(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      anchorId: data.anchorId.present ? data.anchorId.value : this.anchorId,
      sourceBlockId: data.sourceBlockId.present
          ? data.sourceBlockId.value
          : this.sourceBlockId,
      figureId: data.figureId.present ? data.figureId.value : this.figureId,
      lessonBlockId: data.lessonBlockId.present
          ? data.lessonBlockId.value
          : this.lessonBlockId,
      body: data.body.present ? data.body.value : this.body,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      tombstone: data.tombstone.present ? data.tombstone.value : this.tombstone,
      tombstonedAt: data.tombstonedAt.present
          ? data.tombstonedAt.value
          : this.tombstonedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyNote(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('anchorId: $anchorId, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('figureId: $figureId, ')
          ..write('lessonBlockId: $lessonBlockId, ')
          ..write('body: $body, ')
          ..write('pinned: $pinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('tombstone: $tombstone, ')
          ..write('tombstonedAt: $tombstonedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    version,
    contentHash,
    anchorId,
    sourceBlockId,
    figureId,
    lessonBlockId,
    body,
    pinned,
    createdAt,
    updatedAt,
    tombstone,
    tombstonedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyNote &&
          other.id == this.id &&
          other.version == this.version &&
          other.contentHash == this.contentHash &&
          other.anchorId == this.anchorId &&
          other.sourceBlockId == this.sourceBlockId &&
          other.figureId == this.figureId &&
          other.lessonBlockId == this.lessonBlockId &&
          other.body == this.body &&
          other.pinned == this.pinned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.tombstone == this.tombstone &&
          other.tombstonedAt == this.tombstonedAt);
}

class StudyNotesCompanion extends UpdateCompanion<StudyNote> {
  final Value<String> id;
  final Value<int> version;
  final Value<String> contentHash;
  final Value<String?> anchorId;
  final Value<String?> sourceBlockId;
  final Value<String?> figureId;
  final Value<String?> lessonBlockId;
  final Value<String> body;
  final Value<bool> pinned;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<bool> tombstone;
  final Value<String?> tombstonedAt;
  final Value<int> rowid;
  const StudyNotesCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.anchorId = const Value.absent(),
    this.sourceBlockId = const Value.absent(),
    this.figureId = const Value.absent(),
    this.lessonBlockId = const Value.absent(),
    this.body = const Value.absent(),
    this.pinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.tombstone = const Value.absent(),
    this.tombstonedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyNotesCompanion.insert({
    required String id,
    required int version,
    required String contentHash,
    this.anchorId = const Value.absent(),
    this.sourceBlockId = const Value.absent(),
    this.figureId = const Value.absent(),
    this.lessonBlockId = const Value.absent(),
    required String body,
    required bool pinned,
    required String createdAt,
    required String updatedAt,
    this.tombstone = const Value.absent(),
    this.tombstonedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       version = Value(version),
       contentHash = Value(contentHash),
       body = Value(body),
       pinned = Value(pinned),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudyNote> custom({
    Expression<String>? id,
    Expression<int>? version,
    Expression<String>? contentHash,
    Expression<String>? anchorId,
    Expression<String>? sourceBlockId,
    Expression<String>? figureId,
    Expression<String>? lessonBlockId,
    Expression<String>? body,
    Expression<bool>? pinned,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<bool>? tombstone,
    Expression<String>? tombstonedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (contentHash != null) 'content_hash': contentHash,
      if (anchorId != null) 'anchor_id': anchorId,
      if (sourceBlockId != null) 'source_block_id': sourceBlockId,
      if (figureId != null) 'figure_id': figureId,
      if (lessonBlockId != null) 'lesson_block_id': lessonBlockId,
      if (body != null) 'body': body,
      if (pinned != null) 'pinned': pinned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (tombstone != null) 'tombstone': tombstone,
      if (tombstonedAt != null) 'tombstoned_at': tombstonedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyNotesCompanion copyWith({
    Value<String>? id,
    Value<int>? version,
    Value<String>? contentHash,
    Value<String?>? anchorId,
    Value<String?>? sourceBlockId,
    Value<String?>? figureId,
    Value<String?>? lessonBlockId,
    Value<String>? body,
    Value<bool>? pinned,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<bool>? tombstone,
    Value<String?>? tombstonedAt,
    Value<int>? rowid,
  }) {
    return StudyNotesCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      contentHash: contentHash ?? this.contentHash,
      anchorId: anchorId ?? this.anchorId,
      sourceBlockId: sourceBlockId ?? this.sourceBlockId,
      figureId: figureId ?? this.figureId,
      lessonBlockId: lessonBlockId ?? this.lessonBlockId,
      body: body ?? this.body,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tombstone: tombstone ?? this.tombstone,
      tombstonedAt: tombstonedAt ?? this.tombstonedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (anchorId.present) {
      map['anchor_id'] = Variable<String>(anchorId.value);
    }
    if (sourceBlockId.present) {
      map['source_block_id'] = Variable<String>(sourceBlockId.value);
    }
    if (figureId.present) {
      map['figure_id'] = Variable<String>(figureId.value);
    }
    if (lessonBlockId.present) {
      map['lesson_block_id'] = Variable<String>(lessonBlockId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (tombstone.present) {
      map['tombstone'] = Variable<bool>(tombstone.value);
    }
    if (tombstonedAt.present) {
      map['tombstoned_at'] = Variable<String>(tombstonedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyNotesCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('contentHash: $contentHash, ')
          ..write('anchorId: $anchorId, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('figureId: $figureId, ')
          ..write('lessonBlockId: $lessonBlockId, ')
          ..write('body: $body, ')
          ..write('pinned: $pinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('tombstone: $tombstone, ')
          ..write('tombstonedAt: $tombstonedAt, ')
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
  late final $SourcePagesTable sourcePages = $SourcePagesTable(this);
  late final $SourceBlocksTable sourceBlocks = $SourceBlocksTable(this);
  late final $SourceCitationsTable sourceCitations = $SourceCitationsTable(
    this,
  );
  late final $FigureAssetsTable figureAssets = $FigureAssetsTable(this);
  late final $LessonArtifactsTable lessonArtifacts = $LessonArtifactsTable(
    this,
  );
  late final $LearnerStatesTable learnerStates = $LearnerStatesTable(this);
  late final $HighlightAnchorsTable highlightAnchors = $HighlightAnchorsTable(
    this,
  );
  late final $StudyNotesTable studyNotes = $StudyNotesTable(this);
  late final Index sourceVersionUnique = Index(
    'source_version_unique',
    'CREATE UNIQUE INDEX source_version_unique ON source_entries (library_id, name, version)',
  );
  late final Index sourcePageDocumentPageVersionProfileUnique = Index(
    'source_page_document_page_version_profile_unique',
    'CREATE UNIQUE INDEX source_page_document_page_version_profile_unique ON source_pages (document_id, page_number, version, render_profile)',
  );
  late final Index sourceBlockPageVersionOrderUnique = Index(
    'source_block_page_version_order_unique',
    'CREATE UNIQUE INDEX source_block_page_version_order_unique ON source_blocks (page_id, version, "order")',
  );
  late final Index lessonArtifactSliceVersionUnique = Index(
    'lesson_artifact_slice_version_unique',
    'CREATE UNIQUE INDEX lesson_artifact_slice_version_unique ON lesson_artifacts (slice_id, version)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    libraryEntries,
    sourceEntries,
    sourcePages,
    sourceBlocks,
    sourceCitations,
    figureAssets,
    lessonArtifacts,
    learnerStates,
    highlightAnchors,
    studyNotes,
    sourceVersionUnique,
    sourcePageDocumentPageVersionProfileUnique,
    sourceBlockPageVersionOrderUnique,
    lessonArtifactSliceVersionUnique,
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

  static MultiTypedResultKey<$SourcePagesTable, List<SourcePage>>
  _sourcePagesRefsTable(_$TraceDatabase db) => MultiTypedResultKey.fromTable(
    db.sourcePages,
    aliasName: 'source_entries__id__source_pages__document_id',
  );

  $$SourcePagesTableProcessedTableManager get sourcePagesRefs {
    final manager = $$SourcePagesTableTableManager(
      $_db,
      $_db.sourcePages,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourcePagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceBlocksTable, List<SourceBlock>>
  _sourceBlocksRefsTable(_$TraceDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceBlocks,
    aliasName: 'source_entries__id__source_blocks__document_id',
  );

  $$SourceBlocksTableProcessedTableManager get sourceBlocksRefs {
    final manager = $$SourceBlocksTableTableManager(
      $_db,
      $_db.sourceBlocks,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  Expression<bool> sourcePagesRefs(
    Expression<bool> Function($$SourcePagesTableFilterComposer f) f,
  ) {
    final $$SourcePagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableFilterComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceBlocksRefs(
    Expression<bool> Function($$SourceBlocksTableFilterComposer f) f,
  ) {
    final $$SourceBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableFilterComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  Expression<T> sourcePagesRefs<T extends Object>(
    Expression<T> Function($$SourcePagesTableAnnotationComposer a) f,
  ) {
    final $$SourcePagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceBlocksRefs<T extends Object>(
    Expression<T> Function($$SourceBlocksTableAnnotationComposer a) f,
  ) {
    final $$SourceBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({
            bool libraryId,
            bool sourcePagesRefs,
            bool sourceBlocksRefs,
          })
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
          prefetchHooksCallback:
              ({
                libraryId = false,
                sourcePagesRefs = false,
                sourceBlocksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourcePagesRefs) db.sourcePages,
                    if (sourceBlocksRefs) db.sourceBlocks,
                  ],
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
                                    referencedTable:
                                        $$SourceEntriesTableReferences
                                            ._libraryIdTable(db),
                                    referencedColumn:
                                        $$SourceEntriesTableReferences
                                            ._libraryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourcePagesRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourceEntriesTable,
                          SourcePage
                        >(
                          currentTable: table,
                          referencedTable: $$SourceEntriesTableReferences
                              ._sourcePagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourcePagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.documentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceBlocksRefs)
                        await $_getPrefetchedData<
                          SourceEntry,
                          $SourceEntriesTable,
                          SourceBlock
                        >(
                          currentTable: table,
                          referencedTable: $$SourceEntriesTableReferences
                              ._sourceBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.documentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
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
      PrefetchHooks Function({
        bool libraryId,
        bool sourcePagesRefs,
        bool sourceBlocksRefs,
      })
    >;
typedef $$SourcePagesTableCreateCompanionBuilder =
    SourcePagesCompanion Function({
      required String id,
      required String documentId,
      Value<int> version,
      required int pageNumber,
      required String pixelHash,
      required String renderProfile,
      required String thumbnailPath,
      required String visionStatus,
      Value<int> rowid,
    });
typedef $$SourcePagesTableUpdateCompanionBuilder =
    SourcePagesCompanion Function({
      Value<String> id,
      Value<String> documentId,
      Value<int> version,
      Value<int> pageNumber,
      Value<String> pixelHash,
      Value<String> renderProfile,
      Value<String> thumbnailPath,
      Value<String> visionStatus,
      Value<int> rowid,
    });

final class $$SourcePagesTableReferences
    extends BaseReferences<_$TraceDatabase, $SourcePagesTable, SourcePage> {
  $$SourcePagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourceEntriesTable _documentIdTable(_$TraceDatabase db) => db
      .sourceEntries
      .createAlias('source_pages__document_id__source_entries__id');

  $$SourceEntriesTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$SourceEntriesTableTableManager(
      $_db,
      $_db.sourceEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SourceBlocksTable, List<SourceBlock>>
  _sourceBlocksRefsTable(_$TraceDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceBlocks,
    aliasName: 'source_pages__id__source_blocks__page_id',
  );

  $$SourceBlocksTableProcessedTableManager get sourceBlocksRefs {
    final manager = $$SourceBlocksTableTableManager(
      $_db,
      $_db.sourceBlocks,
    ).filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceCitationsTable, List<SourceCitation>>
  _sourceCitationsRefsTable(_$TraceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sourceCitations,
        aliasName: 'source_pages__id__source_citations__page_id',
      );

  $$SourceCitationsTableProcessedTableManager get sourceCitationsRefs {
    final manager = $$SourceCitationsTableTableManager(
      $_db,
      $_db.sourceCitations,
    ).filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceCitationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FigureAssetsTable, List<FigureAsset>>
  _figureAssetsRefsTable(_$TraceDatabase db) => MultiTypedResultKey.fromTable(
    db.figureAssets,
    aliasName: 'source_pages__id__figure_assets__page_id',
  );

  $$FigureAssetsTableProcessedTableManager get figureAssetsRefs {
    final manager = $$FigureAssetsTableTableManager(
      $_db,
      $_db.figureAssets,
    ).filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_figureAssetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourcePagesTableFilterComposer
    extends Composer<_$TraceDatabase, $SourcePagesTable> {
  $$SourcePagesTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pixelHash => $composableBuilder(
    column: $table.pixelHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get renderProfile => $composableBuilder(
    column: $table.renderProfile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visionStatus => $composableBuilder(
    column: $table.visionStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$SourceEntriesTableFilterComposer get documentId {
    final $$SourceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  Expression<bool> sourceBlocksRefs(
    Expression<bool> Function($$SourceBlocksTableFilterComposer f) f,
  ) {
    final $$SourceBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableFilterComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceCitationsRefs(
    Expression<bool> Function($$SourceCitationsTableFilterComposer f) f,
  ) {
    final $$SourceCitationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceCitations,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceCitationsTableFilterComposer(
            $db: $db,
            $table: $db.sourceCitations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> figureAssetsRefs(
    Expression<bool> Function($$FigureAssetsTableFilterComposer f) f,
  ) {
    final $$FigureAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.figureAssets,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FigureAssetsTableFilterComposer(
            $db: $db,
            $table: $db.figureAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcePagesTableOrderingComposer
    extends Composer<_$TraceDatabase, $SourcePagesTable> {
  $$SourcePagesTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pixelHash => $composableBuilder(
    column: $table.pixelHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get renderProfile => $composableBuilder(
    column: $table.renderProfile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visionStatus => $composableBuilder(
    column: $table.visionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourceEntriesTableOrderingComposer get documentId {
    final $$SourceEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.sourceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourcePagesTableAnnotationComposer
    extends Composer<_$TraceDatabase, $SourcePagesTable> {
  $$SourcePagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pixelHash =>
      $composableBuilder(column: $table.pixelHash, builder: (column) => column);

  GeneratedColumn<String> get renderProfile => $composableBuilder(
    column: $table.renderProfile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visionStatus => $composableBuilder(
    column: $table.visionStatus,
    builder: (column) => column,
  );

  $$SourceEntriesTableAnnotationComposer get documentId {
    final $$SourceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  Expression<T> sourceBlocksRefs<T extends Object>(
    Expression<T> Function($$SourceBlocksTableAnnotationComposer a) f,
  ) {
    final $$SourceBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceCitationsRefs<T extends Object>(
    Expression<T> Function($$SourceCitationsTableAnnotationComposer a) f,
  ) {
    final $$SourceCitationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceCitations,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceCitationsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceCitations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> figureAssetsRefs<T extends Object>(
    Expression<T> Function($$FigureAssetsTableAnnotationComposer a) f,
  ) {
    final $$FigureAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.figureAssets,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FigureAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.figureAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourcePagesTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $SourcePagesTable,
          SourcePage,
          $$SourcePagesTableFilterComposer,
          $$SourcePagesTableOrderingComposer,
          $$SourcePagesTableAnnotationComposer,
          $$SourcePagesTableCreateCompanionBuilder,
          $$SourcePagesTableUpdateCompanionBuilder,
          (SourcePage, $$SourcePagesTableReferences),
          SourcePage,
          PrefetchHooks Function({
            bool documentId,
            bool sourceBlocksRefs,
            bool sourceCitationsRefs,
            bool figureAssetsRefs,
          })
        > {
  $$SourcePagesTableTableManager(_$TraceDatabase db, $SourcePagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcePagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcePagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcePagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<String> pixelHash = const Value.absent(),
                Value<String> renderProfile = const Value.absent(),
                Value<String> thumbnailPath = const Value.absent(),
                Value<String> visionStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourcePagesCompanion(
                id: id,
                documentId: documentId,
                version: version,
                pageNumber: pageNumber,
                pixelHash: pixelHash,
                renderProfile: renderProfile,
                thumbnailPath: thumbnailPath,
                visionStatus: visionStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentId,
                Value<int> version = const Value.absent(),
                required int pageNumber,
                required String pixelHash,
                required String renderProfile,
                required String thumbnailPath,
                required String visionStatus,
                Value<int> rowid = const Value.absent(),
              }) => SourcePagesCompanion.insert(
                id: id,
                documentId: documentId,
                version: version,
                pageNumber: pageNumber,
                pixelHash: pixelHash,
                renderProfile: renderProfile,
                thumbnailPath: thumbnailPath,
                visionStatus: visionStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourcePagesTable, SourcePage>(table),
                  $$SourcePagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                documentId = false,
                sourceBlocksRefs = false,
                sourceCitationsRefs = false,
                figureAssetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceBlocksRefs) db.sourceBlocks,
                    if (sourceCitationsRefs) db.sourceCitations,
                    if (figureAssetsRefs) db.figureAssets,
                  ],
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
                        if (documentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.documentId,
                                    referencedTable:
                                        $$SourcePagesTableReferences
                                            ._documentIdTable(db),
                                    referencedColumn:
                                        $$SourcePagesTableReferences
                                            ._documentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceBlocksRefs)
                        await $_getPrefetchedData<
                          SourcePage,
                          $SourcePagesTable,
                          SourceBlock
                        >(
                          currentTable: table,
                          referencedTable: $$SourcePagesTableReferences
                              ._sourceBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcePagesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pageId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceCitationsRefs)
                        await $_getPrefetchedData<
                          SourcePage,
                          $SourcePagesTable,
                          SourceCitation
                        >(
                          currentTable: table,
                          referencedTable: $$SourcePagesTableReferences
                              ._sourceCitationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcePagesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceCitationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pageId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (figureAssetsRefs)
                        await $_getPrefetchedData<
                          SourcePage,
                          $SourcePagesTable,
                          FigureAsset
                        >(
                          currentTable: table,
                          referencedTable: $$SourcePagesTableReferences
                              ._figureAssetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourcePagesTableReferences(
                                db,
                                table,
                                p0,
                              ).figureAssetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SourcePagesTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $SourcePagesTable,
      SourcePage,
      $$SourcePagesTableFilterComposer,
      $$SourcePagesTableOrderingComposer,
      $$SourcePagesTableAnnotationComposer,
      $$SourcePagesTableCreateCompanionBuilder,
      $$SourcePagesTableUpdateCompanionBuilder,
      (SourcePage, $$SourcePagesTableReferences),
      SourcePage,
      PrefetchHooks Function({
        bool documentId,
        bool sourceBlocksRefs,
        bool sourceCitationsRefs,
        bool figureAssetsRefs,
      })
    >;
typedef $$SourceBlocksTableCreateCompanionBuilder =
    SourceBlocksCompanion Function({
      required String id,
      required String documentId,
      required String pageId,
      Value<int> version,
      required String sourceHash,
      required int order,
      required String kind,
      required String rawText,
      required String normalizedText,
      Value<double?> bboxX,
      Value<double?> bboxY,
      Value<double?> bboxWidth,
      Value<double?> bboxHeight,
      Value<int> rowid,
    });
typedef $$SourceBlocksTableUpdateCompanionBuilder =
    SourceBlocksCompanion Function({
      Value<String> id,
      Value<String> documentId,
      Value<String> pageId,
      Value<int> version,
      Value<String> sourceHash,
      Value<int> order,
      Value<String> kind,
      Value<String> rawText,
      Value<String> normalizedText,
      Value<double?> bboxX,
      Value<double?> bboxY,
      Value<double?> bboxWidth,
      Value<double?> bboxHeight,
      Value<int> rowid,
    });

final class $$SourceBlocksTableReferences
    extends BaseReferences<_$TraceDatabase, $SourceBlocksTable, SourceBlock> {
  $$SourceBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourceEntriesTable _documentIdTable(_$TraceDatabase db) => db
      .sourceEntries
      .createAlias('source_blocks__document_id__source_entries__id');

  $$SourceEntriesTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$SourceEntriesTableTableManager(
      $_db,
      $_db.sourceEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SourcePagesTable _pageIdTable(_$TraceDatabase db) =>
      db.sourcePages.createAlias('source_blocks__page_id__source_pages__id');

  $$SourcePagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$SourcePagesTableTableManager(
      $_db,
      $_db.sourcePages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SourceCitationsTable, List<SourceCitation>>
  _sourceCitationsRefsTable(_$TraceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sourceCitations,
        aliasName: 'source_blocks__id__source_citations__source_block_id',
      );

  $$SourceCitationsTableProcessedTableManager get sourceCitationsRefs {
    final manager = $$SourceCitationsTableTableManager(
      $_db,
      $_db.sourceCitations,
    ).filter((f) => f.sourceBlockId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sourceCitationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourceBlocksTableFilterComposer
    extends Composer<_$TraceDatabase, $SourceBlocksTable> {
  $$SourceBlocksTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedText => $composableBuilder(
    column: $table.normalizedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxX => $composableBuilder(
    column: $table.bboxX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxY => $composableBuilder(
    column: $table.bboxY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxWidth => $composableBuilder(
    column: $table.bboxWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxHeight => $composableBuilder(
    column: $table.bboxHeight,
    builder: (column) => ColumnFilters(column),
  );

  $$SourceEntriesTableFilterComposer get documentId {
    final $$SourceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$SourcePagesTableFilterComposer get pageId {
    final $$SourcePagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableFilterComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sourceCitationsRefs(
    Expression<bool> Function($$SourceCitationsTableFilterComposer f) f,
  ) {
    final $$SourceCitationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceCitations,
      getReferencedColumn: (t) => t.sourceBlockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceCitationsTableFilterComposer(
            $db: $db,
            $table: $db.sourceCitations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceBlocksTableOrderingComposer
    extends Composer<_$TraceDatabase, $SourceBlocksTable> {
  $$SourceBlocksTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedText => $composableBuilder(
    column: $table.normalizedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxX => $composableBuilder(
    column: $table.bboxX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxY => $composableBuilder(
    column: $table.bboxY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxWidth => $composableBuilder(
    column: $table.bboxWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxHeight => $composableBuilder(
    column: $table.bboxHeight,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourceEntriesTableOrderingComposer get documentId {
    final $$SourceEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.sourceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourcePagesTableOrderingComposer get pageId {
    final $$SourcePagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableOrderingComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceBlocksTableAnnotationComposer
    extends Composer<_$TraceDatabase, $SourceBlocksTable> {
  $$SourceBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<String> get normalizedText => $composableBuilder(
    column: $table.normalizedText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bboxX =>
      $composableBuilder(column: $table.bboxX, builder: (column) => column);

  GeneratedColumn<double> get bboxY =>
      $composableBuilder(column: $table.bboxY, builder: (column) => column);

  GeneratedColumn<double> get bboxWidth =>
      $composableBuilder(column: $table.bboxWidth, builder: (column) => column);

  GeneratedColumn<double> get bboxHeight => $composableBuilder(
    column: $table.bboxHeight,
    builder: (column) => column,
  );

  $$SourceEntriesTableAnnotationComposer get documentId {
    final $$SourceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.sourceEntries,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$SourcePagesTableAnnotationComposer get pageId {
    final $$SourcePagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sourceCitationsRefs<T extends Object>(
    Expression<T> Function($$SourceCitationsTableAnnotationComposer a) f,
  ) {
    final $$SourceCitationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceCitations,
      getReferencedColumn: (t) => t.sourceBlockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceCitationsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceCitations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceBlocksTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $SourceBlocksTable,
          SourceBlock,
          $$SourceBlocksTableFilterComposer,
          $$SourceBlocksTableOrderingComposer,
          $$SourceBlocksTableAnnotationComposer,
          $$SourceBlocksTableCreateCompanionBuilder,
          $$SourceBlocksTableUpdateCompanionBuilder,
          (SourceBlock, $$SourceBlocksTableReferences),
          SourceBlock,
          PrefetchHooks Function({
            bool documentId,
            bool pageId,
            bool sourceCitationsRefs,
          })
        > {
  $$SourceBlocksTableTableManager(_$TraceDatabase db, $SourceBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<String> pageId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<String> normalizedText = const Value.absent(),
                Value<double?> bboxX = const Value.absent(),
                Value<double?> bboxY = const Value.absent(),
                Value<double?> bboxWidth = const Value.absent(),
                Value<double?> bboxHeight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceBlocksCompanion(
                id: id,
                documentId: documentId,
                pageId: pageId,
                version: version,
                sourceHash: sourceHash,
                order: order,
                kind: kind,
                rawText: rawText,
                normalizedText: normalizedText,
                bboxX: bboxX,
                bboxY: bboxY,
                bboxWidth: bboxWidth,
                bboxHeight: bboxHeight,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentId,
                required String pageId,
                Value<int> version = const Value.absent(),
                required String sourceHash,
                required int order,
                required String kind,
                required String rawText,
                required String normalizedText,
                Value<double?> bboxX = const Value.absent(),
                Value<double?> bboxY = const Value.absent(),
                Value<double?> bboxWidth = const Value.absent(),
                Value<double?> bboxHeight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceBlocksCompanion.insert(
                id: id,
                documentId: documentId,
                pageId: pageId,
                version: version,
                sourceHash: sourceHash,
                order: order,
                kind: kind,
                rawText: rawText,
                normalizedText: normalizedText,
                bboxX: bboxX,
                bboxY: bboxY,
                bboxWidth: bboxWidth,
                bboxHeight: bboxHeight,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceBlocksTable, SourceBlock>(table),
                  $$SourceBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                documentId = false,
                pageId = false,
                sourceCitationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceCitationsRefs) db.sourceCitations,
                  ],
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
                        if (documentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.documentId,
                                    referencedTable:
                                        $$SourceBlocksTableReferences
                                            ._documentIdTable(db),
                                    referencedColumn:
                                        $$SourceBlocksTableReferences
                                            ._documentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (pageId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pageId,
                                    referencedTable:
                                        $$SourceBlocksTableReferences
                                            ._pageIdTable(db),
                                    referencedColumn:
                                        $$SourceBlocksTableReferences
                                            ._pageIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceCitationsRefs)
                        await $_getPrefetchedData<
                          SourceBlock,
                          $SourceBlocksTable,
                          SourceCitation
                        >(
                          currentTable: table,
                          referencedTable: $$SourceBlocksTableReferences
                              ._sourceCitationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceBlocksTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceCitationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceBlockId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SourceBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $SourceBlocksTable,
      SourceBlock,
      $$SourceBlocksTableFilterComposer,
      $$SourceBlocksTableOrderingComposer,
      $$SourceBlocksTableAnnotationComposer,
      $$SourceBlocksTableCreateCompanionBuilder,
      $$SourceBlocksTableUpdateCompanionBuilder,
      (SourceBlock, $$SourceBlocksTableReferences),
      SourceBlock,
      PrefetchHooks Function({
        bool documentId,
        bool pageId,
        bool sourceCitationsRefs,
      })
    >;
typedef $$SourceCitationsTableCreateCompanionBuilder =
    SourceCitationsCompanion Function({
      required String id,
      Value<int> version,
      required String contentHash,
      required String sourceBlockId,
      required String pageId,
      Value<String?> figureId,
      required String quote,
      required String locator,
      required double confidence,
      required String extractionVersion,
      Value<int> rowid,
    });
typedef $$SourceCitationsTableUpdateCompanionBuilder =
    SourceCitationsCompanion Function({
      Value<String> id,
      Value<int> version,
      Value<String> contentHash,
      Value<String> sourceBlockId,
      Value<String> pageId,
      Value<String?> figureId,
      Value<String> quote,
      Value<String> locator,
      Value<double> confidence,
      Value<String> extractionVersion,
      Value<int> rowid,
    });

final class $$SourceCitationsTableReferences
    extends
        BaseReferences<_$TraceDatabase, $SourceCitationsTable, SourceCitation> {
  $$SourceCitationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourceBlocksTable _sourceBlockIdTable(_$TraceDatabase db) => db
      .sourceBlocks
      .createAlias('source_citations__source_block_id__source_blocks__id');

  $$SourceBlocksTableProcessedTableManager get sourceBlockId {
    final $_column = $_itemColumn<String>('source_block_id')!;

    final manager = $$SourceBlocksTableTableManager(
      $_db,
      $_db.sourceBlocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceBlockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SourcePagesTable _pageIdTable(_$TraceDatabase db) =>
      db.sourcePages.createAlias('source_citations__page_id__source_pages__id');

  $$SourcePagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$SourcePagesTableTableManager(
      $_db,
      $_db.sourcePages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceCitationsTableFilterComposer
    extends Composer<_$TraceDatabase, $SourceCitationsTable> {
  $$SourceCitationsTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get figureId => $composableBuilder(
    column: $table.figureId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionVersion => $composableBuilder(
    column: $table.extractionVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$SourceBlocksTableFilterComposer get sourceBlockId {
    final $$SourceBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBlockId,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableFilterComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourcePagesTableFilterComposer get pageId {
    final $$SourcePagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableFilterComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceCitationsTableOrderingComposer
    extends Composer<_$TraceDatabase, $SourceCitationsTable> {
  $$SourceCitationsTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get figureId => $composableBuilder(
    column: $table.figureId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionVersion => $composableBuilder(
    column: $table.extractionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourceBlocksTableOrderingComposer get sourceBlockId {
    final $$SourceBlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBlockId,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableOrderingComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourcePagesTableOrderingComposer get pageId {
    final $$SourcePagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableOrderingComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceCitationsTableAnnotationComposer
    extends Composer<_$TraceDatabase, $SourceCitationsTable> {
  $$SourceCitationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get figureId =>
      $composableBuilder(column: $table.figureId, builder: (column) => column);

  GeneratedColumn<String> get quote =>
      $composableBuilder(column: $table.quote, builder: (column) => column);

  GeneratedColumn<String> get locator =>
      $composableBuilder(column: $table.locator, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionVersion => $composableBuilder(
    column: $table.extractionVersion,
    builder: (column) => column,
  );

  $$SourceBlocksTableAnnotationComposer get sourceBlockId {
    final $$SourceBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBlockId,
      referencedTable: $db.sourceBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourcePagesTableAnnotationComposer get pageId {
    final $$SourcePagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceCitationsTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $SourceCitationsTable,
          SourceCitation,
          $$SourceCitationsTableFilterComposer,
          $$SourceCitationsTableOrderingComposer,
          $$SourceCitationsTableAnnotationComposer,
          $$SourceCitationsTableCreateCompanionBuilder,
          $$SourceCitationsTableUpdateCompanionBuilder,
          (SourceCitation, $$SourceCitationsTableReferences),
          SourceCitation,
          PrefetchHooks Function({bool sourceBlockId, bool pageId})
        > {
  $$SourceCitationsTableTableManager(
    _$TraceDatabase db,
    $SourceCitationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceCitationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceCitationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceCitationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> sourceBlockId = const Value.absent(),
                Value<String> pageId = const Value.absent(),
                Value<String?> figureId = const Value.absent(),
                Value<String> quote = const Value.absent(),
                Value<String> locator = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String> extractionVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceCitationsCompanion(
                id: id,
                version: version,
                contentHash: contentHash,
                sourceBlockId: sourceBlockId,
                pageId: pageId,
                figureId: figureId,
                quote: quote,
                locator: locator,
                confidence: confidence,
                extractionVersion: extractionVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> version = const Value.absent(),
                required String contentHash,
                required String sourceBlockId,
                required String pageId,
                Value<String?> figureId = const Value.absent(),
                required String quote,
                required String locator,
                required double confidence,
                required String extractionVersion,
                Value<int> rowid = const Value.absent(),
              }) => SourceCitationsCompanion.insert(
                id: id,
                version: version,
                contentHash: contentHash,
                sourceBlockId: sourceBlockId,
                pageId: pageId,
                figureId: figureId,
                quote: quote,
                locator: locator,
                confidence: confidence,
                extractionVersion: extractionVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceCitationsTable, SourceCitation>(table),
                  $$SourceCitationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceBlockId = false, pageId = false}) {
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
                    if (sourceBlockId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceBlockId,
                                referencedTable:
                                    $$SourceCitationsTableReferences
                                        ._sourceBlockIdTable(db),
                                referencedColumn:
                                    $$SourceCitationsTableReferences
                                        ._sourceBlockIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (pageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pageId,
                                referencedTable:
                                    $$SourceCitationsTableReferences
                                        ._pageIdTable(db),
                                referencedColumn:
                                    $$SourceCitationsTableReferences
                                        ._pageIdTable(db)
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

typedef $$SourceCitationsTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $SourceCitationsTable,
      SourceCitation,
      $$SourceCitationsTableFilterComposer,
      $$SourceCitationsTableOrderingComposer,
      $$SourceCitationsTableAnnotationComposer,
      $$SourceCitationsTableCreateCompanionBuilder,
      $$SourceCitationsTableUpdateCompanionBuilder,
      (SourceCitation, $$SourceCitationsTableReferences),
      SourceCitation,
      PrefetchHooks Function({bool sourceBlockId, bool pageId})
    >;
typedef $$FigureAssetsTableCreateCompanionBuilder =
    FigureAssetsCompanion Function({
      required String id,
      required int version,
      required String assetHash,
      required String sourceHash,
      required String pagePixelHash,
      required String pageId,
      required double bboxX,
      required double bboxY,
      required double bboxWidth,
      required double bboxHeight,
      required int widthPx,
      required int heightPx,
      required String caption,
      required String altText,
      required String reviewStatus,
      required Uint8List cropBytes,
      Value<int> rowid,
    });
typedef $$FigureAssetsTableUpdateCompanionBuilder =
    FigureAssetsCompanion Function({
      Value<String> id,
      Value<int> version,
      Value<String> assetHash,
      Value<String> sourceHash,
      Value<String> pagePixelHash,
      Value<String> pageId,
      Value<double> bboxX,
      Value<double> bboxY,
      Value<double> bboxWidth,
      Value<double> bboxHeight,
      Value<int> widthPx,
      Value<int> heightPx,
      Value<String> caption,
      Value<String> altText,
      Value<String> reviewStatus,
      Value<Uint8List> cropBytes,
      Value<int> rowid,
    });

final class $$FigureAssetsTableReferences
    extends BaseReferences<_$TraceDatabase, $FigureAssetsTable, FigureAsset> {
  $$FigureAssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SourcePagesTable _pageIdTable(_$TraceDatabase db) =>
      db.sourcePages.createAlias('figure_assets__page_id__source_pages__id');

  $$SourcePagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$SourcePagesTableTableManager(
      $_db,
      $_db.sourcePages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FigureAssetsTableFilterComposer
    extends Composer<_$TraceDatabase, $FigureAssetsTable> {
  $$FigureAssetsTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetHash => $composableBuilder(
    column: $table.assetHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pagePixelHash => $composableBuilder(
    column: $table.pagePixelHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxX => $composableBuilder(
    column: $table.bboxX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxY => $composableBuilder(
    column: $table.bboxY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxWidth => $composableBuilder(
    column: $table.bboxWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxHeight => $composableBuilder(
    column: $table.bboxHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get widthPx => $composableBuilder(
    column: $table.widthPx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightPx => $composableBuilder(
    column: $table.heightPx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get altText => $composableBuilder(
    column: $table.altText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get cropBytes => $composableBuilder(
    column: $table.cropBytes,
    builder: (column) => ColumnFilters(column),
  );

  $$SourcePagesTableFilterComposer get pageId {
    final $$SourcePagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableFilterComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FigureAssetsTableOrderingComposer
    extends Composer<_$TraceDatabase, $FigureAssetsTable> {
  $$FigureAssetsTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetHash => $composableBuilder(
    column: $table.assetHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pagePixelHash => $composableBuilder(
    column: $table.pagePixelHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxX => $composableBuilder(
    column: $table.bboxX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxY => $composableBuilder(
    column: $table.bboxY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxWidth => $composableBuilder(
    column: $table.bboxWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxHeight => $composableBuilder(
    column: $table.bboxHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widthPx => $composableBuilder(
    column: $table.widthPx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightPx => $composableBuilder(
    column: $table.heightPx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get altText => $composableBuilder(
    column: $table.altText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get cropBytes => $composableBuilder(
    column: $table.cropBytes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourcePagesTableOrderingComposer get pageId {
    final $$SourcePagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableOrderingComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FigureAssetsTableAnnotationComposer
    extends Composer<_$TraceDatabase, $FigureAssetsTable> {
  $$FigureAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get assetHash =>
      $composableBuilder(column: $table.assetHash, builder: (column) => column);

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pagePixelHash => $composableBuilder(
    column: $table.pagePixelHash,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bboxX =>
      $composableBuilder(column: $table.bboxX, builder: (column) => column);

  GeneratedColumn<double> get bboxY =>
      $composableBuilder(column: $table.bboxY, builder: (column) => column);

  GeneratedColumn<double> get bboxWidth =>
      $composableBuilder(column: $table.bboxWidth, builder: (column) => column);

  GeneratedColumn<double> get bboxHeight => $composableBuilder(
    column: $table.bboxHeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get widthPx =>
      $composableBuilder(column: $table.widthPx, builder: (column) => column);

  GeneratedColumn<int> get heightPx =>
      $composableBuilder(column: $table.heightPx, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<String> get altText =>
      $composableBuilder(column: $table.altText, builder: (column) => column);

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get cropBytes =>
      $composableBuilder(column: $table.cropBytes, builder: (column) => column);

  $$SourcePagesTableAnnotationComposer get pageId {
    final $$SourcePagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.sourcePages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourcePagesTableAnnotationComposer(
            $db: $db,
            $table: $db.sourcePages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FigureAssetsTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $FigureAssetsTable,
          FigureAsset,
          $$FigureAssetsTableFilterComposer,
          $$FigureAssetsTableOrderingComposer,
          $$FigureAssetsTableAnnotationComposer,
          $$FigureAssetsTableCreateCompanionBuilder,
          $$FigureAssetsTableUpdateCompanionBuilder,
          (FigureAsset, $$FigureAssetsTableReferences),
          FigureAsset,
          PrefetchHooks Function({bool pageId})
        > {
  $$FigureAssetsTableTableManager(_$TraceDatabase db, $FigureAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FigureAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FigureAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FigureAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> assetHash = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<String> pagePixelHash = const Value.absent(),
                Value<String> pageId = const Value.absent(),
                Value<double> bboxX = const Value.absent(),
                Value<double> bboxY = const Value.absent(),
                Value<double> bboxWidth = const Value.absent(),
                Value<double> bboxHeight = const Value.absent(),
                Value<int> widthPx = const Value.absent(),
                Value<int> heightPx = const Value.absent(),
                Value<String> caption = const Value.absent(),
                Value<String> altText = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<Uint8List> cropBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FigureAssetsCompanion(
                id: id,
                version: version,
                assetHash: assetHash,
                sourceHash: sourceHash,
                pagePixelHash: pagePixelHash,
                pageId: pageId,
                bboxX: bboxX,
                bboxY: bboxY,
                bboxWidth: bboxWidth,
                bboxHeight: bboxHeight,
                widthPx: widthPx,
                heightPx: heightPx,
                caption: caption,
                altText: altText,
                reviewStatus: reviewStatus,
                cropBytes: cropBytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int version,
                required String assetHash,
                required String sourceHash,
                required String pagePixelHash,
                required String pageId,
                required double bboxX,
                required double bboxY,
                required double bboxWidth,
                required double bboxHeight,
                required int widthPx,
                required int heightPx,
                required String caption,
                required String altText,
                required String reviewStatus,
                required Uint8List cropBytes,
                Value<int> rowid = const Value.absent(),
              }) => FigureAssetsCompanion.insert(
                id: id,
                version: version,
                assetHash: assetHash,
                sourceHash: sourceHash,
                pagePixelHash: pagePixelHash,
                pageId: pageId,
                bboxX: bboxX,
                bboxY: bboxY,
                bboxWidth: bboxWidth,
                bboxHeight: bboxHeight,
                widthPx: widthPx,
                heightPx: heightPx,
                caption: caption,
                altText: altText,
                reviewStatus: reviewStatus,
                cropBytes: cropBytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FigureAssetsTable, FigureAsset>(table),
                  $$FigureAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pageId = false}) {
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
                    if (pageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pageId,
                                referencedTable: $$FigureAssetsTableReferences
                                    ._pageIdTable(db),
                                referencedColumn: $$FigureAssetsTableReferences
                                    ._pageIdTable(db)
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

typedef $$FigureAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $FigureAssetsTable,
      FigureAsset,
      $$FigureAssetsTableFilterComposer,
      $$FigureAssetsTableOrderingComposer,
      $$FigureAssetsTableAnnotationComposer,
      $$FigureAssetsTableCreateCompanionBuilder,
      $$FigureAssetsTableUpdateCompanionBuilder,
      (FigureAsset, $$FigureAssetsTableReferences),
      FigureAsset,
      PrefetchHooks Function({bool pageId})
    >;
typedef $$LessonArtifactsTableCreateCompanionBuilder =
    LessonArtifactsCompanion Function({
      required String id,
      required String sliceId,
      required int version,
      required String contentHash,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$LessonArtifactsTableUpdateCompanionBuilder =
    LessonArtifactsCompanion Function({
      Value<String> id,
      Value<String> sliceId,
      Value<int> version,
      Value<String> contentHash,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$LessonArtifactsTableReferences
    extends
        BaseReferences<_$TraceDatabase, $LessonArtifactsTable, LessonArtifact> {
  $$LessonArtifactsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LearnerStatesTable, List<LearnerState>>
  _learnerStatesRefsTable(_$TraceDatabase db) => MultiTypedResultKey.fromTable(
    db.learnerStates,
    aliasName: 'lesson_artifacts__id__learner_states__lesson_artifact_id',
  );

  $$LearnerStatesTableProcessedTableManager get learnerStatesRefs {
    final manager = $$LearnerStatesTableTableManager($_db, $_db.learnerStates)
        .filter(
          (f) => f.lessonArtifactId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_learnerStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonArtifactsTableFilterComposer
    extends Composer<_$TraceDatabase, $LessonArtifactsTable> {
  $$LessonArtifactsTableFilterComposer({
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

  ColumnFilters<String> get sliceId => $composableBuilder(
    column: $table.sliceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> learnerStatesRefs(
    Expression<bool> Function($$LearnerStatesTableFilterComposer f) f,
  ) {
    final $$LearnerStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learnerStates,
      getReferencedColumn: (t) => t.lessonArtifactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearnerStatesTableFilterComposer(
            $db: $db,
            $table: $db.learnerStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonArtifactsTableOrderingComposer
    extends Composer<_$TraceDatabase, $LessonArtifactsTable> {
  $$LessonArtifactsTableOrderingComposer({
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

  ColumnOrderings<String> get sliceId => $composableBuilder(
    column: $table.sliceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonArtifactsTableAnnotationComposer
    extends Composer<_$TraceDatabase, $LessonArtifactsTable> {
  $$LessonArtifactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sliceId =>
      $composableBuilder(column: $table.sliceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  Expression<T> learnerStatesRefs<T extends Object>(
    Expression<T> Function($$LearnerStatesTableAnnotationComposer a) f,
  ) {
    final $$LearnerStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learnerStates,
      getReferencedColumn: (t) => t.lessonArtifactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearnerStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.learnerStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonArtifactsTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $LessonArtifactsTable,
          LessonArtifact,
          $$LessonArtifactsTableFilterComposer,
          $$LessonArtifactsTableOrderingComposer,
          $$LessonArtifactsTableAnnotationComposer,
          $$LessonArtifactsTableCreateCompanionBuilder,
          $$LessonArtifactsTableUpdateCompanionBuilder,
          (LessonArtifact, $$LessonArtifactsTableReferences),
          LessonArtifact,
          PrefetchHooks Function({bool learnerStatesRefs})
        > {
  $$LessonArtifactsTableTableManager(
    _$TraceDatabase db,
    $LessonArtifactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonArtifactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonArtifactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonArtifactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sliceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonArtifactsCompanion(
                id: id,
                sliceId: sliceId,
                version: version,
                contentHash: contentHash,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sliceId,
                required int version,
                required String contentHash,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => LessonArtifactsCompanion.insert(
                id: id,
                sliceId: sliceId,
                version: version,
                contentHash: contentHash,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LessonArtifactsTable, LessonArtifact>(table),
                  $$LessonArtifactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({learnerStatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (learnerStatesRefs) db.learnerStates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (learnerStatesRefs)
                    await $_getPrefetchedData<
                      LessonArtifact,
                      $LessonArtifactsTable,
                      LearnerState
                    >(
                      currentTable: table,
                      referencedTable: $$LessonArtifactsTableReferences
                          ._learnerStatesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LessonArtifactsTableReferences(
                            db,
                            table,
                            p0,
                          ).learnerStatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.lessonArtifactId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LessonArtifactsTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $LessonArtifactsTable,
      LessonArtifact,
      $$LessonArtifactsTableFilterComposer,
      $$LessonArtifactsTableOrderingComposer,
      $$LessonArtifactsTableAnnotationComposer,
      $$LessonArtifactsTableCreateCompanionBuilder,
      $$LessonArtifactsTableUpdateCompanionBuilder,
      (LessonArtifact, $$LessonArtifactsTableReferences),
      LessonArtifact,
      PrefetchHooks Function({bool learnerStatesRefs})
    >;
typedef $$LearnerStatesTableCreateCompanionBuilder =
    LearnerStatesCompanion Function({
      required String id,
      required String sliceId,
      required String lessonArtifactId,
      required int version,
      required String contentHash,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$LearnerStatesTableUpdateCompanionBuilder =
    LearnerStatesCompanion Function({
      Value<String> id,
      Value<String> sliceId,
      Value<String> lessonArtifactId,
      Value<int> version,
      Value<String> contentHash,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$LearnerStatesTableReferences
    extends BaseReferences<_$TraceDatabase, $LearnerStatesTable, LearnerState> {
  $$LearnerStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LessonArtifactsTable _lessonArtifactIdTable(_$TraceDatabase db) => db
      .lessonArtifacts
      .createAlias('learner_states__lesson_artifact_id__lesson_artifacts__id');

  $$LessonArtifactsTableProcessedTableManager get lessonArtifactId {
    final $_column = $_itemColumn<String>('lesson_artifact_id')!;

    final manager = $$LessonArtifactsTableTableManager(
      $_db,
      $_db.lessonArtifacts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonArtifactIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LearnerStatesTableFilterComposer
    extends Composer<_$TraceDatabase, $LearnerStatesTable> {
  $$LearnerStatesTableFilterComposer({
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

  ColumnFilters<String> get sliceId => $composableBuilder(
    column: $table.sliceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonArtifactsTableFilterComposer get lessonArtifactId {
    final $$LessonArtifactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonArtifactId,
      referencedTable: $db.lessonArtifacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonArtifactsTableFilterComposer(
            $db: $db,
            $table: $db.lessonArtifacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearnerStatesTableOrderingComposer
    extends Composer<_$TraceDatabase, $LearnerStatesTable> {
  $$LearnerStatesTableOrderingComposer({
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

  ColumnOrderings<String> get sliceId => $composableBuilder(
    column: $table.sliceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonArtifactsTableOrderingComposer get lessonArtifactId {
    final $$LessonArtifactsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonArtifactId,
      referencedTable: $db.lessonArtifacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonArtifactsTableOrderingComposer(
            $db: $db,
            $table: $db.lessonArtifacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearnerStatesTableAnnotationComposer
    extends Composer<_$TraceDatabase, $LearnerStatesTable> {
  $$LearnerStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sliceId =>
      $composableBuilder(column: $table.sliceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$LessonArtifactsTableAnnotationComposer get lessonArtifactId {
    final $$LessonArtifactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonArtifactId,
      referencedTable: $db.lessonArtifacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonArtifactsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonArtifacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearnerStatesTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $LearnerStatesTable,
          LearnerState,
          $$LearnerStatesTableFilterComposer,
          $$LearnerStatesTableOrderingComposer,
          $$LearnerStatesTableAnnotationComposer,
          $$LearnerStatesTableCreateCompanionBuilder,
          $$LearnerStatesTableUpdateCompanionBuilder,
          (LearnerState, $$LearnerStatesTableReferences),
          LearnerState,
          PrefetchHooks Function({bool lessonArtifactId})
        > {
  $$LearnerStatesTableTableManager(
    _$TraceDatabase db,
    $LearnerStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnerStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearnerStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearnerStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sliceId = const Value.absent(),
                Value<String> lessonArtifactId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerStatesCompanion(
                id: id,
                sliceId: sliceId,
                lessonArtifactId: lessonArtifactId,
                version: version,
                contentHash: contentHash,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sliceId,
                required String lessonArtifactId,
                required int version,
                required String contentHash,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => LearnerStatesCompanion.insert(
                id: id,
                sliceId: sliceId,
                lessonArtifactId: lessonArtifactId,
                version: version,
                contentHash: contentHash,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LearnerStatesTable, LearnerState>(table),
                  $$LearnerStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonArtifactId = false}) {
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
                    if (lessonArtifactId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonArtifactId,
                                referencedTable: $$LearnerStatesTableReferences
                                    ._lessonArtifactIdTable(db),
                                referencedColumn: $$LearnerStatesTableReferences
                                    ._lessonArtifactIdTable(db)
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

typedef $$LearnerStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $LearnerStatesTable,
      LearnerState,
      $$LearnerStatesTableFilterComposer,
      $$LearnerStatesTableOrderingComposer,
      $$LearnerStatesTableAnnotationComposer,
      $$LearnerStatesTableCreateCompanionBuilder,
      $$LearnerStatesTableUpdateCompanionBuilder,
      (LearnerState, $$LearnerStatesTableReferences),
      LearnerState,
      PrefetchHooks Function({bool lessonArtifactId})
    >;
typedef $$HighlightAnchorsTableCreateCompanionBuilder =
    HighlightAnchorsCompanion Function({
      required String id,
      required int version,
      required String contentHashAtCreation,
      required String sourceBlockId,
      required String pageId,
      Value<String?> lessonBlockId,
      required String quote,
      required String prefix,
      required String suffix,
      required int startOffset,
      required int endOffset,
      Value<double?> bboxX,
      Value<double?> bboxY,
      Value<double?> bboxW,
      Value<double?> bboxH,
      required String color,
      required String status,
      Value<bool> tombstone,
      Value<String?> tombstonedAt,
      Value<int> rowid,
    });
typedef $$HighlightAnchorsTableUpdateCompanionBuilder =
    HighlightAnchorsCompanion Function({
      Value<String> id,
      Value<int> version,
      Value<String> contentHashAtCreation,
      Value<String> sourceBlockId,
      Value<String> pageId,
      Value<String?> lessonBlockId,
      Value<String> quote,
      Value<String> prefix,
      Value<String> suffix,
      Value<int> startOffset,
      Value<int> endOffset,
      Value<double?> bboxX,
      Value<double?> bboxY,
      Value<double?> bboxW,
      Value<double?> bboxH,
      Value<String> color,
      Value<String> status,
      Value<bool> tombstone,
      Value<String?> tombstonedAt,
      Value<int> rowid,
    });

class $$HighlightAnchorsTableFilterComposer
    extends Composer<_$TraceDatabase, $HighlightAnchorsTable> {
  $$HighlightAnchorsTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHashAtCreation => $composableBuilder(
    column: $table.contentHashAtCreation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceBlockId => $composableBuilder(
    column: $table.sourceBlockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pageId => $composableBuilder(
    column: $table.pageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonBlockId => $composableBuilder(
    column: $table.lessonBlockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxX => $composableBuilder(
    column: $table.bboxX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxY => $composableBuilder(
    column: $table.bboxY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxW => $composableBuilder(
    column: $table.bboxW,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bboxH => $composableBuilder(
    column: $table.bboxH,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tombstone => $composableBuilder(
    column: $table.tombstone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tombstonedAt => $composableBuilder(
    column: $table.tombstonedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HighlightAnchorsTableOrderingComposer
    extends Composer<_$TraceDatabase, $HighlightAnchorsTable> {
  $$HighlightAnchorsTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHashAtCreation => $composableBuilder(
    column: $table.contentHashAtCreation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceBlockId => $composableBuilder(
    column: $table.sourceBlockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pageId => $composableBuilder(
    column: $table.pageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonBlockId => $composableBuilder(
    column: $table.lessonBlockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxX => $composableBuilder(
    column: $table.bboxX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxY => $composableBuilder(
    column: $table.bboxY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxW => $composableBuilder(
    column: $table.bboxW,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bboxH => $composableBuilder(
    column: $table.bboxH,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tombstone => $composableBuilder(
    column: $table.tombstone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tombstonedAt => $composableBuilder(
    column: $table.tombstonedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HighlightAnchorsTableAnnotationComposer
    extends Composer<_$TraceDatabase, $HighlightAnchorsTable> {
  $$HighlightAnchorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get contentHashAtCreation => $composableBuilder(
    column: $table.contentHashAtCreation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceBlockId => $composableBuilder(
    column: $table.sourceBlockId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pageId =>
      $composableBuilder(column: $table.pageId, builder: (column) => column);

  GeneratedColumn<String> get lessonBlockId => $composableBuilder(
    column: $table.lessonBlockId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quote =>
      $composableBuilder(column: $table.quote, builder: (column) => column);

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);

  GeneratedColumn<String> get suffix =>
      $composableBuilder(column: $table.suffix, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<double> get bboxX =>
      $composableBuilder(column: $table.bboxX, builder: (column) => column);

  GeneratedColumn<double> get bboxY =>
      $composableBuilder(column: $table.bboxY, builder: (column) => column);

  GeneratedColumn<double> get bboxW =>
      $composableBuilder(column: $table.bboxW, builder: (column) => column);

  GeneratedColumn<double> get bboxH =>
      $composableBuilder(column: $table.bboxH, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get tombstone =>
      $composableBuilder(column: $table.tombstone, builder: (column) => column);

  GeneratedColumn<String> get tombstonedAt => $composableBuilder(
    column: $table.tombstonedAt,
    builder: (column) => column,
  );
}

class $$HighlightAnchorsTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $HighlightAnchorsTable,
          HighlightAnchor,
          $$HighlightAnchorsTableFilterComposer,
          $$HighlightAnchorsTableOrderingComposer,
          $$HighlightAnchorsTableAnnotationComposer,
          $$HighlightAnchorsTableCreateCompanionBuilder,
          $$HighlightAnchorsTableUpdateCompanionBuilder,
          (
            HighlightAnchor,
            BaseReferences<
              _$TraceDatabase,
              $HighlightAnchorsTable,
              HighlightAnchor
            >,
          ),
          HighlightAnchor,
          PrefetchHooks Function()
        > {
  $$HighlightAnchorsTableTableManager(
    _$TraceDatabase db,
    $HighlightAnchorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightAnchorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightAnchorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighlightAnchorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> contentHashAtCreation = const Value.absent(),
                Value<String> sourceBlockId = const Value.absent(),
                Value<String> pageId = const Value.absent(),
                Value<String?> lessonBlockId = const Value.absent(),
                Value<String> quote = const Value.absent(),
                Value<String> prefix = const Value.absent(),
                Value<String> suffix = const Value.absent(),
                Value<int> startOffset = const Value.absent(),
                Value<int> endOffset = const Value.absent(),
                Value<double?> bboxX = const Value.absent(),
                Value<double?> bboxY = const Value.absent(),
                Value<double?> bboxW = const Value.absent(),
                Value<double?> bboxH = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> tombstone = const Value.absent(),
                Value<String?> tombstonedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HighlightAnchorsCompanion(
                id: id,
                version: version,
                contentHashAtCreation: contentHashAtCreation,
                sourceBlockId: sourceBlockId,
                pageId: pageId,
                lessonBlockId: lessonBlockId,
                quote: quote,
                prefix: prefix,
                suffix: suffix,
                startOffset: startOffset,
                endOffset: endOffset,
                bboxX: bboxX,
                bboxY: bboxY,
                bboxW: bboxW,
                bboxH: bboxH,
                color: color,
                status: status,
                tombstone: tombstone,
                tombstonedAt: tombstonedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int version,
                required String contentHashAtCreation,
                required String sourceBlockId,
                required String pageId,
                Value<String?> lessonBlockId = const Value.absent(),
                required String quote,
                required String prefix,
                required String suffix,
                required int startOffset,
                required int endOffset,
                Value<double?> bboxX = const Value.absent(),
                Value<double?> bboxY = const Value.absent(),
                Value<double?> bboxW = const Value.absent(),
                Value<double?> bboxH = const Value.absent(),
                required String color,
                required String status,
                Value<bool> tombstone = const Value.absent(),
                Value<String?> tombstonedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HighlightAnchorsCompanion.insert(
                id: id,
                version: version,
                contentHashAtCreation: contentHashAtCreation,
                sourceBlockId: sourceBlockId,
                pageId: pageId,
                lessonBlockId: lessonBlockId,
                quote: quote,
                prefix: prefix,
                suffix: suffix,
                startOffset: startOffset,
                endOffset: endOffset,
                bboxX: bboxX,
                bboxY: bboxY,
                bboxW: bboxW,
                bboxH: bboxH,
                color: color,
                status: status,
                tombstone: tombstone,
                tombstonedAt: tombstonedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HighlightAnchorsTable, HighlightAnchor>(table),
                  BaseReferences<
                    _$TraceDatabase,
                    $HighlightAnchorsTable,
                    HighlightAnchor
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HighlightAnchorsTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $HighlightAnchorsTable,
      HighlightAnchor,
      $$HighlightAnchorsTableFilterComposer,
      $$HighlightAnchorsTableOrderingComposer,
      $$HighlightAnchorsTableAnnotationComposer,
      $$HighlightAnchorsTableCreateCompanionBuilder,
      $$HighlightAnchorsTableUpdateCompanionBuilder,
      (
        HighlightAnchor,
        BaseReferences<
          _$TraceDatabase,
          $HighlightAnchorsTable,
          HighlightAnchor
        >,
      ),
      HighlightAnchor,
      PrefetchHooks Function()
    >;
typedef $$StudyNotesTableCreateCompanionBuilder =
    StudyNotesCompanion Function({
      required String id,
      required int version,
      required String contentHash,
      Value<String?> anchorId,
      Value<String?> sourceBlockId,
      Value<String?> figureId,
      Value<String?> lessonBlockId,
      required String body,
      required bool pinned,
      required String createdAt,
      required String updatedAt,
      Value<bool> tombstone,
      Value<String?> tombstonedAt,
      Value<int> rowid,
    });
typedef $$StudyNotesTableUpdateCompanionBuilder =
    StudyNotesCompanion Function({
      Value<String> id,
      Value<int> version,
      Value<String> contentHash,
      Value<String?> anchorId,
      Value<String?> sourceBlockId,
      Value<String?> figureId,
      Value<String?> lessonBlockId,
      Value<String> body,
      Value<bool> pinned,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<bool> tombstone,
      Value<String?> tombstonedAt,
      Value<int> rowid,
    });

class $$StudyNotesTableFilterComposer
    extends Composer<_$TraceDatabase, $StudyNotesTable> {
  $$StudyNotesTableFilterComposer({
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

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorId => $composableBuilder(
    column: $table.anchorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceBlockId => $composableBuilder(
    column: $table.sourceBlockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get figureId => $composableBuilder(
    column: $table.figureId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonBlockId => $composableBuilder(
    column: $table.lessonBlockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tombstone => $composableBuilder(
    column: $table.tombstone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tombstonedAt => $composableBuilder(
    column: $table.tombstonedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyNotesTableOrderingComposer
    extends Composer<_$TraceDatabase, $StudyNotesTable> {
  $$StudyNotesTableOrderingComposer({
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

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorId => $composableBuilder(
    column: $table.anchorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceBlockId => $composableBuilder(
    column: $table.sourceBlockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get figureId => $composableBuilder(
    column: $table.figureId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonBlockId => $composableBuilder(
    column: $table.lessonBlockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tombstone => $composableBuilder(
    column: $table.tombstone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tombstonedAt => $composableBuilder(
    column: $table.tombstonedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyNotesTableAnnotationComposer
    extends Composer<_$TraceDatabase, $StudyNotesTable> {
  $$StudyNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchorId =>
      $composableBuilder(column: $table.anchorId, builder: (column) => column);

  GeneratedColumn<String> get sourceBlockId => $composableBuilder(
    column: $table.sourceBlockId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get figureId =>
      $composableBuilder(column: $table.figureId, builder: (column) => column);

  GeneratedColumn<String> get lessonBlockId => $composableBuilder(
    column: $table.lessonBlockId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get tombstone =>
      $composableBuilder(column: $table.tombstone, builder: (column) => column);

  GeneratedColumn<String> get tombstonedAt => $composableBuilder(
    column: $table.tombstonedAt,
    builder: (column) => column,
  );
}

class $$StudyNotesTableTableManager
    extends
        RootTableManager<
          _$TraceDatabase,
          $StudyNotesTable,
          StudyNote,
          $$StudyNotesTableFilterComposer,
          $$StudyNotesTableOrderingComposer,
          $$StudyNotesTableAnnotationComposer,
          $$StudyNotesTableCreateCompanionBuilder,
          $$StudyNotesTableUpdateCompanionBuilder,
          (
            StudyNote,
            BaseReferences<_$TraceDatabase, $StudyNotesTable, StudyNote>,
          ),
          StudyNote,
          PrefetchHooks Function()
        > {
  $$StudyNotesTableTableManager(_$TraceDatabase db, $StudyNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String?> anchorId = const Value.absent(),
                Value<String?> sourceBlockId = const Value.absent(),
                Value<String?> figureId = const Value.absent(),
                Value<String?> lessonBlockId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<bool> tombstone = const Value.absent(),
                Value<String?> tombstonedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyNotesCompanion(
                id: id,
                version: version,
                contentHash: contentHash,
                anchorId: anchorId,
                sourceBlockId: sourceBlockId,
                figureId: figureId,
                lessonBlockId: lessonBlockId,
                body: body,
                pinned: pinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
                tombstone: tombstone,
                tombstonedAt: tombstonedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int version,
                required String contentHash,
                Value<String?> anchorId = const Value.absent(),
                Value<String?> sourceBlockId = const Value.absent(),
                Value<String?> figureId = const Value.absent(),
                Value<String?> lessonBlockId = const Value.absent(),
                required String body,
                required bool pinned,
                required String createdAt,
                required String updatedAt,
                Value<bool> tombstone = const Value.absent(),
                Value<String?> tombstonedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyNotesCompanion.insert(
                id: id,
                version: version,
                contentHash: contentHash,
                anchorId: anchorId,
                sourceBlockId: sourceBlockId,
                figureId: figureId,
                lessonBlockId: lessonBlockId,
                body: body,
                pinned: pinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
                tombstone: tombstone,
                tombstonedAt: tombstonedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyNotesTable, StudyNote>(table),
                  BaseReferences<_$TraceDatabase, $StudyNotesTable, StudyNote>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$TraceDatabase,
      $StudyNotesTable,
      StudyNote,
      $$StudyNotesTableFilterComposer,
      $$StudyNotesTableOrderingComposer,
      $$StudyNotesTableAnnotationComposer,
      $$StudyNotesTableCreateCompanionBuilder,
      $$StudyNotesTableUpdateCompanionBuilder,
      (StudyNote, BaseReferences<_$TraceDatabase, $StudyNotesTable, StudyNote>),
      StudyNote,
      PrefetchHooks Function()
    >;

class $TraceDatabaseManager {
  final _$TraceDatabase _db;
  $TraceDatabaseManager(this._db);
  $$LibraryEntriesTableTableManager get libraryEntries =>
      $$LibraryEntriesTableTableManager(_db, _db.libraryEntries);
  $$SourceEntriesTableTableManager get sourceEntries =>
      $$SourceEntriesTableTableManager(_db, _db.sourceEntries);
  $$SourcePagesTableTableManager get sourcePages =>
      $$SourcePagesTableTableManager(_db, _db.sourcePages);
  $$SourceBlocksTableTableManager get sourceBlocks =>
      $$SourceBlocksTableTableManager(_db, _db.sourceBlocks);
  $$SourceCitationsTableTableManager get sourceCitations =>
      $$SourceCitationsTableTableManager(_db, _db.sourceCitations);
  $$FigureAssetsTableTableManager get figureAssets =>
      $$FigureAssetsTableTableManager(_db, _db.figureAssets);
  $$LessonArtifactsTableTableManager get lessonArtifacts =>
      $$LessonArtifactsTableTableManager(_db, _db.lessonArtifacts);
  $$LearnerStatesTableTableManager get learnerStates =>
      $$LearnerStatesTableTableManager(_db, _db.learnerStates);
  $$HighlightAnchorsTableTableManager get highlightAnchors =>
      $$HighlightAnchorsTableTableManager(_db, _db.highlightAnchors);
  $$StudyNotesTableTableManager get studyNotes =>
      $$StudyNotesTableTableManager(_db, _db.studyNotes);
}
