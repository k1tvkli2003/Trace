/// Hash-bound identity of an imported source; no file bytes or platform API.
enum SourceDocumentFormat { pdf, markdown, text, image, unsupported }

final class SourceDocument {
  const SourceDocument._({
    required this.id,
    required this.libraryId,
    required this.version,
    required this.sourceHash,
    required this.relativePath,
    required this.mimeType,
    required this.byteSize,
    required this.importVersion,
    required this.format,
    required this.rawFormat,
  });

  final String id;
  final String libraryId;
  final int version;
  final String sourceHash;
  final String relativePath;
  final String mimeType;
  final int byteSize;
  final int importVersion;
  final SourceDocumentFormat format;
  final String rawFormat;

  factory SourceDocument.fromJson(Map<String, Object?> json) {
    String requiredText(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    int requiredInteger(String key, {int minimum = 1}) {
      final value = json[key];
      if (value is! int || value < minimum) {
        throw FormatException('$key must be >= $minimum');
      }
      return value;
    }

    final id = requiredText('id');
    final libraryId = requiredText('libraryId');
    final version = requiredInteger('version');
    final importVersion = requiredInteger('importVersion');
    final byteSize = requiredInteger('byteSize', minimum: 0);
    final mimeType = requiredText('mimeType');
    final rawFormat = requiredText('format');
    final sourceHash = requiredText('sourceHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(sourceHash)) {
      throw const FormatException('sourceHash must be lowercase SHA-256 hex');
    }
    final relativePath = requiredText('relativePath');
    if (relativePath.isEmpty ||
        relativePath.contains('\\') ||
        relativePath.contains(':') ||
        relativePath.contains('\u0000') ||
        relativePath
            .split('/')
            .any(
              (segment) => segment.isEmpty || segment == '.' || segment == '..',
            )) {
      throw const FormatException('relativePath must be a safe relative path');
    }
    return SourceDocument._(
      id: id,
      libraryId: libraryId,
      version: version,
      sourceHash: sourceHash,
      relativePath: relativePath,
      mimeType: mimeType,
      byteSize: byteSize,
      importVersion: importVersion,
      format: switch (rawFormat) {
        'pdf' => SourceDocumentFormat.pdf,
        'markdown' => SourceDocumentFormat.markdown,
        'text' => SourceDocumentFormat.text,
        'image' => SourceDocumentFormat.image,
        _ => SourceDocumentFormat.unsupported,
      },
      rawFormat: rawFormat,
    );
  }

  Map<String, Object> toJson() => {
    'id': id,
    'libraryId': libraryId,
    'version': version,
    'sourceHash': sourceHash,
    'relativePath': relativePath,
    'mimeType': mimeType,
    'byteSize': byteSize,
    'importVersion': importVersion,
    'format': rawFormat,
  };
}
