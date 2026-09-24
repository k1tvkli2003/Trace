import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart';

import 'trace_database.dart';

final class VisionCacheHit {
  const VisionCacheHit({required this.payloadJson, required this.reason});

  final String payloadJson;
  final String reason;
}

/// Local page-vision cache. Same key plus pixel hash hits; any identity change misses.
/// Stored payload must be a complete page-extract bound to that key.
final class LocalVisionCacheRepository {
  LocalVisionCacheRepository(this.database);

  final TraceDatabase database;

  Future<VisionCacheHit?> lookup({
    required PageVisionCacheKey key,
    required String pixelHash,
  }) async {
    if (!_isSha256Hex(pixelHash)) return null;
    final row = await (database.select(database.visionCacheEntries)..where(
          (table) =>
              table.cacheKey.equals(key.value) & table.pixelHash.equals(pixelHash),
        ))
        .getSingleOrNull();
    if (row == null) return null;
    _requireBoundExtract(
      payloadJson: row.payloadJson,
      key: key,
      pixelHash: pixelHash,
    );
    return VisionCacheHit(payloadJson: row.payloadJson, reason: 'hit');
  }

  Future<void> put({
    required PageVisionCacheKey key,
    required String pixelHash,
    required String payloadJson,
  }) async {
    if (!_isSha256Hex(pixelHash)) {
      throw const FormatException('Vision cache pixel hash must be SHA-256 hex');
    }
    final page = await (database.select(database.sourcePages)
          ..where((t) =>
              t.id.equals('page-${key.pageNumber}') &
              t.pixelHash.equals(pixelHash) &
              t.renderProfile.equals(key.renderProfile)))
        .getSingleOrNull();
    final source = page == null
        ? null
        : await (database.select(database.sourceEntries)
              ..where((t) => t.id.equals(page.documentId)))
            .getSingleOrNull();
    if (source == null || source.sourceHash != key.sourceHash) {
      throw StateError('Rendered page identity does not exist for this cache key');
    }
    _requireBoundExtract(payloadJson: payloadJson, key: key, pixelHash: pixelHash);
    await database.transaction(() async {
      final existing = await (database.select(database.visionCacheEntries)
            ..where(
              (table) =>
                  table.cacheKey.equals(key.value) &
                  table.pixelHash.equals(pixelHash),
            ))
          .getSingleOrNull();
      if (existing != null) {
        if (existing.payloadJson != payloadJson) {
          throw StateError('Vision cache entry is immutable');
        }
        return;
      }
      await database.into(database.visionCacheEntries).insert(
            VisionCacheEntriesCompanion.insert(
              id: key.value,
              cacheKey: key.value,
              pixelHash: pixelHash,
              payloadJson: payloadJson,
            ),
          );
    });
  }
}

void _requireBoundExtract({
  required String payloadJson,
  required PageVisionCacheKey key,
  required String pixelHash,
}) {
  final decoded = jsonDecode(payloadJson);
  if (decoded is! Map) {
    throw const FormatException('Vision cache payload must be an object');
  }
  final payload = Map<String, Object?>.from(decoded);
  if (payload['schemaVersion'] != 'page-extract-v1' ||
      payload['coverage'] != 'complete' ||
      payload['extractionVersion'] != 'page-vision-extract-v1') {
    throw const FormatException('Vision cache payload is not a complete extract');
  }
  if (payload['sourceHash'] != key.sourceHash ||
      payload['pixelHash'] != pixelHash ||
      payload['renderProfile'] != key.renderProfile ||
      payload['pageRef'] != 'page-${key.pageNumber}') {
    throw const FormatException('Vision cache payload does not match cache key');
  }
  final blocks = payload['blocks'];
  final figures = payload['figures'];
  if (blocks is! List || blocks.isEmpty || figures is! List) {
    throw const FormatException('Vision cache payload is missing page content');
  }
  if (payload.length != 9) {
    throw const FormatException('Vision cache payload contains unexpected fields');
  }
}

bool _isSha256Hex(String value) => RegExp(r'^[a-f0-9]{64}$').hasMatch(value);
