import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Stores crop evidence only after its bytes and source identities verify.
final class LocalFigureAssetRepository {
  LocalFigureAssetRepository(this.database);

  final db.TraceDatabase database;

  Future<void> putCrop(domain.FigureAsset asset, Uint8List cropBytes) async {
    if (asset.reviewStatus == domain.FigureReviewStatus.approved) {
      throw StateError(
        'Figure approval must come from a separate audited action',
      );
    }
    final actualHash = sha256.convert(cropBytes).toString();
    if (actualHash != asset.assetHash) {
      throw StateError(
        'FigureAsset ${asset.id} crop hash does not match assetHash',
      );
    }

    await database.transaction(() async {
      final page = await (database.select(
        database.sourcePages,
      )..where((table) => table.id.equals(asset.pageId))).getSingleOrNull();
      if (page == null) {
        throw StateError('FigureAsset page ${asset.pageId} is missing');
      }
      if (page.pixelHash != asset.pagePixelHash) {
        throw StateError(
          'FigureAsset ${asset.id} is bound to a different page raster',
        );
      }
      final source = await (database.select(
        database.sourceEntries,
      )..where((table) => table.id.equals(page.documentId))).getSingleOrNull();
      if (source == null || source.sourceHash != asset.sourceHash) {
        throw StateError(
          'FigureAsset ${asset.id} is bound to a different source',
        );
      }

      final existing = await (database.select(
        database.figureAssets,
      )..where((table) => table.id.equals(asset.id))).getSingleOrNull();
      if (existing != null) {
        final savedBytes = Uint8List.fromList(existing.cropBytes);
        final saved = _toDomain(existing);
        if (!_same(saved, asset) || !_sameBytes(savedBytes, cropBytes)) {
          throw StateError('FigureAsset ${asset.id} is immutable');
        }
        return;
      }

      await database
          .into(database.figureAssets)
          .insert(
            db.FigureAssetsCompanion.insert(
              id: asset.id,
              version: asset.version,
              assetHash: asset.assetHash,
              sourceHash: asset.sourceHash,
              pagePixelHash: asset.pagePixelHash,
              pageId: asset.pageId,
              bboxX: asset.bbox.x,
              bboxY: asset.bbox.y,
              bboxWidth: asset.bbox.width,
              bboxHeight: asset.bbox.height,
              widthPx: asset.widthPx,
              heightPx: asset.heightPx,
              caption: asset.caption,
              altText: asset.altText,
              reviewStatus: asset.rawReviewStatus,
              cropBytes: cropBytes,
            ),
          );
    });
  }

  Future<(domain.FigureAsset, Uint8List)?> readCrop(String id) async {
    final row = await (database.select(
      database.figureAssets,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final bytes = Uint8List.fromList(row.cropBytes);
    if (sha256.convert(bytes).toString() != row.assetHash) {
      throw StateError('FigureAsset $id crop hash verification failed');
    }
    return (_toDomain(row), bytes);
  }

  domain.FigureAsset _toDomain(db.FigureAsset row) =>
      domain.FigureAsset.fromJson({
        'id': row.id,
        'version': row.version,
        'assetHash': row.assetHash,
        'sourceHash': row.sourceHash,
        'pagePixelHash': row.pagePixelHash,
        'pageId': row.pageId,
        'bbox': {
          'x': row.bboxX,
          'y': row.bboxY,
          'w': row.bboxWidth,
          'h': row.bboxHeight,
        },
        'widthPx': row.widthPx,
        'heightPx': row.heightPx,
        'caption': row.caption,
        'altText': row.altText,
        'reviewStatus': row.reviewStatus,
      });

  bool _same(domain.FigureAsset left, domain.FigureAsset right) {
    final a = left.toJson();
    final b = right.toJson();
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (jsonEncode(entry.value) != jsonEncode(b[entry.key])) return false;
    }
    return true;
  }

  bool _sameBytes(Uint8List left, Uint8List right) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) return false;
    }
    return true;
  }
}
