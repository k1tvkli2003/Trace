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
    sourceVersionUnique,
    sourcePageDocumentPageVersionProfileUnique,
    sourceBlockPageVersionOrderUnique,
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
}
