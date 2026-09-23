import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Immutable source evidence; never accepts fabricated out-of-block quotes.
final class LocalSourceCitationRepository {
  LocalSourceCitationRepository(this.database);

  final db.TraceDatabase database;

  Future<List<domain.SourceCitation>> listForBlock(String blockId) async {
    final rows =
        await (database.select(database.sourceCitations)
              ..where((table) => table.sourceBlockId.equals(blockId))
              ..orderBy([(table) => OrderingTerm.asc(table.id)]))
            .get();
    return [for (final row in rows) _toDomain(row)];
  }

  Future<void> putCitation(domain.SourceCitation citation) async {
    await database.transaction(() async {
      final block =
          await (database.select(database.sourceBlocks)
                ..where((table) => table.id.equals(citation.sourceBlockId)))
              .getSingleOrNull();
      if (block == null || block.pageId != citation.pageId) {
        throw StateError('Citation block/page reference does not exist');
      }
      if (!block.rawText.contains(citation.quote) &&
          !block.normalizedText.contains(citation.quote)) {
        throw StateError('Citation quote is absent from source block');
      }
      if (citation.figureId != null) {
        throw StateError('Figure citations need a persisted FigureAsset');
      }
      final existing = await (database.select(
        database.sourceCitations,
      )..where((table) => table.id.equals(citation.id))).getSingleOrNull();
      if (existing != null) {
        if (!_same(_toDomain(existing), citation)) {
          throw StateError('SourceCitation ${citation.id} is immutable');
        }
        return;
      }
      await database
          .into(database.sourceCitations)
          .insert(
            db.SourceCitationsCompanion.insert(
              id: citation.id,
              version: Value(citation.version),
              contentHash: citation.contentHash,
              sourceBlockId: citation.sourceBlockId,
              pageId: citation.pageId,
              figureId: Value(citation.figureId),
              quote: citation.quote,
              locator: citation.locator,
              confidence: citation.confidence,
              extractionVersion: citation.extractionVersion,
            ),
          );
    });
  }

  domain.SourceCitation _toDomain(db.SourceCitation row) =>
      domain.SourceCitation.fromJson({
        'id': row.id,
        'version': row.version,
        'contentHash': row.contentHash,
        'sourceBlockId': row.sourceBlockId,
        'pageId': row.pageId,
        'figureId': row.figureId,
        'quote': row.quote,
        'locator': row.locator,
        'confidence': row.confidence,
        'extractionVersion': row.extractionVersion,
      });

  bool _same(domain.SourceCitation left, domain.SourceCitation right) =>
      left.id == right.id &&
      left.version == right.version &&
      left.contentHash == right.contentHash &&
      left.sourceBlockId == right.sourceBlockId &&
      left.pageId == right.pageId &&
      left.figureId == right.figureId &&
      left.quote == right.quote &&
      left.locator == right.locator &&
      left.confidence == right.confidence &&
      left.extractionVersion == right.extractionVersion;
}
