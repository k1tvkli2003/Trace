import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Local repository for immutable, hash-bound reading-order blocks.
final class LocalSourceBlockRepository {
  LocalSourceBlockRepository(this.database);

  final db.TraceDatabase database;

  Future<List<domain.SourceBlock>> listForPage(String pageId) async {
    final rows =
        await (database.select(database.sourceBlocks)
              ..where((table) => table.pageId.equals(pageId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.order),
                (table) => OrderingTerm.asc(table.version),
              ]))
            .get();
    return [for (final row in rows) _toDomain(row)];
  }

  Future<void> putBlock(domain.SourceBlock block) async {
    await database.transaction(() => _putBlock(block));
  }

  Future<void> putBlocks(Iterable<domain.SourceBlock> blocks) async {
    await database.transaction(() async {
      for (final block in blocks) {
        await _putBlock(block);
      }
    });
  }

  Future<void> _putBlock(domain.SourceBlock block) async {
    final source = await (database.select(
      database.sourceEntries,
    )..where((table) => table.id.equals(block.documentId))).getSingleOrNull();
    if (source == null) {
      throw StateError('SourceDocument ${block.documentId} does not exist');
    }
    if (source.sourceHash != block.sourceHash) {
      throw StateError('SourceBlock ${block.id} has a mismatched source hash');
    }

    final page = await (database.select(
      database.sourcePages,
    )..where((table) => table.id.equals(block.pageId))).getSingleOrNull();
    if (page == null || page.documentId != block.documentId) {
      throw StateError('SourcePage ${block.pageId} is not in this document');
    }
    if (page.version != block.version) {
      throw StateError('SourceBlock version must match SourcePage version');
    }

    final existing = await (database.select(
      database.sourceBlocks,
    )..where((table) => table.id.equals(block.id))).getSingleOrNull();
    if (existing != null) {
      if (!_same(_toDomain(existing), block)) {
        throw StateError('SourceBlock ${block.id} is immutable');
      }
      return;
    }

    final sameOrder =
        await (database.select(database.sourceBlocks)..where(
              (table) =>
                  table.pageId.equals(block.pageId) &
                  table.version.equals(block.version) &
                  table.order.equals(block.order),
            ))
            .getSingleOrNull();
    if (sameOrder != null) {
      throw StateError(
        'SourceBlock order ${block.order} already belongs to ${sameOrder.id}',
      );
    }

    final box = block.bbox;
    await database
        .into(database.sourceBlocks)
        .insert(
          db.SourceBlocksCompanion.insert(
            id: block.id,
            documentId: block.documentId,
            pageId: block.pageId,
            version: Value(block.version),
            sourceHash: block.sourceHash,
            order: block.order,
            kind: block.rawKind,
            rawText: block.rawText,
            normalizedText: block.normalizedText,
            bboxX: Value(box?.x),
            bboxY: Value(box?.y),
            bboxWidth: Value(box?.width),
            bboxHeight: Value(box?.height),
          ),
        );
  }

  domain.SourceBlock _toDomain(db.SourceBlock row) =>
      domain.SourceBlock.fromJson({
        'id': row.id,
        'documentId': row.documentId,
        'pageId': row.pageId,
        'version': row.version,
        'sourceHash': row.sourceHash,
        'order': row.order,
        'kind': row.kind,
        'rawText': row.rawText,
        'normalizedText': row.normalizedText,
        if (row.bboxX != null)
          'bbox': {
            'x': row.bboxX,
            'y': row.bboxY,
            'w': row.bboxWidth,
            'h': row.bboxHeight,
          },
      });

  bool _same(domain.SourceBlock left, domain.SourceBlock right) {
    final leftBox = left.bbox;
    final rightBox = right.bbox;
    return left.id == right.id &&
        left.documentId == right.documentId &&
        left.pageId == right.pageId &&
        left.version == right.version &&
        left.sourceHash == right.sourceHash &&
        left.order == right.order &&
        left.rawKind == right.rawKind &&
        left.rawText == right.rawText &&
        left.normalizedText == right.normalizedText &&
        leftBox?.x == rightBox?.x &&
        leftBox?.y == rightBox?.y &&
        leftBox?.width == rightBox?.width &&
        leftBox?.height == rightBox?.height;
  }
}
