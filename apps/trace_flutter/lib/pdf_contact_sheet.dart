import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/painting.dart';

import 'pdf_page_rasterizer.dart';

/// Contact sheets are navigation evidence, never transcribed PDF content.
final class ContactSheetTile {
  const ContactSheetTile({
    required this.pageNumber,
    required this.pixelHash,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final int pageNumber;
  final String pixelHash;
  final int left;
  final int top;
  final int width;
  final int height;
}

final class PdfContactSheet {
  const PdfContactSheet({
    required this.pngBytes,
    required this.contentHash,
    required this.sourceHash,
    required this.renderProfile,
    required this.width,
    required this.height,
    required this.tiles,
  });

  final Uint8List pngBytes;
  final String contentHash;
  final String sourceHash;
  final String renderProfile;
  final int width;
  final int height;
  final List<ContactSheetTile> tiles;
}

/// One bounded grid. Original page pixels are scaled to fit, never cropped.
/// RTL affects label placement; digits remain ASCII for Trace's UI policy.
final class PdfContactSheetComposer {
  static const int maxTiles = 8;
  static const int cellWidth = 256;
  static const int pageHeight = 384;
  static const int labelHeight = 32;

  Future<PdfContactSheet> compose(
    List<RenderedPdfPage> pages, {
    int columns = 2,
    bool rtlLabels = true,
  }) async {
    if (pages.isEmpty || pages.length > maxTiles) {
      throw RangeError.range(pages.length, 1, maxTiles, 'pages.length');
    }
    if (columns < 1 || columns > 4) {
      throw RangeError.range(columns, 1, 4, 'columns');
    }
    final sourceHash = pages.first.sourceHash;
    final profile = pages.first.renderProfile;
    var lastPage = 0;
    for (final page in pages) {
      if (page.pageNumber <= lastPage ||
          page.sourceHash != sourceHash ||
          page.renderProfile != profile ||
          page.width < 1 ||
          page.height < 1 ||
          page.width > 2048 ||
          page.height > 4096 ||
          page.pixels.length != page.width * page.height * 4 ||
          sha256.convert(page.pixels).toString() != page.pixelHash) {
        throw const FormatException('Unordered, mixed, or invalid page raster');
      }
      lastPage = page.pageNumber;
    }

    final actualColumns = columns < pages.length ? columns : pages.length;
    final rows = (pages.length + actualColumns - 1) ~/ actualColumns;
    final width = cellWidth * actualColumns;
    final height = (pageHeight + labelHeight) * rows;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawColor(const ui.Color(0xffffffff), ui.BlendMode.src);
    final tiles = <ContactSheetTile>[];
    try {
      for (var index = 0; index < pages.length; index++) {
        final page = pages[index];
        final col = index % actualColumns;
        final row = index ~/ actualColumns;
        final cellX = col * cellWidth;
        final cellY = row * (pageHeight + labelHeight);
        final scale = [cellWidth / page.width, pageHeight / page.height]
            .reduce((a, b) => a < b ? a : b);
        final drawnWidth = (page.width * scale).floor();
        final drawnHeight = (page.height * scale).floor();
        final left = cellX + (cellWidth - drawnWidth) ~/ 2;
        final top = cellY + (pageHeight - drawnHeight) ~/ 2;
        final image = await _imageFromBgra(page);
        try {
          canvas.drawImageRect(
            image,
            ui.Rect.fromLTWH(0, 0, page.width.toDouble(), page.height.toDouble()),
            ui.Rect.fromLTWH(left.toDouble(), top.toDouble(),
                drawnWidth.toDouble(), drawnHeight.toDouble()),
            ui.Paint()..filterQuality = ui.FilterQuality.medium,
          );
        } finally {
          image.dispose();
        }
        final label = TextPainter(
          text: TextSpan(
            text: rtlLabels ? 'صفحه ${page.pageNumber}' : 'Page ${page.pageNumber}',
            style: const TextStyle(fontSize: 16, color: Color(0xff111111)),
          ),
          textDirection: rtlLabels ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          maxLines: 1,
        )..layout(maxWidth: cellWidth - 16);
        label.paint(
          canvas,
          ui.Offset(
            rtlLabels ? (cellX + cellWidth - 8 - label.width) : (cellX + 8),
            cellY + pageHeight + (labelHeight - label.height) / 2,
          ),
        );
        label.dispose();
        tiles.add(ContactSheetTile(
          pageNumber: page.pageNumber,
          pixelHash: page.pixelHash,
          left: left,
          top: top,
          width: drawnWidth,
          height: drawnHeight,
        ));
      }
      final picture = recorder.endRecording();
      final sheet = await picture.toImage(width, height);
      picture.dispose();
      try {
        final encoded = await sheet.toByteData(format: ui.ImageByteFormat.png);
        if (encoded == null) throw StateError('Contact sheet encoding failed');
        final png = encoded.buffer.asUint8List(
          encoded.offsetInBytes, encoded.lengthInBytes,
        );
        return PdfContactSheet(
          pngBytes: Uint8List.fromList(png),
          contentHash: sha256.convert(png).toString(),
          sourceHash: sourceHash,
          renderProfile: profile,
          width: width,
          height: height,
          tiles: List.unmodifiable(tiles),
        );
      } finally {
        sheet.dispose();
      }
    } catch (_) {
      // Recording is abandoned on failure; a fresh composer can retry.
      rethrow;
    }
  }

  Future<ui.Image> _imageFromBgra(RenderedPdfPage page) {
    final result = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      page.pixels,
      page.width,
      page.height,
      ui.PixelFormat.bgra8888,
      result.complete,
    );
    return result.future;
  }
}
