import 'dart:convert';

/// Cache identity for one page extraction. No model calls or cache storage.
final class PageVisionCacheKey {
  const PageVisionCacheKey._({
    required this.sourceHash,
    required this.pageNumber,
    required this.renderProfile,
    required this.visionModelProfile,
    required this.promptVersion,
  });

  final String sourceHash;
  final int pageNumber;
  final String renderProfile;
  final String visionModelProfile;
  final String promptVersion;

  factory PageVisionCacheKey.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final sourceHash = text('sourceHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(sourceHash)) {
      throw const FormatException('sourceHash must be lowercase SHA-256 hex');
    }
    final pageNumber = json['pageNumber'];
    if (pageNumber is! int || pageNumber < 1) {
      throw const FormatException('pageNumber must be a positive integer');
    }
    return PageVisionCacheKey._(
      sourceHash: sourceHash,
      pageNumber: pageNumber,
      renderProfile: text('renderProfile'),
      visionModelProfile: text('visionModelProfile'),
      promptVersion: text('promptVersion'),
    );
  }

  Map<String, Object> toJson() => {
    'sourceHash': sourceHash,
    'pageNumber': pageNumber,
    'renderProfile': renderProfile,
    'visionModelProfile': visionModelProfile,
    'promptVersion': promptVersion,
  };

  /// Structured encoding avoids delimiter collisions between profiles.
  String get value => jsonEncode([
    sourceHash,
    pageNumber,
    renderProfile,
    visionModelProfile,
    promptVersion,
  ]);
}
