import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/pdf_single_page_png.dart';
import 'package:trace_flutter/pdf_page_rasterizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  RenderedPdfPage page() {
    final pixels = Uint8List.fromList(
      List<int>.generate(4 * 8 * 8, (i) => i % 256),
    );
    return RenderedPdfPage(
      pageNumber: 1,
      width: 8,
      height: 8,
      pixels: pixels,
      sourceHash: 'a' * 64,
      pixelHash: sha256.convert(pixels).toString(),
      renderProfile: 'test-v1',
    );
  }

  test('encodes single rendered page to PNG bytes', () async {
    final png = await encodeSinglePagePng(page());
    expect(png.length, greaterThan(16));
    expect(png[0], 0x89);
    expect(png[1], 0x50);
    expect(png[2], 0x4E);
    expect(png[3], 0x47);
    expect(sha256.convert(png).toString().length, 64);
  });

  test('rejects tampered pixel identity before encoding', () async {
    final tampered = RenderedPdfPage(
      pageNumber: 1,
      width: 8,
      height: 8,
      pixels: Uint8List.fromList(List<int>.filled(4 * 8 * 8, 0)),
      sourceHash: 'a' * 64,
      pixelHash: 'b' * 64,
      renderProfile: 'test-v1',
    );
    await expectLater(encodeSinglePagePng(tampered), throwsStateError);
  });
}
