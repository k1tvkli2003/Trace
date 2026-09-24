import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/pdf_contact_sheet.dart';
import 'package:trace_flutter/pdf_page_rasterizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  RenderedPdfPage page(int number, int color) {
    final pixels = Uint8List.fromList(List<int>.filled(4 * 8 * 8, color));
    return RenderedPdfPage(
      pageNumber: number,
      width: 8,
      height: 8,
      pixels: pixels,
      sourceHash: 'a' * 64,
      pixelHash: sha256.convert(pixels).toString(),
      renderProfile: 'test-v1',
    );
  }

  test('composes ordered bounded pages with hash-bound tiles', () async {
    final result = await PdfContactSheetComposer().compose(
      [page(1, 0), page(2, 255), page(3, 127)],
      columns: 2,
    );

    expect(result.width, 512);
    expect(result.height, 832);
    expect(result.pngBytes.length, greaterThan(100));
    expect(result.contentHash, sha256.convert(result.pngBytes).toString());
    expect(result.tiles.map((tile) => tile.pageNumber), [1, 2, 3]);
    expect(result.tiles.every((tile) => tile.width > 0 && tile.height > 0), isTrue);
  });

  test('rejects empty, overlarge, unordered, and mixed-source batches', () async {
    final composer = PdfContactSheetComposer();
    await expectLater(composer.compose(const []), throwsRangeError);
    final pages = List.generate(9, (index) => page(index + 1, index));
    await expectLater(composer.compose(pages), throwsRangeError);
    await expectLater(composer.compose([page(2, 1), page(1, 2)]), throwsFormatException);
    final mixed = RenderedPdfPage(
      pageNumber: 2,
      width: 8,
      height: 8,
      pixels: Uint8List(4 * 8 * 8),
      sourceHash: 'b' * 64,
      pixelHash: sha256.convert(Uint8List(4 * 8 * 8)).toString(),
      renderProfile: 'test-v1',
    );
    await expectLater(composer.compose([page(1, 1), mixed]), throwsFormatException);
  });
}
