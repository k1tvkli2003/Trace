import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pdfrx/pdfrx.dart';

/// BGRA8888 raster is evidence. No PDF text, OCR, or annotations are read.
final class RenderedPdfPage {
  const RenderedPdfPage({
    required this.pageNumber,
    required this.width,
    required this.height,
    required this.pixels,
    required this.sourceHash,
    required this.pixelHash,
    required this.renderProfile,
  });

  final int pageNumber;
  final int width;
  final int height;
  final Uint8List pixels;
  final String sourceHash;
  final String pixelHash;
  final String renderProfile;
}

final class PdfPageRasterizer {
  Future<RenderedPdfPage> renderPage(
    Uint8List source, {
    required int pageNumber,
    required int width,
  }) async {
    if (pageNumber < 1) throw RangeError.value(pageNumber, 'pageNumber');
    if (width < 64 || width > 2048) throw RangeError.value(width, 'width');
    if (source.isEmpty) throw const FormatException('Empty PDF source');
    await pdfrxFlutterInitialize();
    final sourceHash = sha256.convert(source).toString();
    final document = await PdfDocument.openData(
      Uint8List.fromList(source),
      sourceName: sourceHash,
    );
    try {
      if (pageNumber > document.pages.length) {
        throw RangeError.range(
          pageNumber,
          1,
          document.pages.length,
          'pageNumber',
        );
      }
      final page = document.pages[pageNumber - 1];
      final scale = width / page.width;
      final height = (page.height * scale).round();
      if (height < 1 || height > 4096) {
        throw RangeError.value(height, 'renderedHeight');
      }
      final image = await page.render(
        fullWidth: width.toDouble(),
        fullHeight: height.toDouble(),
      );
      if (image == null) throw StateError('PDF page render returned no image');
      try {
        final pixels = Uint8List.fromList(image.pixels);
        if (pixels.length != image.width * image.height * 4) {
          throw StateError('Rendered BGRA buffer has invalid dimensions');
        }
        return RenderedPdfPage(
          pageNumber: pageNumber,
          width: image.width,
          height: image.height,
          pixels: pixels,
          sourceHash: sourceHash,
          pixelHash: sha256.convert(pixels).toString(),
          renderProfile: 'pdfium-bgra-white-annotations-v1-width$width',
        );
      } finally {
        image.dispose();
      }
    } finally {
      await document.dispose();
    }
  }
}
