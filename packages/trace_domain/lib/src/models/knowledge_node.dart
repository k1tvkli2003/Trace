enum KnowledgeNodeKind {
  part('part'),
  chapter('chapter'),
  section('section'),
  concept('concept'),
  unsupported('unsupported');

  const KnowledgeNodeKind(this.wireName);
  final String wireName;
}

final class SourcePageRange {
  const SourcePageRange._(this.startPage, this.endPage);

  final int startPage;
  final int endPage;

  factory SourcePageRange.fromJson(Object? value) {
    if (value is! Map<String, Object?>) {
      throw const FormatException('sourceRange must be an object');
    }
    final start = value['startPage'];
    final end = value['endPage'];
    if (start is! int || end is! int || start < 1 || end < start) {
      throw const FormatException('sourceRange must contain ascending pages');
    }
    return SourcePageRange._(start, end);
  }

  Map<String, Object> toJson() => {'startPage': startPage, 'endPage': endPage};
}

/// Proposed or user-approved structure; no implicit citation or extraction.
final class KnowledgeNode {
  const KnowledgeNode._({
    required this.id,
    required this.parentId,
    required this.version,
    required this.contentHash,
    required this.order,
    required this.kind,
    required this.rawKind,
    required this.title,
    required this.sourceRange,
    required this.confidence,
    required this.userOverride,
  });

  final String id;
  final String? parentId;
  final int version;
  final String contentHash;
  final int order;
  final KnowledgeNodeKind kind;
  final String rawKind;
  final String title;
  final SourcePageRange? sourceRange;
  final double confidence;
  final bool userOverride;

  factory KnowledgeNode.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final rawParentId = json['parentId'];
    if (rawParentId != null &&
        (rawParentId is! String || rawParentId.trim().isEmpty)) {
      throw const FormatException('parentId must be null or nonempty text');
    }
    final version = json['version'];
    final order = json['order'];
    final confidence = json['confidence'];
    if (version is! int || version < 1 || order is! int || order < 0) {
      throw const FormatException('Invalid node version or order');
    }
    if (confidence is! num ||
        !confidence.isFinite ||
        confidence < 0 ||
        confidence > 1) {
      throw const FormatException('confidence must be between 0 and 1');
    }
    final userOverride = json['userOverride'];
    if (userOverride is! bool) {
      throw const FormatException('userOverride must be boolean');
    }
    final contentHash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final id = text('id');
    if (rawParentId == id) {
      throw const FormatException('Node cannot be its own parent');
    }
    final rawKind = text('kind');
    return KnowledgeNode._(
      id: id,
      parentId: rawParentId as String?,
      version: version,
      contentHash: contentHash,
      order: order,
      kind:
          KnowledgeNodeKind.values
              .where((candidate) => candidate.wireName == rawKind)
              .firstOrNull ??
          KnowledgeNodeKind.unsupported,
      rawKind: rawKind,
      title: text('title'),
      sourceRange: json['sourceRange'] == null
          ? null
          : SourcePageRange.fromJson(json['sourceRange']),
      confidence: confidence.toDouble(),
      userOverride: userOverride,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'parentId': parentId,
    'version': version,
    'contentHash': contentHash,
    'order': order,
    'kind': rawKind,
    'title': title,
    'sourceRange': sourceRange?.toJson(),
    'confidence': confidence,
    'userOverride': userOverride,
  };
}
