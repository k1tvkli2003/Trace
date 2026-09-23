import 'source_block.dart';

/// Crop-backed figure evidence kept separate from generated lesson prose.
enum FigureReviewStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  unsupported('unsupported');

  const FigureReviewStatus(this.wireName);

  final String wireName;
}

final class FigureAsset {
  const FigureAsset._({
    required this.id,
    required this.version,
    required this.assetHash,
    required this.sourceHash,
    required this.pagePixelHash,
    required this.pageId,
    required this.bbox,
    required this.widthPx,
    required this.heightPx,
    required this.caption,
    required this.altText,
    required this.reviewStatus,
    required this.rawReviewStatus,
  });

  final String id;
  final int version;
  final String assetHash;
  final String sourceHash;
  final String pagePixelHash;
  final String pageId;
  final NormalizedBox bbox;
  final int widthPx;
  final int heightPx;
  final String caption;
  final String altText;
  final FigureReviewStatus reviewStatus;
  final String rawReviewStatus;

  factory FigureAsset.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    int positiveInteger(String key) {
      final value = json[key];
      if (value is! int || value < 1) {
        throw FormatException('$key must be a positive integer');
      }
      return value;
    }

    String hash(String key) {
      final value = text(key);
      if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(value)) {
        throw FormatException('$key must be lowercase SHA-256 hex');
      }
      return value;
    }

    final version = positiveInteger('version');
    final rawStatus = text('reviewStatus');
    final status = FigureReviewStatus.values
        .where((candidate) => candidate.wireName == rawStatus)
        .firstOrNull;

    return FigureAsset._(
      id: text('id'),
      version: version,
      assetHash: hash('assetHash'),
      sourceHash: hash('sourceHash'),
      pagePixelHash: hash('pagePixelHash'),
      pageId: text('pageId'),
      bbox: NormalizedBox.fromJson(json['bbox']),
      widthPx: positiveInteger('widthPx'),
      heightPx: positiveInteger('heightPx'),
      caption: text('caption'),
      altText: text('altText'),
      reviewStatus: status ?? FigureReviewStatus.unsupported,
      rawReviewStatus: rawStatus,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'assetHash': assetHash,
    'sourceHash': sourceHash,
    'pagePixelHash': pagePixelHash,
    'pageId': pageId,
    'bbox': bbox.toJson(),
    'widthPx': widthPx,
    'heightPx': heightPx,
    'caption': caption,
    'altText': altText,
    'reviewStatus': rawReviewStatus,
  };
}
