import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart';

import 'trace_database.dart';

/// Imports capped PDF originals. Never reads a PDF text layer or performs OCR.
final class LocalPdfSourceRepository {
  const LocalPdfSourceRepository(this.db);
  final TraceDatabase db;

  static const maxBytes = 16 * 1024 * 1024;

  Future<SourceDocument> importPdf({
    required String libraryId,
    required String name,
    required Uint8List bytes,
  }) async {
    if (!name.toLowerCase().endsWith('.pdf') ||
        bytes.length < 9 ||
        bytes.length > maxBytes ||
        utf8.decode(bytes.sublist(0, 5), allowMalformed: true) != '%PDF-') {
      throw const FormatException('Invalid PDF name, header, or size');
    }
    // Lightweight signature gate only; the PDF renderer validates full structure.
    final tail = latin1.decode(
      bytes.sublist(bytes.length > 2048 ? bytes.length - 2048 : 0),
    );
    if (!tail.contains('%%EOF')) {
      throw const FormatException('PDF EOF marker missing');
    }
    final sourceHash = sha256.convert(bytes).toString();
    final id = sha256
        .convert(utf8.encode('$libraryId\u0000$name\u0000$sourceHash'))
        .toString();
    SourceDocument manifest(int version) => SourceDocument.fromJson({
      'id': id,
      'libraryId': libraryId,
      'version': version,
      'sourceHash': sourceHash,
      'relativePath': name,
      'mimeType': 'application/pdf',
      'byteSize': bytes.length,
      'importVersion': 1,
      'format': 'pdf',
    });
    manifest(1); // Validate safe relative path before any database write.
    final library = await (db.select(
      db.libraryEntries,
    )..where((t) => t.id.equals(libraryId))).getSingleOrNull();
    if (library == null) throw StateError('Library collection not found');

    for (var attempt = 0; attempt < 8; attempt++) {
      final existing = await (db.select(
        db.sourceEntries,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (existing != null) {
        if (sha256.convert(existing.originalBytes).toString() != sourceHash) {
          throw StateError('Existing PDF original fails hash verification');
        }
        return manifest(existing.version);
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
              mimeType: 'application/pdf',
              format: 'pdf',
              originalBytes: Uint8List.fromList(bytes),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
    final persisted = await (db.select(
      db.sourceEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (persisted != null) {
      if (sha256.convert(persisted.originalBytes).toString() != sourceHash) {
        throw StateError('Existing PDF original fails hash verification');
      }
      return manifest(persisted.version);
    }
    throw StateError('Concurrent PDF import conflict; retry');
  }

  Future<List<SourceDocument>> listForLibrary(String libraryId) async {
    final rows =
        await (db.select(db.sourceEntries)
              ..where(
                (t) => t.libraryId.equals(libraryId) & t.format.equals('pdf'),
              )
              ..orderBy([
                (t) => OrderingTerm.asc(t.name),
                (t) => OrderingTerm.desc(t.version),
              ]))
            .get();
    return rows
        .map(
          (row) => SourceDocument.fromJson({
            'id': row.id,
            'libraryId': row.libraryId,
            'version': row.version,
            'sourceHash': row.sourceHash,
            'relativePath': row.name,
            'mimeType': row.mimeType,
            'byteSize': row.originalBytes.length,
            'importVersion': 1,
            'format': row.format,
          }),
        )
        .toList();
  }

  Future<Uint8List> readOriginal(String id) async {
    final row =
        await (db.select(db.sourceEntries)
              ..where((t) => t.id.equals(id) & t.format.equals('pdf')))
            .getSingleOrNull();
    if (row == null) throw StateError('PDF source not found');
    if (sha256.convert(row.originalBytes).toString() != row.sourceHash) {
      throw StateError('PDF original fails hash verification');
    }
    return Uint8List.fromList(row.originalBytes);
  }
}
