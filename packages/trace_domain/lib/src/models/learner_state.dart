/// User learning projection. Review-due is computed from due items, not stored.
enum LearnerStateStatus {
  notStarted('not_started'),
  inProgress('in_progress'),
  studied('studied'),
  notLearned('not_learned'),
  mastered('mastered'),
  skipped('skipped'),
  unsupported('unsupported');

  const LearnerStateStatus(this.wireName);
  final String wireName;
}

final class LearnerState {
  const LearnerState._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.sliceId,
    required this.lessonArtifactId,
    required this.status,
    required this.rawStatus,
    required this.confidence,
    required this.lastReadAt,
    required this.rawLastReadAt,
    required this.lastActionAt,
    required this.rawLastActionAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String sliceId;
  final String? lessonArtifactId;
  final LearnerStateStatus status;
  final String rawStatus;
  final double confidence;
  final DateTime? lastReadAt;
  final String? rawLastReadAt;
  final DateTime? lastActionAt;
  final String? rawLastActionAt;

  factory LearnerState.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    String? nullableText(String key) {
      final value = json[key];
      if (value == null) return null;
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be null or nonempty text');
      }
      return value;
    }

    DateTime? utc(String? value, String key) {
      if (value == null) return null;
      final parsed = DateTime.tryParse(value);
      if (parsed == null || !parsed.isUtc || !value.endsWith('Z')) {
        throw FormatException('$key must be an ISO-8601 UTC timestamp');
      }
      return parsed;
    }

    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be a positive integer');
    }
    final hash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final confidence = json['confidence'];
    if (confidence is! num ||
        !confidence.isFinite ||
        confidence < 0 ||
        confidence > 1) {
      throw const FormatException('confidence must be between 0 and 1');
    }
    final rawStatus = text('status');
    if (rawStatus.toLowerCase() == 'review_due') {
      throw const FormatException(
        'review_due is a projection, not persisted state',
      );
    }
    final status = LearnerStateStatus.values
        .where((candidate) => candidate.wireName == rawStatus)
        .firstOrNull;
    final rawLastReadAt = nullableText('lastReadAt');
    final rawLastActionAt = nullableText('lastActionAt');
    return LearnerState._(
      id: text('id'),
      version: version,
      contentHash: hash,
      sliceId: text('sliceId'),
      lessonArtifactId: nullableText('lessonArtifactId'),
      status: status ?? LearnerStateStatus.unsupported,
      rawStatus: rawStatus,
      confidence: confidence.toDouble(),
      lastReadAt: utc(rawLastReadAt, 'lastReadAt'),
      rawLastReadAt: rawLastReadAt,
      lastActionAt: utc(rawLastActionAt, 'lastActionAt'),
      rawLastActionAt: rawLastActionAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'sliceId': sliceId,
    'lessonArtifactId': lessonArtifactId,
    'status': rawStatus,
    'confidence': confidence,
    'lastReadAt': rawLastReadAt,
    'lastActionAt': rawLastActionAt,
  };
}
