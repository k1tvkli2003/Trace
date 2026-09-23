import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart';

import 'trace_database.dart';

/// Stores the *original* UTF-8 bytes atomically with a hash-bound manifest.
/// PDF is deliberately excluded: only rendered-page Vision may promote PDF text.
final class LocalTextSourceRepository {
  const LocalTextSourceRepository(this.db);
  final TraceDatabase db;

  Future<SourceDocument> importText({
    required String libraryId,
    required String name,
    required Uint8List bytes,
  }) async {
    if (bytes.isEmpty || bytes.length > 8 * 1024 * 1024) {
      throw const FormatException('Text source size must be 1..8388608 bytes');
    }
    final extension = name.toLowerCase().split('.').last;
    final format = switch (extension) {
      'txt' => 'text',
      'md' || 'markdown' => 'markdown',
      _ => throw const FormatException('Only TXT and Markdown are supported'),
    };
    final sourceHash = sha256.convert(bytes).toString();
    final id = sha256
        .convert(utf8.encode('$libraryId\u0000$name\u0000$sourceHash'))
        .toString();
    final manifest = SourceDocument.fromJson({
      'id': id,
      'libraryId': libraryId,
      'version': 1,
      'sourceHash': sourceHash,
      'relativePath': name,
      'mimeType': format == 'markdown' ? 'text/markdown' : 'text/plain',
      'byteSize': bytes.length,
      'importVersion': 1,
      'format': format,
    });
    final text = utf8.decode(bytes, allowMalformed: false);
    if (text.contains('\u0000')) {
      throw const FormatException('NUL in text source');
    }
    final library = await (db.select(
      db.libraryEntries,
    )..where((t) => t.id.equals(libraryId))).getSingleOrNull();
    if (library == null) throw StateError('Library collection not found');
    // SQLite enforces both ID and (library, filename, revision) uniqueness.
    // INSERT OR IGNORE handles replay races without overwriting originals;
    // a collided revision with different bytes advances on next iteration.
    for (var attempt = 0; attempt < 8; attempt++) {
      final existing = await (db.select(
        db.sourceEntries,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (existing != null) {
        if (sha256.convert(existing.originalBytes).toString() != sourceHash) {
          throw StateError('Existing source bytes fail hash verification');
        }
        return _manifest(existing);
      }
      final versions =
          await (db.select(db.sourceEntries)..where(
                (t) => t.libraryId.equals(libraryId) & t.name.equals(name),
              ))
              .get();
      final nextVersion =
          versions.fold<int>(
            0,
            (max, entry) => entry.version > max ? entry.version : max,
          ) +
          1;
      await db
          .into(db.sourceEntries)
          .insert(
            SourceEntriesCompanion.insert(
              id: id,
              libraryId: libraryId,
              name: name,
              version: Value(nextVersion),
              sourceHash: sourceHash,
              mimeType: manifest.mimeType,
              format: format,
              originalBytes: Uint8List.fromList(bytes),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
    final persisted = await (db.select(
      db.sourceEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (persisted != null &&
        sha256.convert(persisted.originalBytes).toString() == sourceHash) {
      return _manifest(persisted);
    }
    throw StateError('Concurrent source import conflict; retry');
  }

  Future<List<SourceDocument>> listForLibrary(String libraryId) async {
    final rows =
        await (db.select(db.sourceEntries)
              ..where((t) => t.libraryId.equals(libraryId))
              ..orderBy([
                (t) => OrderingTerm.asc(t.name),
                (t) => OrderingTerm.desc(t.version),
              ]))
            .get();
    return rows.map((row) => _manifest(row)).toList();
  }

  Future<Uint8List> readOriginal(String sourceId) async {
    final row = await (db.select(
      db.sourceEntries,
    )..where((t) => t.id.equals(sourceId))).getSingleOrNull();
    if (row == null) throw StateError('Source not found');
    if (sha256.convert(row.originalBytes).toString() != row.sourceHash) {
      throw StateError('Source original fails hash verification');
    }
    return Uint8List.fromList(row.originalBytes);
  }

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
  });
}
