import 'lesson_ast.dart';

/// Immutable generated lesson version, separate from source evidence.
final class LessonArtifact {
  const LessonArtifact._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.sliceId,
    required this.lesson,
    required this.citationIds,
    required this.figureIds,
    required this.modelProfile,
    required this.promptVersion,
    required this.createdAt,
    required this.rawCreatedAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String sliceId;
  final LessonDocument lesson;
  final List<String> citationIds;
  final List<String> figureIds;
  final String modelProfile;
  final String promptVersion;
  final DateTime createdAt;
  final String rawCreatedAt;

  Map<String, Object?> get lessonAstJson => lesson.toJson();

  factory LessonArtifact.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be a positive integer');
    }
    final hash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final rawCitations = json['citationIds'];
    if (rawCitations is! List || rawCitations.isEmpty) {
      throw const FormatException('citationIds must be a nonempty array');
    }
    final citations = <String>[];
    final unique = <String>{};
    for (final raw in rawCitations) {
      if (raw is! String || raw.trim().isEmpty || !unique.add(raw)) {
        throw const FormatException('citationIds must be unique nonempty IDs');
      }
      citations.add(raw);
    }
    final rawFigures = json['figureIds'];
    if (rawFigures is! List) {
      throw const FormatException('figureIds must be an array');
    }
    final figures = <String>[];
    final uniqueFigures = <String>{};
    for (final raw in rawFigures) {
      if (raw is! String || raw.trim().isEmpty || !uniqueFigures.add(raw)) {
        throw const FormatException('figureIds must be unique nonempty IDs');
      }
      figures.add(raw);
    }
    final sliceId = text('sliceId');
    final rawLesson = json['lessonAstJson'];
    if (rawLesson is! Map<String, Object?>) {
      throw const FormatException('lessonAstJson must be an object');
    }
    final lesson = LessonDocument.fromJson(
      rawLesson,
      sliceId: sliceId,
      citationIds: unique,
      figureIds: uniqueFigures,
    );
    final rawCreatedAt = text('createdAt');
    final createdAt = DateTime.tryParse(rawCreatedAt);
    if (createdAt == null || !createdAt.isUtc || !rawCreatedAt.endsWith('Z')) {
      throw const FormatException(
        'createdAt must be an ISO-8601 UTC timestamp',
      );
    }
    return LessonArtifact._(
      id: text('id'),
      version: version,
      contentHash: hash,
      sliceId: sliceId,
      lesson: lesson,
      citationIds: List.unmodifiable(citations),
      figureIds: List.unmodifiable(figures),
      modelProfile: text('modelProfile'),
      promptVersion: text('promptVersion'),
      createdAt: createdAt,
      rawCreatedAt: rawCreatedAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'sliceId': sliceId,
    'lessonAstJson': lesson.toJson(),
    'citationIds': citationIds.toList(),
    'figureIds': figureIds.toList(),
    'modelProfile': modelProfile,
    'promptVersion': promptVersion,
    'createdAt': rawCreatedAt,
  };
}
