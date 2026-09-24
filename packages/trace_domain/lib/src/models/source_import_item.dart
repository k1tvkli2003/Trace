import 'dart:typed_data';

/// One file-like item crossing the platform picker/import boundary.
///
/// `relativePath` is logical metadata. It must never be used as a host path
/// without separate adapter validation.
final class SourceImportItem {
  const SourceImportItem({
    required this.relativePath,
    required this.bytes,
  });

  final String relativePath;
  final Uint8List bytes;
}
