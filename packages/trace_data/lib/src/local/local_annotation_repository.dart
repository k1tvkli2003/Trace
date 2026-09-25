import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Local-first highlights and notes. Deletes become tombstones for sync safety.
final class LocalAnnotationRepository {
  const LocalAnnotationRepository(this.database);

  final db.TraceDatabase database;

  Future<void> putAnchor(domain.HighlightAnchor anchor) async {
    if (anchor.status == domain.HighlightAnchorStatus.attached) {
      final block = await (database.select(
        database.sourceBlocks,
      )..where((row) => row.id.equals(anchor.sourceBlockId))).getSingleOrNull();
      if (block == null || block.pageId != anchor.pageId) {
        throw StateError('Attached highlight source locator is invalid');
      }
      if (block.sourceHash != anchor.contentHashAtCreation) {
        throw StateError('Highlight source hash is stale');
      }
      final sourceText = '${block.rawText}\n${block.normalizedText}';
      if (!sourceText.contains(anchor.quote)) {
        throw StateError('Highlight quote is absent from source block');
      }
    }

    await database.transaction(() async {
      final existing = await (database.select(
        database.highlightAnchors,
      )..where((row) => row.id.equals(anchor.id))).getSingleOrNull();
      if (existing != null) {
        if (existing.tombstone) {
          throw StateError('Highlight ${anchor.id} is tombstoned');
        }
        final saved = _anchorFromRow(existing);
        if (!_sameJson(saved.toJson(), anchor.toJson())) {
          throw StateError('Highlight ${anchor.id} is immutable');
        }
        return;
      }
      await database
          .into(database.highlightAnchors)
          .insert(
            db.HighlightAnchorsCompanion.insert(
              id: anchor.id,
              version: anchor.version,
              contentHashAtCreation: anchor.contentHashAtCreation,
              sourceBlockId: anchor.sourceBlockId,
              pageId: anchor.pageId,
              lessonBlockId: Value(anchor.lessonBlockId),
              quote: anchor.quote,
              prefix: anchor.prefix,
              suffix: anchor.suffix,
              startOffset: anchor.startOffset,
              endOffset: anchor.endOffset,
              bboxX: Value(anchor.bbox?.x),
              bboxY: Value(anchor.bbox?.y),
              bboxW: Value(anchor.bbox?.width),
              bboxH: Value(anchor.bbox?.height),
              color: anchor.color,
              status: anchor.rawStatus,
            ),
          );
    });
  }

  Future<domain.HighlightAnchor?> readAnchor(String id) async {
    final row =
        await (database.select(database.highlightAnchors)..where(
              (entry) => entry.id.equals(id) & entry.tombstone.equals(false),
            ))
            .getSingleOrNull();
    return row == null ? null : _anchorFromRow(row);
  }

  /// Read-only rehydration verdict for a stored anchor; never writes.
  Future<domain.HighlightRehydration> rehydrateAnchor(String id) async {
    final row =
        await (database.select(database.highlightAnchors)..where(
              (entry) => entry.id.equals(id) & entry.tombstone.equals(false),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Highlight $id is absent or already deleted');
    }
    if (row.status != domain.HighlightAnchorStatus.attached.wireName) {
      return domain.HighlightRehydration(
        attached: false,
        reason: 'already-detached',
        startOffset: row.startOffset,
        endOffset: row.endOffset,
        pageBboxFallback: false,
      );
    }
    final block = await (database.select(
      database.sourceBlocks,
    )..where((entry) => entry.id.equals(row.sourceBlockId))).getSingleOrNull();
    if (block == null || block.pageId != row.pageId) {
      throw StateError('Highlight $id source locator is invalid');
    }
    final anchor = _anchorFromRow(row);
    final blockBox =
        block.bboxX != null &&
            block.bboxY != null &&
            block.bboxWidth != null &&
            block.bboxHeight != null
        ? domain.NormalizedBox(
            x: block.bboxX!,
            y: block.bboxY!,
            width: block.bboxWidth!,
            height: block.bboxHeight!,
          )
        : null;
    return domain.rehydrateHighlight(
      anchor: anchor,
      blockId: block.id,
      pageId: block.pageId,
      sourceHash: block.sourceHash,
      sourceText: '${block.rawText}\n${block.normalizedText}',
      blockBbox: blockBox,
    );
  }

  /// Explicit attached-to-detached transition; silent moves stay forbidden.
  Future<void> markDetached(String id) async {
    final row = await (database.select(
      database.highlightAnchors,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    if (row == null || row.tombstone) {
      throw StateError('Highlight $id is absent or already deleted');
    }
    if (row.status != domain.HighlightAnchorStatus.attached.wireName) {
      throw StateError('Highlight $id is already detached');
    }
    final changed =
        await (database.update(database.highlightAnchors)..where(
              (entry) =>
                  entry.id.equals(id) &
                  entry.tombstone.equals(false) &
                  entry.status.equals(
                    domain.HighlightAnchorStatus.attached.wireName,
                  ),
            ))
            .write(
              db.HighlightAnchorsCompanion(
                status: Value(domain.HighlightAnchorStatus.detached.wireName),
              ),
            );
    if (changed == 0) {
      throw StateError('Highlight $id could not be detached');
    }
  }

  Future<bool> isAnchorTombstoned(String id) async {
    final row = await (database.select(
      database.highlightAnchors,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    return row?.tombstone ?? false;
  }

  Future<void> deleteAnchor(String id, String deletedAt) async {
    _utc(deletedAt, 'deletedAt');
    final changed =
        await (database.update(database.highlightAnchors)..where(
              (entry) => entry.id.equals(id) & entry.tombstone.equals(false),
            ))
            .write(
              db.HighlightAnchorsCompanion(
                tombstone: const Value(true),
                tombstonedAt: Value(deletedAt),
              ),
            );
    if (changed == 0) {
      throw StateError('Highlight $id is absent or already deleted');
    }
  }

  Future<void> putNote(domain.StudyNote note) async {
    if (note.anchorId != null) {
      final anchor = await (database.select(
        database.highlightAnchors,
      )..where((entry) => entry.id.equals(note.anchorId!))).getSingleOrNull();
      if (anchor == null || anchor.tombstone) {
        throw StateError('Note anchor is absent or tombstoned');
      }
    }
    if (note.sourceBlockId != null) {
      final block =
          await (database.select(database.sourceBlocks)
                ..where((entry) => entry.id.equals(note.sourceBlockId!)))
              .getSingleOrNull();
      if (block == null) throw StateError('Note source block is absent');
    }
    if (note.figureId != null) {
      final figure = await (database.select(
        database.figureAssets,
      )..where((entry) => entry.id.equals(note.figureId!))).getSingleOrNull();
      if (figure == null || figure.reviewStatus != 'approved') {
        throw StateError('Note figure is absent or not approved');
      }
    }

    await database.transaction(() async {
      final existing = await (database.select(
        database.studyNotes,
      )..where((entry) => entry.id.equals(note.id))).getSingleOrNull();
      if (existing?.tombstone == true) {
        throw StateError('Note ${note.id} is tombstoned');
      }
      if (existing != null &&
          _sameJson(_noteFromRow(existing).toJson(), note.toJson())) {
        return;
      }
      await database
          .into(database.studyNotes)
          .insertOnConflictUpdate(
            db.StudyNotesCompanion.insert(
              id: note.id,
              version: note.version,
              contentHash: note.contentHash,
              anchorId: Value(note.anchorId),
              sourceBlockId: Value(note.sourceBlockId),
              figureId: Value(note.figureId),
              lessonBlockId: Value(note.lessonBlockId),
              body: note.body,
              pinned: note.pinned,
              createdAt: note.rawCreatedAt,
              updatedAt: note.rawUpdatedAt,
            ),
          );
    });
  }

  Future<domain.StudyNote?> readNote(String id) async {
    final row =
        await (database.select(database.studyNotes)..where(
              (entry) => entry.id.equals(id) & entry.tombstone.equals(false),
            ))
            .getSingleOrNull();
    return row == null ? null : _noteFromRow(row);
  }

  /// Read-only backlink: live notes for one anchor, deterministic order.
  Future<List<domain.StudyNote>> listNotesForAnchor(String anchorId) async {
    final rows =
        await (database.select(database.studyNotes)
              ..where(
                (entry) =>
                    entry.anchorId.equals(anchorId) &
                    entry.tombstone.equals(false),
              )
              ..orderBy([
                (entry) => OrderingTerm(expression: entry.updatedAt),
                (entry) => OrderingTerm(expression: entry.id),
              ]))
            .get();
    return rows.map(_noteFromRow).toList();
  }

  /// Export a note as its valid JSON plus a display-only locator.
  /// Never redefines identity: the locator is for humans, IDs are truth.
  Future<Map<String, Object?>> exportNote(String id) async {
    final note = await readNote(id);
    if (note == null) {
      throw StateError('Note $id is absent or already deleted');
    }
    final locator = <String, Object?>{
      'anchorId': note.anchorId,
      'sourceBlockId': note.sourceBlockId,
      'figureId': note.figureId,
      'lessonBlockId': note.lessonBlockId,
    };
    if (note.anchorId != null) {
      final anchor = await (database.select(
        database.highlightAnchors,
      )..where((entry) => entry.id.equals(note.anchorId!))).getSingleOrNull();
      if (anchor != null) {
        locator['quote'] = anchor.quote;
        locator['pageId'] = anchor.pageId;
      }
    }
    if (note.sourceBlockId != null) {
      final block =
          await (database.select(database.sourceBlocks)
                ..where((entry) => entry.id.equals(note.sourceBlockId!)))
              .getSingleOrNull();
      if (block != null) {
        locator['pageId'] ??= block.pageId;
        locator['documentId'] = block.documentId;
      }
    }
    return {'note': note.toJson(), 'locator': locator};
  }

  Future<void> deleteNote(String id, String deletedAt) async {
    _utc(deletedAt, 'deletedAt');
    final changed =
        await (database.update(database.studyNotes)..where(
              (entry) => entry.id.equals(id) & entry.tombstone.equals(false),
            ))
            .write(
              db.StudyNotesCompanion(
                tombstone: const Value(true),
                tombstonedAt: Value(deletedAt),
              ),
            );
    if (changed == 0) throw StateError('Note $id is absent or already deleted');
  }

  domain.HighlightAnchor _anchorFromRow(db.HighlightAnchor row) {
    final hasBox =
        row.bboxX != null &&
        row.bboxY != null &&
        row.bboxW != null &&
        row.bboxH != null;
    return domain.HighlightAnchor.fromJson({
      'id': row.id,
      'version': row.version,
      'contentHashAtCreation': row.contentHashAtCreation,
      'sourceBlockId': row.sourceBlockId,
      'pageId': row.pageId,
      'lessonBlockId': row.lessonBlockId,
      'quote': row.quote,
      'prefix': row.prefix,
      'suffix': row.suffix,
      'startOffset': row.startOffset,
      'endOffset': row.endOffset,
      'bbox': hasBox
          ? {'x': row.bboxX, 'y': row.bboxY, 'w': row.bboxW, 'h': row.bboxH}
          : null,
      'color': row.color,
      'status': row.status,
    });
  }

  domain.StudyNote _noteFromRow(db.StudyNote row) => domain.StudyNote.fromJson({
    'id': row.id,
    'version': row.version,
    'contentHash': row.contentHash,
    'anchorId': row.anchorId,
    'sourceBlockId': row.sourceBlockId,
    'figureId': row.figureId,
    'lessonBlockId': row.lessonBlockId,
    'body': row.body,
    'pinned': row.pinned,
    'createdAt': row.createdAt,
    'updatedAt': row.updatedAt,
  });

  static bool _sameJson(Map<String, Object?> a, Map<String, Object?> b) =>
      a.toString() == b.toString();

  static void _utc(String value, String field) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null || !parsed.isUtc || !value.endsWith('Z')) {
      throw FormatException('$field must be UTC with Z suffix');
    }
  }
}
