/// Hash-bound reading-order unit from one rendered source page.
enum SourceBlockKind {
  heading('heading'),
  paragraph('paragraph'),
  list('list'),
  table('table'),
  formula('formula'),
  caption('caption'),
  footnote('footnote'),
  figure('figure'),
  unsupported('unsupported');

  const SourceBlockKind(this.wireName);

  final String wireName;
}

final class NormalizedBox {
  const NormalizedBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  factory NormalizedBox.fromJson(Object? value) {
    if (value is! Map<String, Object?>) {
      throw const FormatException('bbox must be an object');
    }

    double coordinate(String key) {
      final raw = value[key];
      if (raw is! num || !raw.isFinite || raw < 0 || raw > 1) {
        throw FormatException('bbox.$key must be between 0 and 1');
      }
      return raw.toDouble();
    }

    final box = NormalizedBox(
      x: coordinate('x'),
      y: coordinate('y'),
      width: coordinate('w'),
      height: coordinate('h'),
    );
    if (box.width <= 0 || box.height <= 0) {
      throw const FormatException('bbox must have positive area');
    }
    if (box.x + box.width > 1 || box.y + box.height > 1) {
      throw const FormatException('bbox must remain inside page bounds');
    }
    return box;
  }

  Map<String, Object> toJson() => {'x': x, 'y': y, 'w': width, 'h': height};
}

final class SourceBlock {
  const SourceBlock._({
    required this.id,
    required this.documentId,
    required this.pageId,
    required this.version,
    required this.sourceHash,
    required this.order,
    required this.kind,
    required this.rawKind,
    required this.rawText,
    required this.normalizedText,
    required this.bbox,
  });

  final String id;
  final String documentId;
  final String pageId;
  final int version;
  final String sourceHash;
  final int order;
  final SourceBlockKind kind;
  final String rawKind;
  final String rawText;
  final String normalizedText;
  final NormalizedBox? bbox;

  factory SourceBlock.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    String maybeText(String key) {
      final value = json[key];
      if (value is! String) {
        throw FormatException('$key must be text');
      }
      return value;
    }

    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be a positive integer');
    }
    final order = json['order'];
    if (order is! int || order < 0) {
      throw const FormatException('order must be a nonnegative integer');
    }
    final sourceHash = text('sourceHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(sourceHash)) {
      throw const FormatException('sourceHash must be lowercase SHA-256 hex');
    }
    final rawKind = text('kind');
    final kind = SourceBlockKind.values
        .where((candidate) => candidate.wireName == rawKind)
        .firstOrNull;
    final safeKind = kind ?? SourceBlockKind.unsupported;
    final rawBbox = json['bbox'];

    return SourceBlock._(
      id: text('id'),
      documentId: text('documentId'),
      pageId: text('pageId'),
      version: version,
      sourceHash: sourceHash,
      order: order,
      kind: safeKind,
      rawKind: rawKind,
      rawText: maybeText('rawText'),
      normalizedText: maybeText('normalizedText'),
      bbox: rawBbox == null ? null : NormalizedBox.fromJson(rawBbox),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'documentId': documentId,
    'pageId': pageId,
    'version': version,
    'sourceHash': sourceHash,
    'order': order,
    'kind': rawKind,
    'rawText': rawText,
    'normalizedText': normalizedText,
    if (bbox != null) 'bbox': bbox!.toJson(),
  };
}
