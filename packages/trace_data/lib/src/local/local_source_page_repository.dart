import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Local repository for immutable rendered-page identities.
final class LocalSourcePageRepository {
  LocalSourcePageRepository(this.database);

  final db.TraceDatabase database;

  Future<List<domain.SourcePage>> listForDocument(String documentId) async {
    final rows =
        await (database.select(database.sourcePages)
              ..where((table) => table.documentId.equals(documentId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.pageNumber),
                (table) => OrderingTerm.asc(table.version),
              ]))
            .get();
    return [for (final row in rows) _toDomain(row)];
  }

  Future<void> putPage(domain.SourcePage page) async {
    await database.transaction(() async {
      final existing = await (database.select(
        database.sourcePages,
      )..where((table) => table.id.equals(page.id))).getSingleOrNull();
      if (existing != null) {
        final saved = _toDomain(existing);
        if (!_same(saved, page)) {
          throw StateError(
            'SourcePage ${page.id} is immutable; changed pixel or render identity',
          );
        }
        return;
      }
      final sameIdentity =
          await (database.select(database.sourcePages)..where(
                (table) =>
                    table.documentId.equals(page.documentId) &
                    table.pageNumber.equals(page.pageNumber) &
                    table.version.equals(page.version) &
                    table.renderProfile.equals(page.renderProfile),
              ))
              .getSingleOrNull();
      if (sameIdentity != null) {
        throw StateError(
          'SourcePage identity already belongs to ${sameIdentity.id}',
        );
      }
      await database
          .into(database.sourcePages)
          .insert(
            db.SourcePagesCompanion.insert(
              id: page.id,
              documentId: page.documentId,
              version: Value(page.version),
              pageNumber: page.pageNumber,
              pixelHash: page.pixelHash,
              renderProfile: page.renderProfile,
              thumbnailPath: page.thumbnailPath,
              visionStatus: page.rawVisionStatus,
            ),
          );
    });
  }

  Future<void> putPages(Iterable<domain.SourcePage> pages) async {
    await database.transaction(() async {
      for (final page in pages) {
        await putPage(page);
      }
    });
  }

  domain.SourcePage _toDomain(db.SourcePage row) => domain.SourcePage.fromJson({
    'id': row.id,
    'documentId': row.documentId,
    'version': row.version,
    'pageNumber': row.pageNumber,
    'pixelHash': row.pixelHash,
    'renderProfile': row.renderProfile,
    'thumbnailPath': row.thumbnailPath,
    'visionStatus': row.visionStatus,
  });

  bool _same(domain.SourcePage left, domain.SourcePage right) =>
      _mapsEqual(left.toJson(), right.toJson());

  bool _mapsEqual(Map<String, Object> left, Map<String, Object> right) {
    if (left.length != right.length) return false;
    for (final entry in left.entries) {
      if (entry.value != right[entry.key]) return false;
    }
    return true;
  }
}
