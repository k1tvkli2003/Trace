import 'package:crypto/crypto.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'local_lesson_repository.dart';
import 'local_review_repository.dart';
import 'trace_database.dart' as db;

/// One verified, immutable lesson replay with its source evidence.
final class CachedReviewLesson {
  const CachedReviewLesson({
    required this.item,
    required this.artifact,
    required this.citations,
  });

  final domain.ReviewItem item;
  final domain.LessonArtifact artifact;
  final Map<String, ReviewCitationEvidence> citations;
}

final class ReviewCitationEvidence {
  const ReviewCitationEvidence({
    required this.citation,
    required this.sourceName,
    required this.sourceId,
    required this.sourceHash,
  });

  final domain.SourceCitation citation;
  final String sourceName;
  final String sourceId;
  final String sourceHash;
  String get locator => citation.locator;
  String get quote => citation.quote;
}

/// Offline-only due query and read-only cached replay. No AI or mutation path.
final class LocalReviewInboxRepository {
  const LocalReviewInboxRepository(this.database);
  final db.TraceDatabase database;

  Future<List<domain.ReviewItem>> listDue(String nowUtc) =>
      LocalReviewRepository(database).listDueItems(nowUtc);

  Future<CachedReviewLesson> openDue(String itemId, String nowUtc) async {
    final due = await listDue(nowUtc);
    final matching = due.where((item) => item.id == itemId).toList();
    if (matching.length != 1) {
      throw StateError('Review is absent or not due');
    }
    final item = matching.single;
    if (item.targetType != domain.ReviewTargetType.lessonBox) {
      throw StateError('Review target cannot be replayed as a lesson');
    }
    final artifact = await LocalLessonRepository(
      database,
    ).readArtifact(item.targetId);
    if (artifact == null ||
        artifact.id != item.targetId ||
        artifact.contentHash != item.contentHash) {
      throw StateError('Cached lesson is missing or has changed');
    }
    final citations = <String, ReviewCitationEvidence>{};
    for (final id in artifact.citationIds) {
      final citationRow = await (database.select(
        database.sourceCitations,
      )..where((entry) => entry.id.equals(id))).getSingleOrNull();
      if (citationRow == null) throw StateError('Source citation is missing');
      final block =
          await (database.select(database.sourceBlocks)
                ..where((entry) => entry.id.equals(citationRow.sourceBlockId)))
              .getSingleOrNull();
      final page =
          await (database.select(database.sourcePages)
                ..where((entry) => entry.id.equals(citationRow.pageId)))
              .getSingleOrNull();
      if (block == null ||
          page == null ||
          block.pageId != page.id ||
          block.documentId != page.documentId ||
          block.version != page.version ||
          (!block.rawText.contains(citationRow.quote) &&
              !block.normalizedText.contains(citationRow.quote))) {
        throw StateError('Citation source is not verified');
      }
      final source = await (database.select(
        database.sourceEntries,
      )..where((entry) => entry.id.equals(block.documentId))).getSingleOrNull();
      if (source == null ||
          block.sourceHash != source.sourceHash ||
          sha256.convert(source.originalBytes).toString() !=
              source.sourceHash) {
        throw StateError('Citation source hash is not verified');
      }
      final citation = domain.SourceCitation.fromJson({
        'id': citationRow.id,
        'version': citationRow.version,
        'contentHash': citationRow.contentHash,
        'sourceBlockId': citationRow.sourceBlockId,
        'pageId': citationRow.pageId,
        'figureId': citationRow.figureId,
        'quote': citationRow.quote,
        'locator': citationRow.locator,
        'confidence': citationRow.confidence,
        'extractionVersion': citationRow.extractionVersion,
      });
      citations[id] = ReviewCitationEvidence(
        citation: citation,
        sourceName: source.name,
        sourceId: source.id,
        sourceHash: source.sourceHash,
      );
    }
    return CachedReviewLesson(
      item: item,
      artifact: artifact,
      citations: Map.unmodifiable(citations),
    );
  }
}
