/// Source-linked learner note. Presentation coordinates never define identity.
final class StudyNote {
  const StudyNote._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.anchorId,
    required this.sourceBlockId,
    required this.figureId,
    required this.lessonBlockId,
    required this.body,
    required this.pinned,
    required this.createdAt,
    required this.rawCreatedAt,
    required this.updatedAt,
    required this.rawUpdatedAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String? anchorId;
  final String? sourceBlockId;
  final String? figureId;
  final String? lessonBlockId;
  final String body;
  final bool pinned;
  final DateTime createdAt;
  final String rawCreatedAt;
  final DateTime updatedAt;
  final String rawUpdatedAt;

  factory StudyNote.fromJson(Map<String, Object?> json) {
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
    final anchorId = nullableText('anchorId');
    final sourceBlockId = nullableText('sourceBlockId');
    final figureId = nullableText('figureId');
    final lessonBlockId = nullableText('lessonBlockId');
    if (anchorId == null &&
        sourceBlockId == null &&
        figureId == null &&
        lessonBlockId == null) {
      throw const FormatException('StudyNote must have a source-linked target');
    }
    final pinned = json['pinned'];
    if (pinned is! bool) {
      throw const FormatException('pinned must be boolean');
    }
    final rawCreatedAt = text('createdAt');
    final rawUpdatedAt = text('updatedAt');
    final createdAt = utc(rawCreatedAt, 'createdAt');
    final updatedAt = utc(rawUpdatedAt, 'updatedAt');
    if (updatedAt.isBefore(createdAt)) {
      throw const FormatException('updatedAt cannot precede createdAt');
    }
    return StudyNote._(
      id: text('id'),
      version: version,
      contentHash: hash,
      anchorId: anchorId,
      sourceBlockId: sourceBlockId,
      figureId: figureId,
      lessonBlockId: lessonBlockId,
      body: text('body'),
      pinned: pinned,
      createdAt: createdAt,
      rawCreatedAt: rawCreatedAt,
      updatedAt: updatedAt,
      rawUpdatedAt: rawUpdatedAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'anchorId': anchorId,
    'sourceBlockId': sourceBlockId,
    'figureId': figureId,
    'lessonBlockId': lessonBlockId,
    'body': body,
    'pinned': pinned,
    'createdAt': rawCreatedAt,
    'updatedAt': rawUpdatedAt,
  };
}
