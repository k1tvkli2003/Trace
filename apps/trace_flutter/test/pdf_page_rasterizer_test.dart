import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/pdf_page_rasterizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => Directory.systemTemp.path,
        );
  });

  test(
    'PDF page renders from original bytes with pixel and source hash',
    () async {
      final bytes = await File('test/fixtures/dummy.pdf').readAsBytes();
      final raster = await PdfPageRasterizer().renderPage(
        bytes,
        pageNumber: 1,
        width: 512,
      );
      expect(raster.width, 512);
      expect(raster.height, greaterThan(0));
      expect(raster.pixels.length, raster.width * raster.height * 4);
      expect(raster.sourceHash, sha256.convert(bytes).toString());
      expect(raster.pixelHash, sha256.convert(raster.pixels).toString());
      expect(raster.pixels.toSet().length, greaterThan(1));
    },
  );

  test('invalid PDF page and dimensions reject before rendering', () async {
    final bytes = await File('test/fixtures/dummy.pdf').readAsBytes();
    await expectLater(
      PdfPageRasterizer().renderPage(bytes, pageNumber: 0, width: 512),
      throwsRangeError,
    );
    await expectLater(
      PdfPageRasterizer().renderPage(bytes, pageNumber: 2, width: 512),
      throwsRangeError,
    );
    await expectLater(
      PdfPageRasterizer().renderPage(bytes, pageNumber: 1, width: 5000),
      throwsRangeError,
    );
  });
}
