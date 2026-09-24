import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart';

import 'trace_database.dart';

/// Validates and persists a deterministic batch of immutable source originals.
///
/// This boundary accepts file-like bytes only. It does not read host paths,
/// extract archives, run OCR, or treat image/PDF bytes as lesson text.
final class LocalSourceImportRepository {
  const LocalSourceImportRepository(this.db);

  final TraceDatabase db;

  static const maxBytes = 16 * 1024 * 1024;
  static const _textMaxBytes = 8 * 1024 * 1024;

  Future<SourceDocument> importOne({
    required String libraryId,
    required SourceImportItem item,
  }) async {
    return (await importBatch(libraryId: libraryId, items: [item])).single;
  }

  Future<List<SourceDocument>> importBatch({
    required String libraryId,
    required Iterable<SourceImportItem> items,
  }) async {
    final validated = _validateAndDedupe(items);
    if (validated.isEmpty) return const [];

    final library = await (db.select(
      db.libraryEntries,
    )..where((table) => table.id.equals(libraryId))).getSingleOrNull();
    if (library == null) throw StateError('Library collection not found');

    return db.transaction(() async {
      final output = <SourceDocument>[];
      for (final item in validated) {
        output.add(await _persistOne(libraryId: libraryId, item: item));
      }
      return output;
    });
  }

  Future<SourceDocument> _persistOne({
    required String libraryId,
    required SourceImportItem item,
  }) async {
    final sourceHash = sha256.convert(item.bytes).toString();
    final id = sha256
        .convert(
          utf8.encode('$libraryId\u0000${item.relativePath}\u0000$sourceHash'),
        )
        .toString();
    final existing = await (db.select(
      db.sourceEntries,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (existing != null) {
      if (sha256.convert(existing.originalBytes).toString() != sourceHash) {
        throw StateError('Existing source original fails hash verification');
      }
      if (!_rowMatchesProvenance(existing, item)) {
        throw const FormatException(
          'Existing source identity has conflicting provenance',
        );
      }
      return _manifest(existing);
    }

    final versions =
        await (db.select(db.sourceEntries)..where(
              (table) =>
                  table.libraryId.equals(libraryId) &
                  table.name.equals(item.relativePath),
            ))
            .get();
    final nextVersion =
        versions.fold<int>(
          0,
          (maximum, row) => row.version > maximum ? row.version : maximum,
        ) +
        1;
    final format = _formatFor(item.relativePath);
    final mimeType = _mimeFor(item.relativePath);
    final manifest = SourceDocument.fromJson({
      'id': id,
      'libraryId': libraryId,
      'version': nextVersion,
      'sourceHash': sourceHash,
      'relativePath': item.relativePath,
      'mimeType': mimeType,
      'byteSize': item.bytes.length,
      'importVersion': 1,
      'format': format,
      if (item.modifiedAt != null)
        'modifiedAt': item.modifiedAt!.toUtc().toIso8601String(),
      if (item.logicalRole != 'primary') 'logicalRole': item.logicalRole,
      if (item.exclusionReason != null)
        'exclusionReason': item.exclusionReason,
    });

    await db
        .into(db.sourceEntries)
        .insert(
          SourceEntriesCompanion.insert(
            id: id,
            libraryId: libraryId,
            name: item.relativePath,
            version: Value(nextVersion),
            sourceHash: sourceHash,
            mimeType: mimeType,
            format: format,
            modifiedAt: Value(
              item.modifiedAt?.toUtc().toIso8601String(),
            ),
            logicalRole: Value(item.logicalRole),
            exclusionReason: Value(item.exclusionReason),
            originalBytes: Uint8List.fromList(item.bytes),
          ),
        );
    return manifest;
  }

  Future<List<SourceDocument>> listForLibrary(String libraryId) async {
    final rows =
        await (db.select(db.sourceEntries)
              ..where((table) => table.libraryId.equals(libraryId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.name),
                (table) => OrderingTerm.asc(table.version),
              ]))
            .get();
    return rows.map(_manifest).toList();
  }

  Future<Uint8List> readOriginal(String sourceId) async {
    final row = await (db.select(
      db.sourceEntries,
    )..where((table) => table.id.equals(sourceId))).getSingleOrNull();
    if (row == null) throw StateError('Source not found');
    if (sha256.convert(row.originalBytes).toString() != row.sourceHash) {
      throw StateError('Source original fails hash verification');
    }
    return Uint8List.fromList(row.originalBytes);
  }

  List<SourceImportItem> _validateAndDedupe(Iterable<SourceImportItem> input) {
    final sorted = input.toList()
      ..sort((left, right) {
        final path = left.relativePath.compareTo(right.relativePath);
        if (path != 0) return path;
        final hash = sha256
            .convert(left.bytes)
            .toString()
            .compareTo(sha256.convert(right.bytes).toString());
        if (hash != 0) return hash;
        final modified = _compareModifiedAt(
          left.modifiedAt,
          right.modifiedAt,
        );
        if (modified != 0) return modified;
        final role = left.logicalRole.compareTo(right.logicalRole);
        if (role != 0) return role;
        return _compareNullableText(
          left.exclusionReason,
          right.exclusionReason,
        );
      });
    final accepted = <SourceImportItem>[];
    final seen = <String, SourceImportItem>{};
    for (final item in sorted) {
      _validateItem(item);
      final hash = sha256.convert(item.bytes).toString();
      final key = '${item.relativePath}\u0000$hash';
      final prior = seen[key];
      if (prior != null) {
        if (!_sameProvenance(prior, item)) {
          throw const FormatException('Conflicting source provenance');
        }
      } else {
        seen[key] = item;
        accepted.add(item);
      }
    }
    return accepted;
  }

  bool _sameProvenance(SourceImportItem left, SourceImportItem right) =>
      left.modifiedAt?.toUtc().microsecondsSinceEpoch ==
          right.modifiedAt?.toUtc().microsecondsSinceEpoch &&
      left.logicalRole == right.logicalRole &&
      left.exclusionReason == right.exclusionReason;

  bool _rowMatchesProvenance(SourceEntry row, SourceImportItem item) =>
      _sameProvenance(
        SourceImportItem(
          relativePath: row.name,
          bytes: Uint8List(0),
          modifiedAt: row.modifiedAt == null
              ? null
              : DateTime.parse(row.modifiedAt!),
          logicalRole: row.logicalRole,
          exclusionReason: row.exclusionReason,
        ),
        item,
      );

  int _compareModifiedAt(DateTime? left, DateTime? right) {
    if (left == null && right == null) return 0;
    if (left == null) return -1;
    if (right == null) return 1;
    return left.toUtc().microsecondsSinceEpoch.compareTo(
      right.toUtc().microsecondsSinceEpoch,
    );
  }

  int _compareNullableText(String? left, String? right) {
    if (left == null && right == null) return 0;
    if (left == null) return -1;
    if (right == null) return 1;
    return left.compareTo(right);
  }

  void _validateProvenance(SourceImportItem item) {
    if (item.logicalRole.trim().isEmpty) {
      throw const FormatException('logicalRole must be nonempty text');
    }
    if (item.exclusionReason != null &&
        item.exclusionReason!.trim().isEmpty) {
      throw const FormatException(
        'exclusionReason must be null or nonempty text',
      );
    }
  }

  void _validateItem(SourceImportItem item) {
    _validateProvenance(item);
    final path = item.relativePath;
    if (path.isEmpty ||
        path.contains('\\') ||
        path.contains(':') ||
        path.contains('\u0000') ||
        path.startsWith('/') ||
        path
            .split('/')
            .any(
              (segment) => segment.isEmpty || segment == '.' || segment == '..',
            )) {
      throw const FormatException('relativePath must be a safe relative path');
    }
    if (item.bytes.isEmpty) {
      throw const FormatException('Source bytes cannot be empty');
    }
    final format = _formatFor(path);
    final limit = format == 'text' || format == 'markdown'
        ? _textMaxBytes
        : maxBytes;
    if (item.bytes.length > limit) {
      throw const FormatException('Source exceeds size limit');
    }
    if ((format == 'text' || format == 'markdown') &&
        utf8.decode(item.bytes, allowMalformed: false).contains('\u0000')) {
      throw const FormatException('NUL in text source');
    }
    if (format == 'pdf') {
      if (item.bytes.length < 9 ||
          utf8.decode(item.bytes.sublist(0, 5), allowMalformed: true) !=
              '%PDF-' ||
          !latin1
              .decode(
                item.bytes.sublist(
                  item.bytes.length > 2048 ? item.bytes.length - 2048 : 0,
                ),
              )
              .contains('%%EOF')) {
        throw const FormatException('Invalid PDF header or EOF marker');
      }
    }
    if (format == 'image') {
      final lower = path.toLowerCase();
      final png =
          item.bytes.length >= 8 &&
          item.bytes.sublist(0, 8).join(',') ==
              const [137, 80, 78, 71, 13, 10, 26, 10].join(',');
      final jpeg =
          item.bytes.length >= 3 &&
          item.bytes[0] == 0xff &&
          item.bytes[1] == 0xd8 &&
          item.bytes[2] == 0xff;
      if ((lower.endsWith('.png') && !png) ||
          ((lower.endsWith('.jpg') || lower.endsWith('.jpeg')) && !jpeg)) {
        throw const FormatException('Image signature does not match extension');
      }
    }
  }

  String _formatFor(String path) {
    final extension = path.toLowerCase().split('.').last;
    return switch (extension) {
      'pdf' => 'pdf',
      'txt' => 'text',
      'md' || 'markdown' => 'markdown',
      'png' || 'jpg' || 'jpeg' => 'image',
      _ => throw const FormatException('Unsupported source format'),
    };
  }

  String _mimeFor(String path) => switch (path.toLowerCase().split('.').last) {
    'pdf' => 'application/pdf',
    'txt' => 'text/plain',
    'md' || 'markdown' => 'text/markdown',
    'png' => 'image/png',
    'jpg' || 'jpeg' => 'image/jpeg',
    _ => throw const FormatException('Unsupported source format'),
  };

  SourceDocument _manifest(SourceEntry row) => SourceDocument.fromJson({
    'id': row.id,
    'libraryId': row.libraryId,
    'version': row.version,
    'sourceHash': row.sourceHash,
    'relativePath': row.name,
    'mimeType': row.mimeType,
    'byteSize': row.originalBytes.length,
    'importVersion': 1,
    'format': row.format,
    if (row.modifiedAt != null) 'modifiedAt': row.modifiedAt!,
    if (row.logicalRole != 'primary') 'logicalRole': row.logicalRole,
    if (row.exclusionReason != null)
      'exclusionReason': row.exclusionReason!,
  });
}
