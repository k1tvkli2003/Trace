/// Hash-bound identity of an imported source; no file bytes or platform API.
enum SourceDocumentFormat { pdf, markdown, text, image, unsupported }

/// Immutable source manifest item with captured provenance metadata.
///
/// Provenance describes origin only. It never changes how bytes are hashed,
/// versioned, or verified.
final class SourceDocument {
  const SourceDocument._({
    required this.id,
    required this.libraryId,
    required this.version,
    required this.sourceHash,
    required this.relativePath,
    required this.mimeType,
    required this.byteSize,
    required this.importVersion,
    required this.format,
    required this.rawFormat,
    required this.modifiedAt,
    required this.rawModifiedAt,
    required this.logicalRole,
    required this.exclusionReason,
  });

  final String id;
  final String libraryId;
  final int version;
  final String sourceHash;
  final String relativePath;
  final String mimeType;
  final int byteSize;
  final int importVersion;
  final SourceDocumentFormat format;
  final String rawFormat;

  /// Origin modification time in UTC, or null when picker did not report one.
  final DateTime? modifiedAt;

  /// Exact wire token for [modifiedAt], preserving original string.
  final String? rawModifiedAt;

  /// Logical role within library. Defaults to `primary`.
  final String logicalRole;

  /// Why source is excluded from lesson input, or null when accepted.
  final String? exclusionReason;

  factory SourceDocument.fromJson(Map<String, Object?> json) {
    String requiredText(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    int requiredInteger(String key, {int minimum = 1}) {
      final value = json[key];
      if (value is! int || value < minimum) {
        throw FormatException('$key must be >= $minimum');
      }
      return value;
    }

    final id = requiredText('id');
    final libraryId = requiredText('libraryId');
    final version = requiredInteger('version');
    final importVersion = requiredInteger('importVersion');
    final byteSize = requiredInteger('byteSize', minimum: 0);
    final mimeType = requiredText('mimeType');
    final rawFormat = requiredText('format');
    final sourceHash = requiredText('sourceHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(sourceHash)) {
      throw const FormatException('sourceHash must be lowercase SHA-256 hex');
    }
    final relativePath = requiredText('relativePath');
    if (relativePath.isEmpty ||
        relativePath.contains('\\') ||
        relativePath.contains(':') ||
        relativePath.contains('\u0000') ||
        relativePath
            .split('/')
            .any(
              (segment) => segment.isEmpty || segment == '.' || segment == '..',
            )) {
      throw const FormatException('relativePath must be a safe relative path');
    }

    final rawModifiedAt = json['modifiedAt'];
    DateTime? modifiedAt;
    String? rawModifiedAtToken;
    if (rawModifiedAt case final String token) {
      if (token.trim().isEmpty) {
        throw const FormatException('modifiedAt must be nonempty text');
      }
      final parsed = DateTime.tryParse(token);
      if (parsed == null || !parsed.isUtc || !token.endsWith('Z')) {
        throw const FormatException(
          'modifiedAt must be an ISO-8601 UTC timestamp',
        );
      }
      modifiedAt = parsed;
      rawModifiedAtToken = token;
    } else if (rawModifiedAt != null) {
      throw const FormatException('modifiedAt must be nonempty text');
    }

    final rawLogicalRole = json['logicalRole'];
    final String logicalRole;
    if (rawLogicalRole == null) {
      logicalRole = 'primary';
    } else if (rawLogicalRole is! String ||
        rawLogicalRole.trim().isEmpty) {
      throw const FormatException('logicalRole must be nonempty text');
    } else {
      logicalRole = rawLogicalRole;
    }

    final rawExclusionReason = json['exclusionReason'];
    if (rawExclusionReason != null &&
        (rawExclusionReason is! String ||
            rawExclusionReason.trim().isEmpty)) {
      throw const FormatException(
        'exclusionReason must be null or nonempty text',
      );
    }

    return SourceDocument._(
      id: id,
      libraryId: libraryId,
      version: version,
      sourceHash: sourceHash,
      relativePath: relativePath,
      mimeType: mimeType,
      byteSize: byteSize,
      importVersion: importVersion,
      format: switch (rawFormat) {
        'pdf' => SourceDocumentFormat.pdf,
        'markdown' => SourceDocumentFormat.markdown,
        'text' => SourceDocumentFormat.text,
        'image' => SourceDocumentFormat.image,
        _ => SourceDocumentFormat.unsupported,
      },
      rawFormat: rawFormat,
      modifiedAt: modifiedAt,
      rawModifiedAt: rawModifiedAtToken,
      logicalRole: logicalRole,
      exclusionReason: rawExclusionReason as String?,
    );
  }

  Map<String, Object> toJson() => {
    'id': id,
    'libraryId': libraryId,
    'version': version,
    'sourceHash': sourceHash,
    'relativePath': relativePath,
    'mimeType': mimeType,
    'byteSize': byteSize,
    'importVersion': importVersion,
    'format': rawFormat,
    'modifiedAt': ?rawModifiedAt,
    if (logicalRole != 'primary') 'logicalRole': logicalRole,
    'exclusionReason': ?exclusionReason,
  };
}

/// Origin map: latest revision per logical path, sorted by path.
///
/// Pure derived view over per-item manifests. SourceDocument rows remain the
/// single source of truth; this map only answers current origin for each path.
Map<String, SourceDocument> originMapFor(Iterable<SourceDocument> documents) {
  final latest = <String, SourceDocument>{};
  for (final document in documents) {
    final current = latest[document.relativePath];
    if (current == null || document.version > current.version) {
      latest[document.relativePath] = document;
    }
  }
  final paths = latest.keys.toList()..sort();
  return Map.unmodifiable({for (final path in paths) path: latest[path]!});
}
