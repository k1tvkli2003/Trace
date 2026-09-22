/// Rendered page identity. Pixel hash binds the exact raster, not PDF text.
enum SourcePageVisionStatus {
  notStarted,
  pending,
  complete,
  failed,
  unsupported,
}

final class SourcePage {
  const SourcePage._({
    required this.id,
    required this.documentId,
    required this.version,
    required this.pageNumber,
    required this.pixelHash,
    required this.renderProfile,
    required this.thumbnailPath,
    required this.visionStatus,
    required this.rawVisionStatus,
  });

  final String id;
  final String documentId;
  final int version;
  final int pageNumber;
  final String pixelHash;
  final String renderProfile;
  final String thumbnailPath;
  final SourcePageVisionStatus visionStatus;
  final String rawVisionStatus;

  factory SourcePage.fromJson(Map<String, Object?> json) {
    String requiredText(String key) {
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

    final id = requiredText('id');
    final documentId = requiredText('documentId');
    final version = positiveInteger('version');
    final pageNumber = positiveInteger('pageNumber');
    final pixelHash = requiredText('pixelHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(pixelHash)) {
      throw const FormatException('pixelHash must be lowercase SHA-256 hex');
    }
    final renderProfile = requiredText('renderProfile');
    final thumbnailPath = requiredText('thumbnailPath');
    if (thumbnailPath.contains('\\') ||
        thumbnailPath.contains(':') ||
        thumbnailPath.contains('\u0000') ||
        thumbnailPath
            .split('/')
            .any(
              (segment) => segment.isEmpty || segment == '.' || segment == '..',
            )) {
      throw const FormatException('thumbnailPath must be a safe relative path');
    }
    final rawStatus = requiredText('visionStatus');
    return SourcePage._(
      id: id,
      documentId: documentId,
      version: version,
      pageNumber: pageNumber,
      pixelHash: pixelHash,
      renderProfile: renderProfile,
      thumbnailPath: thumbnailPath,
      visionStatus: switch (rawStatus) {
        'not_started' => SourcePageVisionStatus.notStarted,
        'pending' => SourcePageVisionStatus.pending,
        'complete' => SourcePageVisionStatus.complete,
        'failed' => SourcePageVisionStatus.failed,
        _ => SourcePageVisionStatus.unsupported,
      },
      rawVisionStatus: rawStatus,
    );
  }

  Map<String, Object> toJson() => {
    'id': id,
    'documentId': documentId,
    'version': version,
    'pageNumber': pageNumber,
    'pixelHash': pixelHash,
    'renderProfile': renderProfile,
    'thumbnailPath': thumbnailPath,
    'visionStatus': rawVisionStatus,
  };
}
