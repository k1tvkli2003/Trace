enum ReviewRating {
  again('again'),
  hard('hard'),
  good('good'),
  easy('easy'),
  unsupported('unsupported');

  const ReviewRating(this.wireName);
  final String wireName;
}

/// Append-only evidence; schedule projection can be rebuilt from events.
final class ReviewEvent {
  const ReviewEvent._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.reviewItemId,
    required this.rating,
    required this.rawRating,
    required this.occurredAt,
    required this.rawOccurredAt,
    required this.previousDueAt,
    required this.rawPreviousDueAt,
    required this.nextDueAt,
    required this.rawNextDueAt,
    required this.deviceId,
    required this.schedulerVersion,
  });

  final String id;
  final int version;
  final String contentHash;
  final String reviewItemId;
  final ReviewRating rating;
  final String rawRating;
  final DateTime occurredAt;
  final String rawOccurredAt;
  final DateTime? previousDueAt;
  final String? rawPreviousDueAt;
  final DateTime nextDueAt;
  final String rawNextDueAt;
  final String deviceId;
  final String schedulerVersion;

  factory ReviewEvent.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    DateTime utc(String value, String key) {
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
    final rawOccurredAt = text('occurredAt');
    final rawNextDueAt = text('nextDueAt');
    final occurredAt = utc(rawOccurredAt, 'occurredAt');
    final nextDueAt = utc(rawNextDueAt, 'nextDueAt');
    if (nextDueAt.isBefore(occurredAt)) {
      throw const FormatException('nextDueAt cannot precede occurredAt');
    }
    final previous = json['previousDueAt'];
    if (previous != null && previous is! String) {
      throw const FormatException('previousDueAt must be null or UTC text');
    }
    final rawPreviousDueAt = previous as String?;
    final previousDueAt = rawPreviousDueAt == null
        ? null
        : utc(rawPreviousDueAt, 'previousDueAt');
    final rawRating = text('rating');
    final rating = ReviewRating.values
        .where((candidate) => candidate.wireName == rawRating)
        .firstOrNull;
    return ReviewEvent._(
      id: text('id'),
      version: version,
      contentHash: hash,
      reviewItemId: text('reviewItemId'),
      rating: rating ?? ReviewRating.unsupported,
      rawRating: rawRating,
      occurredAt: occurredAt,
      rawOccurredAt: rawOccurredAt,
      previousDueAt: previousDueAt,
      rawPreviousDueAt: rawPreviousDueAt,
      nextDueAt: nextDueAt,
      rawNextDueAt: rawNextDueAt,
      deviceId: text('deviceId'),
      schedulerVersion: text('schedulerVersion'),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'reviewItemId': reviewItemId,
    'rating': rawRating,
    'occurredAt': rawOccurredAt,
    'previousDueAt': rawPreviousDueAt,
    'nextDueAt': rawNextDueAt,
    'deviceId': deviceId,
    'schedulerVersion': schedulerVersion,
  };
}
