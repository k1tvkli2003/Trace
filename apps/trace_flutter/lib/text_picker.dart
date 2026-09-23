import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// User selection only. Database validation and hash ownership live below UI.
final class PickedTextSource {
  const PickedTextSource({required this.name, required this.bytes});
  final String name;
  final Uint8List bytes;
}

Future<PickedTextSource?> pickTextSource() async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['txt', 'md', 'markdown'],
    dialogTitle: 'Import text source',
  );
  if (file == null) return null;
  final length = await file.length();
  if (length == null || length == 0 || length > 8 * 1024 * 1024) {
    throw const FormatException('Text source size must be 1..8388608 bytes');
  }
  final bytes = await file.readAsBytes();
  return PickedTextSource(name: file.name, bytes: bytes);
}
