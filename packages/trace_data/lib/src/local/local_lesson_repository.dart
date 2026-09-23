import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Atomic local lesson/state persistence; evidence is loaded from DB.
final class LocalLessonRepository {
  LocalLessonRepository(this.database);

  final db.TraceDatabase database;

  Future<void> putLessonWithState(
    Map<String, Object?> artifactJson,
    Map<String, Object?> stateJson,
  ) async {
    await database.transaction(() async {
      final artifact = await _parseVerified(artifactJson);
      final state = domain.LearnerState.fromJson(stateJson);
      if (state.lessonArtifactId != artifact.id ||
          state.sliceId != artifact.sliceId) {
        throw const FormatException(
          'State must refer to this lesson and slice',
        );
      }
      final serialized = jsonEncode(artifact.toJson());
      final prior = await (database.select(
        database.lessonArtifacts,
      )..where((row) => row.id.equals(artifact.id))).getSingleOrNull();
      if (prior != null) {
        if (prior.payloadJson != serialized) {
          throw StateError('Lesson artifact ID is immutable');
        }
      } else {
        await database
            .into(database.lessonArtifacts)
            .insert(
              db.LessonArtifactsCompanion.insert(
                id: artifact.id,
                sliceId: artifact.sliceId,
                version: artifact.version,
                contentHash: artifact.contentHash,
                payloadJson: serialized,
              ),
            );
      }
      final statePayload = jsonEncode(state.toJson());
      final oldState = await (database.select(
        database.learnerStates,
      )..where((row) => row.id.equals(state.id))).getSingleOrNull();
      if (oldState != null) {
        if (oldState.payloadJson != statePayload) {
          throw StateError('Learner state ID is immutable; use a new version');
        }
      } else {
        await database
            .into(database.learnerStates)
            .insert(
              db.LearnerStatesCompanion.insert(
                id: state.id,
                sliceId: state.sliceId,
                lessonArtifactId: artifact.id,
                version: state.version,
                contentHash: state.contentHash,
                payloadJson: statePayload,
              ),
            );
      }
    });
  }

  Future<domain.LessonArtifact?> readArtifact(String id) async {
    final row = await (database.select(
      database.lessonArtifacts,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _parseVerified(
      Map<String, Object?>.from(jsonDecode(row.payloadJson) as Map),
    );
  }

  Future<domain.LearnerState?> readState(String id) async {
    final row = await (database.select(
      database.learnerStates,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return domain.LearnerState.fromJson(
      Map<String, Object?>.from(jsonDecode(row.payloadJson) as Map),
    );
  }

  Future<domain.LessonArtifact> _parseVerified(
    Map<String, Object?> payload,
  ) async {
    final rawCitations = payload['citationIds'];
    if (rawCitations is! List ||
        rawCitations.isEmpty ||
        rawCitations.any((id) => id is! String)) {
      throw const FormatException('Lesson needs citation IDs');
    }
    final rawFigures = payload['figureIds'];
    if (rawFigures is! List || rawFigures.isNotEmpty) {
      throw const FormatException('Figure approval path is not available yet');
    }
    final citations = <domain.SourceCitation>[];
    for (final id in rawCitations.cast<String>()) {
      final row = await (database.select(
        database.sourceCitations,
      )..where((entry) => entry.id.equals(id))).getSingleOrNull();
      if (row == null) throw StateError('Citation $id is absent');
      final block =
          await (database.select(database.sourceBlocks)
                ..where((entry) => entry.id.equals(row.sourceBlockId)))
              .getSingleOrNull();
      if (block == null ||
          block.pageId != row.pageId ||
          (!block.rawText.contains(row.quote) &&
              !block.normalizedText.contains(row.quote))) {
        throw StateError('Citation $id is not grounded in its source block');
      }
      citations.add(
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
        }),
      );
    }
    final artifact = domain.LessonArtifact.fromJson(
      payload,
      verifiedCitations: citations,
    );
    final digest = sha256
        .convert(utf8.encode(jsonEncode(artifact.lessonAstJson)))
        .toString();
    if (digest != artifact.contentHash) {
      throw const FormatException('Lesson AST content hash mismatch');
    }
    return artifact;
  }
}
