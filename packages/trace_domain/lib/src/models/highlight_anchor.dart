import 'source_block.dart';

enum HighlightAnchorStatus {
  attached('attached'),
  detached('detached'),
  unsupported('unsupported');

  const HighlightAnchorStatus(this.wireName);
  final String wireName;
}

/// Reattachable selection identity; offset alone is never sufficient.
final class HighlightAnchor {
  const HighlightAnchor._({
    required this.id,
    required this.version,
    required this.contentHashAtCreation,
    required this.sourceBlockId,
    required this.pageId,
    required this.lessonBlockId,
    required this.quote,
    required this.prefix,
    required this.suffix,
    required this.startOffset,
    required this.endOffset,
    required this.bbox,
    required this.color,
    required this.status,
    required this.rawStatus,
  });

  final String id;
  final int version;
  final String contentHashAtCreation;
  final String sourceBlockId;
  final String pageId;
  final String? lessonBlockId;
  final String quote;
  final String prefix;
  final String suffix;
  final int startOffset;
  final int endOffset;
  final NormalizedBox? bbox;
  final String color;
  final HighlightAnchorStatus status;
  final String rawStatus;

  factory HighlightAnchor.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final version = json['version'];
    final start = json['startOffset'];
    final end = json['endOffset'];
    if (version is! int ||
        version < 1 ||
        start is! int ||
        start < 0 ||
        end is! int ||
        end <= start) {
      throw const FormatException('Invalid highlight version or offsets');
    }
    final hash = text('contentHashAtCreation');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException(
        'contentHashAtCreation must be lowercase SHA-256 hex',
      );
    }
    final rawLessonBlockId = json['lessonBlockId'];
    if (rawLessonBlockId != null &&
        (rawLessonBlockId is! String || rawLessonBlockId.trim().isEmpty)) {
      throw const FormatException(
        'lessonBlockId must be null or nonempty text',
      );
    }
    final rawStatus = text('status');
    final status = HighlightAnchorStatus.values
        .where((candidate) => candidate.wireName == rawStatus)
        .firstOrNull;
    return HighlightAnchor._(
      id: text('id'),
      version: version,
      contentHashAtCreation: hash,
      sourceBlockId: text('sourceBlockId'),
      pageId: text('pageId'),
      lessonBlockId: rawLessonBlockId as String?,
      quote: text('quote'),
      prefix: text('prefix'),
      suffix: text('suffix'),
      startOffset: start,
      endOffset: end,
      bbox: json['bbox'] == null ? null : NormalizedBox.fromJson(json['bbox']),
      color: text('color'),
      status: status ?? HighlightAnchorStatus.unsupported,
      rawStatus: rawStatus,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHashAtCreation': contentHashAtCreation,
    'sourceBlockId': sourceBlockId,
    'pageId': pageId,
    'lessonBlockId': lessonBlockId,
    'quote': quote,
    'prefix': prefix,
    'suffix': suffix,
    'startOffset': startOffset,
    'endOffset': endOffset,
    if (bbox != null) 'bbox': bbox!.toJson(),
    'color': color,
    'status': rawStatus,
  };
}
