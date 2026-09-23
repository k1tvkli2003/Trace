enum ReviewTargetType {
  lessonBox('lesson_box'),
  recallPrompt('recall_prompt'),
  highlight('highlight'),
  note('note'),
  unsupported('unsupported');

  const ReviewTargetType(this.wireName);
  final String wireName;
}

enum ReviewItemState {
  active('active'),
  suspended('suspended'),
  completed('completed'),
  unsupported('unsupported');

  const ReviewItemState(this.wireName);
  final String wireName;
}

/// Deterministic review projection; AI never owns schedule calculations.
final class ReviewItem {
  const ReviewItem._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.targetType,
    required this.rawTargetType,
    required this.targetId,
    required this.dueAt,
    required this.rawDueAt,
    required this.intervalDays,
    required this.ease,
    required this.lapses,
    required this.state,
    required this.rawState,
    required this.schedulerVersion,
  });

  final String id;
  final int version;
  final String contentHash;
  final ReviewTargetType targetType;
  final String rawTargetType;
  final String targetId;
  final DateTime dueAt;
  final String rawDueAt;
  final int intervalDays;
  final double ease;
  final int lapses;
  final ReviewItemState state;
  final String rawState;
  final String schedulerVersion;

  factory ReviewItem.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final version = json['version'];
    final interval = json['intervalDays'];
    final ease = json['ease'];
    final lapses = json['lapses'];
    if (version is! int ||
        version < 1 ||
        interval is! int ||
        interval < 0 ||
        ease is! num ||
        !ease.isFinite ||
        ease < 1 ||
        lapses is! int ||
        lapses < 0) {
      throw const FormatException(
        'Invalid review version or scheduler numbers',
      );
    }
    final hash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final rawDueAt = text('dueAt');
    final dueAt = DateTime.tryParse(rawDueAt);
    if (dueAt == null || !dueAt.isUtc || !rawDueAt.endsWith('Z')) {
      throw const FormatException('dueAt must be an ISO-8601 UTC timestamp');
    }
    final rawTargetType = text('targetType');
    final targetType = ReviewTargetType.values
        .where((candidate) => candidate.wireName == rawTargetType)
        .firstOrNull;
    final rawState = text('state');
    final state = ReviewItemState.values
        .where((candidate) => candidate.wireName == rawState)
        .firstOrNull;
    return ReviewItem._(
      id: text('id'),
      version: version,
      contentHash: hash,
      targetType: targetType ?? ReviewTargetType.unsupported,
      rawTargetType: rawTargetType,
      targetId: text('targetId'),
      dueAt: dueAt,
      rawDueAt: rawDueAt,
      intervalDays: interval,
      ease: ease.toDouble(),
      lapses: lapses,
      state: state ?? ReviewItemState.unsupported,
      rawState: rawState,
      schedulerVersion: text('schedulerVersion'),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'targetType': rawTargetType,
    'targetId': targetId,
    'dueAt': rawDueAt,
    'intervalDays': intervalDays,
    'ease': ease,
    'lapses': lapses,
    'state': rawState,
    'schedulerVersion': schedulerVersion,
  };
}
