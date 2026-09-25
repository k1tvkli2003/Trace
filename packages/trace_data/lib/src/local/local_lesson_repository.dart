import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'local_oplog_repository.dart';
import 'local_review_repository.dart';
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

  /// Applies one footer action locally, queues its sync operation, and on
  /// first STUDIED creates a deterministic review in the same transaction.
  /// No network or AI call is made here.
  Future<domain.LearnerStateActionReceipt> applyStateAction(
    domain.LearnerStateActionRequest request,
  ) async {
    _validateActionRequest(request);
    final occurredAt = DateTime.parse(request.occurredAt);
    final outbox = LocalOplogRepository(database);

    return database.transaction(() async {
      final existingOperation = await outbox.readOperation(request.actionId);
      if (existingOperation != null) {
        if (!_matchesAction(existingOperation, request)) {
          throw StateError('Action ${request.actionId} is immutable');
        }
        final original = Map<String, Object?>.from(
          (existingOperation.payload['nextState']! as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
        return domain.LearnerStateActionReceipt(
          state: domain.LearnerState.fromJson(original),
          replayed: true,
        );
      }

      final current = await _readStateInTransaction(request.stateId);
      if (current == null) {
        throw StateError('Learner state ${request.stateId} is absent');
      }
      if (current.sliceId != request.sliceId ||
          current.lessonArtifactId != request.lessonArtifactId) {
        throw const FormatException(
          'Action identity does not match learner state',
        );
      }
      if (current.lastActionAt != null &&
          !occurredAt.isAfter(current.lastActionAt!)) {
        throw StateError(
          'Action time must be newer than current learner state',
        );
      }

      final next = _nextState(current, request);
      final operation = _operationForAction(
        request: request,
        state: current,
        nextState: next,
      );
      final review = await _maybeFirstStudyReview(current, next, request);
      await database
          .into(database.learnerStates)
          .insert(
            db.LearnerStatesCompanion.insert(
              id: next.id,
              sliceId: next.sliceId,
              lessonArtifactId: request.lessonArtifactId,
              version: next.version,
              contentHash: next.contentHash,
              payloadJson: jsonEncode(next.toJson()),
            ),
          );
      await outbox.putBatch(operations: [operation], runs: []);
      if (review != null) {
        await LocalReviewRepository(database).putReviewItem(review);
      }
      return domain.LearnerStateActionReceipt(state: next, replayed: false);
    });
  }

  Future<domain.ReviewItem?> _maybeFirstStudyReview(
    domain.LearnerState current,
    domain.LearnerState next,
    domain.LearnerStateActionRequest request,
  ) async {
    if (current.status == domain.LearnerStateStatus.studied ||
        next.status != domain.LearnerStateStatus.studied) {
      return null;
    }
    final reviewId = 'review:${request.stateId}';
    final artifact = await readArtifact(request.lessonArtifactId);
    if (artifact == null || artifact.sliceId != next.sliceId) {
      throw StateError('Studied lesson artifact is absent or outside slice');
    }
    final existing = await LocalReviewRepository(
      database,
    ).readReviewItem(reviewId);
    if (existing != null) {
      if (current.version == 1 ||
          existing.targetType != domain.ReviewTargetType.lessonBox ||
          existing.targetId != artifact.id ||
          existing.contentHash != artifact.contentHash ||
          existing.schedulerVersion !=
              LocalReviewRepository.offsetSchedulerVersion) {
        throw StateError('Review item $reviewId conflicts with studied lesson');
      }
      return null;
    }
    return LocalReviewRepository.firstStudyItem(
      id: reviewId,
      targetId: artifact.id,
      targetType: domain.ReviewTargetType.lessonBox,
      contentHash: artifact.contentHash,
      firstStudiedAt: DateTime.parse(request.occurredAt),
    );
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
    return _readStateInTransaction(id);
  }

  static bool _matchesAction(
    domain.SyncOperation existing,
    domain.LearnerStateActionRequest request,
  ) {
    final payload = existing.payload;
    return existing.entityType == 'learner_state' &&
        existing.entityId == request.stateId &&
        existing.rawMutationType == 'update' &&
        payload['action'] == request.action.wireName &&
        payload['sliceId'] == request.sliceId &&
        payload['lessonArtifactId'] == request.lessonArtifactId &&
        payload['occurredAt'] == request.occurredAt &&
        payload['deviceId'] == request.deviceId;
  }

  Future<domain.LearnerState?> _readStateInTransaction(String id) async {
    final exact = await (database.select(
      database.learnerStates,
    )..where((entry) => entry.id.equals(id))).getSingleOrNull();
    if (exact == null) return null;
    final rows =
        (await (database.select(
              database.learnerStates,
            )..where((entry) => entry.sliceId.equals(exact.sliceId))).get())
            .where((row) => row.id == id || row.id.startsWith('$id:'))
            .toList();
    rows.sort((a, b) {
      final versionOrder = b.version.compareTo(a.version);
      return versionOrder != 0 ? versionOrder : b.id.compareTo(a.id);
    });
    return _stateFromRow(rows.first);
  }

  domain.LearnerState _stateFromRow(db.LearnerState row) {
    final parsed = domain.LearnerState.fromJson(
      Map<String, Object?>.from(jsonDecode(row.payloadJson) as Map),
    );
    if (parsed.id != row.id ||
        parsed.sliceId != row.sliceId ||
        parsed.version != row.version ||
        parsed.contentHash != row.contentHash ||
        parsed.lessonArtifactId != row.lessonArtifactId) {
      throw const FormatException('Learner state row metadata mismatch');
    }
    return parsed;
  }

  static domain.LearnerState _nextState(
    domain.LearnerState current,
    domain.LearnerStateActionRequest request,
  ) {
    final nextId = '${current.id}:${request.actionId}';
    final nextJson = {
      ...current.toJson(),
      'id': nextId,
      'version': current.version + 1,
      'status': request.action.wireName,
      'lastReadAt': request.action == domain.LearnerStateAction.inProgress
          ? current.rawLastReadAt
          : request.occurredAt,
      'lastActionAt': request.occurredAt,
      'confidence': _confidenceFor(request.action),
    };
    final canonical = jsonEncode(nextJson);
    return domain.LearnerState.fromJson({
      ...nextJson,
      'contentHash': sha256.convert(utf8.encode(canonical)).toString(),
    });
  }

  static double _confidenceFor(domain.LearnerStateAction action) =>
      switch (action) {
        domain.LearnerStateAction.inProgress => 0.25,
        domain.LearnerStateAction.studied => 0.65,
        domain.LearnerStateAction.notLearned => 0.1,
        domain.LearnerStateAction.mastered => 1.0,
        domain.LearnerStateAction.skipped => 0.0,
      };

  static domain.SyncOperation _operationForAction({
    required domain.LearnerStateActionRequest request,
    required domain.LearnerState? state,
    required domain.LearnerState? nextState,
  }) {
    if (state == null || nextState == null) {
      throw StateError('Learner state is required for action receipt');
    }
    final payload = {
      'stateId': request.stateId,
      'sliceId': request.sliceId,
      'lessonArtifactId': request.lessonArtifactId,
      'action': request.action.wireName,
      'occurredAt': request.occurredAt,
      'deviceId': request.deviceId,
      'previousState': state.toJson(),
      'nextState': nextState.toJson(),
    };
    return domain.SyncOperation.fromJson({
      'operationId': request.actionId,
      'version': 1,
      'contentHash': sha256
          .convert(utf8.encode(jsonEncode(payload)))
          .toString(),
      'entityType': 'learner_state',
      'entityId': request.stateId,
      'mutationType': 'update',
      'payload': payload,
      'localVersion': nextState.version,
      'syncState': 'pending',
      'retryCount': 0,
      'createdAt': request.occurredAt,
    });
  }

  static void _validateActionRequest(domain.LearnerStateActionRequest request) {
    if (request.actionId.trim().isEmpty ||
        request.stateId.trim().isEmpty ||
        request.sliceId.trim().isEmpty ||
        request.lessonArtifactId.trim().isEmpty ||
        request.deviceId.trim().isEmpty) {
      throw const FormatException('Action identity fields must be nonempty');
    }
    final parsed = DateTime.tryParse(request.occurredAt);
    if (parsed == null || !parsed.isUtc || !request.occurredAt.endsWith('Z')) {
      throw const FormatException('Action occurredAt must be UTC ISO-8601');
    }
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
