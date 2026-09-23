/// Source-bound factual reference. Quote is evidence, not generated lesson prose.
final class SourceCitation {
  const SourceCitation._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.sourceBlockId,
    required this.pageId,
    required this.figureId,
    required this.quote,
    required this.locator,
    required this.confidence,
    required this.extractionVersion,
  });

  final String id;
  final int version;
  final String contentHash;
  final String sourceBlockId;
  final String pageId;
  final String? figureId;
  final String quote;
  final String locator;
  final double confidence;
  final String extractionVersion;

  factory SourceCitation.fromJson(Map<String, Object?> json) {
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
    final contentHash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final rawFigureId = json['figureId'];
    if (rawFigureId != null &&
        (rawFigureId is! String || rawFigureId.trim().isEmpty)) {
      throw const FormatException('figureId must be null or nonempty text');
    }
    final confidence = json['confidence'];
    if (confidence is! num ||
        !confidence.isFinite ||
        confidence < 0 ||
        confidence > 1) {
      throw const FormatException('confidence must be between 0 and 1');
    }

    return SourceCitation._(
      id: text('id'),
      version: version,
      contentHash: contentHash,
      sourceBlockId: text('sourceBlockId'),
      pageId: text('pageId'),
      figureId: rawFigureId as String?,
      quote: text('quote'),
      locator: text('locator'),
      confidence: confidence.toDouble(),
      extractionVersion: text('extractionVersion'),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'sourceBlockId': sourceBlockId,
    'pageId': pageId,
    'figureId': figureId,
    'quote': quote,
    'locator': locator,
    'confidence': confidence,
    'extractionVersion': extractionVersion,
  };
}
