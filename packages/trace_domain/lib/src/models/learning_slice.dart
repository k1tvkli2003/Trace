/// Planned reading unit, bound to ordered source blocks; no model output here.
final class LearningSlice {
  const LearningSlice._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.nodeId,
    required this.order,
    required this.sourceBlockIds,
    required this.pageIds,
    required this.conceptIds,
    required this.estimatedEffort,
    required this.boundaryReason,
    required this.nextVisionRequiredAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String nodeId;
  final int order;
  final List<String> sourceBlockIds;
  final List<String> pageIds;
  final List<String> conceptIds;
  final int estimatedEffort;
  final String boundaryReason;
  final int? nextVisionRequiredAt;

  factory LearningSlice.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    int integer(String key, int minimum) {
      final value = json[key];
      if (value is! int || value < minimum) {
        throw FormatException('$key must be >= $minimum');
      }
      return value;
    }

    List<String> ids(String key, {bool required = false}) {
      final value = json[key];
      if (value is! List || (required && value.isEmpty)) {
        throw FormatException('$key must be a list of IDs');
      }
      final result = <String>[];
      final seen = <String>{};
      for (final element in value) {
        if (element is! String ||
            element.trim().isEmpty ||
            !seen.add(element)) {
          throw FormatException('$key must contain unique nonempty IDs');
        }
        result.add(element);
      }
      return List.unmodifiable(result);
    }

    final contentHash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final nextPage = json['nextVisionRequiredAt'];
    if (nextPage != null && (nextPage is! int || nextPage < 1)) {
      throw const FormatException('nextVisionRequiredAt must be a page number');
    }
    return LearningSlice._(
      id: text('id'),
      version: integer('version', 1),
      contentHash: contentHash,
      nodeId: text('nodeId'),
      order: integer('order', 0),
      sourceBlockIds: ids('sourceBlockIds', required: true),
      pageIds: ids('pageIds'),
      conceptIds: ids('conceptIds'),
      estimatedEffort: integer('estimatedEffort', 0),
      boundaryReason: text('boundaryReason'),
      nextVisionRequiredAt: nextPage as int?,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'nodeId': nodeId,
    'order': order,
    'sourceBlockIds': sourceBlockIds.toList(),
    'pageIds': pageIds.toList(),
    'conceptIds': conceptIds.toList(),
    'estimatedEffort': estimatedEffort,
    'boundaryReason': boundaryReason,
    'nextVisionRequiredAt': nextVisionRequiredAt,
  };
}
