import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:trace_data/trace_data.dart';

/// Selection boundary. Repository validates signature, path and hash.
final class PickedPdfSource {
  const PickedPdfSource({required this.name, required this.bytes});
  final String name;
  final Uint8List bytes;
}

Future<PickedPdfSource?> pickPdfSource() async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    dialogTitle: 'Import PDF original',
  );
  if (file == null) return null;
  final length = await file.length();
  if (length == null ||
      length == 0 ||
      length > LocalPdfSourceRepository.maxBytes) {
    throw const FormatException('PDF size must be 1..16777216 bytes');
  }
  return PickedPdfSource(name: file.name, bytes: await file.readAsBytes());
}
