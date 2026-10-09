import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';

import 'pdf_page_rasterizer.dart';

/// Encodes one rendered PDF page to PNG bytes. Fail-closed on identity.
///
/// Verifies BGRA buffer length and pixel hash before encoding so a tampered
/// or truncated raster never reaches the vision gateway.
Future<Uint8List> encodeSinglePagePng(RenderedPdfPage page) async {
  if (page.pixels.length != page.width * page.height * 4) {
    throw StateError('Rendered page buffer has invalid dimensions');
  }
  if (sha256.convert(page.pixels).toString() != page.pixelHash) {
    throw StateError('Rendered page identity mismatch; failing closed');
  }
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    page.pixels,
    page.width,
    page.height,
    ui.PixelFormat.bgra8888,
    completer.complete,
  );
  final image = await completer.future;
  try {
    final encoded = await image.toByteData(format: ui.ImageByteFormat.png);
    if (encoded == null || encoded.lengthInBytes < 16) {
      throw StateError('Single page PNG encoding failed');
    }
    return Uint8List.fromList(
      encoded.buffer.asUint8List(
        encoded.offsetInBytes,
        encoded.lengthInBytes,
      ),
    );
  } finally {
    image.dispose();
  }
}
