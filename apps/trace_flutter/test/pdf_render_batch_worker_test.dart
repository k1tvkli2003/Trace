import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/pdf_page_rasterizer.dart';
import 'package:trace_flutter/pdf_render_batch_worker.dart';

final class _FakeRasterizer implements PdfRenderRasterizer {
  _FakeRasterizer(this.sourceBytes);

  final Uint8List sourceBytes;
  final List<int> requestedPages = <int>[];

  @override
  Future<RenderedPdfPage> renderPage(
    Uint8List source, {
    required int pageNumber,
    required int width,
  }) async {
    requestedPages.add(pageNumber);
    final sourceHash = sha256.convert(source).toString();
    final pixels = Uint8List.fromList(
      List<int>.generate(4 * 8 * 4, (i) => (i + pageNumber) % 256),
    );
    return RenderedPdfPage(
      pageNumber: pageNumber,
      width: 8,
      height: 4,
      pixels: pixels,
      sourceHash: sourceHash,
      pixelHash: sha256.convert(pixels).toString(),
      renderProfile: 'pdfium-bgra-white-annotations-v1-width$width',
    );
  }
}

final class _CollectingSink implements PdfRenderSink {
  final List<RenderedPdfPage> pages = <RenderedPdfPage>[];
  final List<String> stableIds = <String>[];

  @override
  Future<void> emit(RenderedPdfPage page, String stablePageId) async {
    pages.add(page);
    stableIds.add(stablePageId);
  }
}

Uint8List _bytes(String seed) =>
    Uint8List.fromList('$seed-contents'.codeUnits);

String _sourceHash(Uint8List bytes) => sha256.convert(bytes).toString();

PdfRenderBatchWorker _worker(_FakeRasterizer r, _CollectingSink s) =>
    PdfRenderBatchWorker(rasterizer: r, sink: s);

void main() {
  test('rejects batches larger than 8 pages', () async {
    final source = _bytes('a');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: _sourceHash(source),
        pageNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
        width: 128,
      ),
      throwsArgumentError,
    );
    expect(sink.pages, isEmpty);
    expect(raster.requestedPages, isEmpty);
  });

  test('rejects unordered and duplicate page numbers', () async {
    final source = _bytes('b');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: _sourceHash(source),
        pageNumbers: const [2, 1],
        width: 128,
      ),
      throwsArgumentError,
    );
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: _sourceHash(source),
        pageNumbers: const [1, 1],
        width: 128,
      ),
      throwsArgumentError,
    );
    expect(raster.requestedPages, isEmpty);
  });

  test('renders pages in order with stable deterministic page ids',
      () async {
    final source = _bytes('c');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    final result = await _worker(raster, sink).run(
      source,
      expectedSourceHash: _sourceHash(source),
      pageNumbers: const [1, 2, 3],
      width: 128,
    );

    expect(raster.requestedPages, const [1, 2, 3]);
    expect(sink.pages.map((p) => p.pageNumber), const [1, 2, 3]);
    expect(result.completedPageNumbers, const [1, 2, 3]);
    expect(result.cancelled, isFalse);
    for (var i = 0; i < 3; i++) {
      final page = sink.pages[i];
      expect(page.sourceHash, _sourceHash(source));
      expect(
        sink.stableIds[i],
        stablePdfPageId(
          sourceHash: page.sourceHash,
          pageNumber: page.pageNumber,
          renderProfile: page.renderProfile,
        ),
      );
      // Identity immutable across repeat run.
      expect(
        sink.stableIds[i],
        stablePdfPageId(
          sourceHash: page.sourceHash,
          pageNumber: page.pageNumber,
          renderProfile: page.renderProfile,
        ),
      );
    }
    expect(sink.stableIds.toSet().length, 3);
    expect(sink.stableIds[0], isNot(sink.stableIds[1]));
    expect(
      stablePdfPageId(
        sourceHash: _sourceHash(source),
        pageNumber: 1,
        renderProfile: 'pdfium-bgra-white-annotations-v1-width256',
      ),
      isNot(sink.stableIds[0]),
    );
  });

  test('allows exactly 8 pages', () async {
    final source = _bytes('eight');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    final result = await _worker(raster, sink).run(
      source,
      expectedSourceHash: _sourceHash(source),
      pageNumbers: const [1, 2, 3, 4, 5, 6, 7, 8],
      width: 128,
    );
    expect(result.completedPageNumbers, const [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(raster.requestedPages, hasLength(8));
  });

  test('checkpoint manifest round-trips and resume skips completed',
      () async {
    final source = _bytes('d');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    final first = await _worker(raster, sink).run(
      source,
      expectedSourceHash: _sourceHash(source),
      pageNumbers: const [1, 2],
      width: 128,
    );
    final manifest = first.checkpoint.toJson();
    final restored = PdfRenderCheckpoint.fromJson(manifest);
    expect(restored.completedPageNumbers, const [1, 2]);

    final raster2 = _FakeRasterizer(source);
    final sink2 = _CollectingSink();
    final second = await PdfRenderBatchWorker(
      rasterizer: raster2,
      sink: sink2,
    ).run(
      source,
      expectedSourceHash: _sourceHash(source),
      pageNumbers: const [1, 2, 3],
      width: 128,
      resumeFrom: restored,
    );
    expect(raster2.requestedPages, const [3]);
    expect(
      sink2.pages.map((p) => p.pageNumber),
      const [3],
    );
    expect(second.completedPageNumbers, const [1, 2, 3]);
    expect(
      second.stablePageIds[1],
      stablePdfPageId(
        sourceHash: _sourceHash(source),
        pageNumber: 1,
        renderProfile: 'pdfium-bgra-white-annotations-v1-width128',
      ),
    );
  });

  test('rejects forged checkpoint identity and pages outside batch',
      () async {
    final source = _bytes('forged');
    final hash = _sourceHash(source);
    const profile = 'pdfium-bgra-white-annotations-v1-width128';
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    final forgedId = PdfRenderCheckpoint(
      sourceHash: hash,
      renderProfile: profile,
      completedPageNumbers: const [1],
      stablePageIds: const {1: 'forged'},
      pixelHashes: {1: 'a' * 64},
    );
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: hash,
        pageNumbers: const [1, 2],
        width: 128,
        resumeFrom: forgedId,
      ),
      throwsFormatException,
    );
    final outside = PdfRenderCheckpoint(
      sourceHash: hash,
      renderProfile: profile,
      completedPageNumbers: const [9],
      stablePageIds: {
        9: stablePdfPageId(
          sourceHash: hash,
          pageNumber: 9,
          renderProfile: profile,
        ),
      },
      pixelHashes: {9: 'b' * 64},
    );
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: hash,
        pageNumbers: const [1, 2],
        width: 128,
        resumeFrom: outside,
      ),
      throwsFormatException,
    );
    expect(raster.requestedPages, isEmpty);
    expect(sink.pages, isEmpty);
  });

  test('cancel requested at page boundary stops before next page',
      () async {
    final source = _bytes('e');
    final raster = _FakeRasterizer(source);
    final cancel = PdfRenderCancel();
    var emits = 0;
    final stoppingSink = _CancellingSink(cancel, () => emits++);
    final result = await PdfRenderBatchWorker(
      rasterizer: raster,
      sink: stoppingSink,
    ).run(
      source,
      expectedSourceHash: _sourceHash(source),
      pageNumbers: const [1, 2, 3],
      width: 128,
      cancel: cancel,
    );
    expect(result.cancelled, isTrue);
    expect(emits, 1);
    expect(result.completedPageNumbers, const [1]);
    expect(raster.requestedPages, const [1]);
  });

  test('fails closed on source hash mismatch without emitting', () async {
    final source = _bytes('f');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: 'deadbeef',
        pageNumbers: const [1],
        width: 128,
      ),
      throwsStateError,
    );
    expect(sink.pages, isEmpty);
    expect(raster.requestedPages, isEmpty);
  });

  test('resume with mismatched source hash or profile fails closed',
      () async {
    final source = _bytes('g');
    final raster = _FakeRasterizer(source);
    final sink = _CollectingSink();
    final otherHash =
        _sourceHash(Uint8List.fromList('other'.codeUnits));
    final badCheckpoint = PdfRenderCheckpoint(
      sourceHash: otherHash,
      renderProfile: 'pdfium-bgra-white-annotations-v1-width128',
      completedPageNumbers: const [1],
      stablePageIds: const {1: 'x'},
      pixelHashes: const {1: 'y'},
    );
    await expectLater(
      _worker(raster, sink).run(
        source,
        expectedSourceHash: _sourceHash(source),
        pageNumbers: const [1, 2],
        width: 128,
        resumeFrom: badCheckpoint,
      ),
      throwsStateError,
    );
    expect(raster.requestedPages, isEmpty);
    expect(sink.pages, isEmpty);
  });

  test('renders dummy.pdf first page through real rasterizer', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.path,
    );
    final bytes = await File('test/fixtures/dummy.pdf').readAsBytes();
    final sink = _CollectingSink();
    final worker = PdfRenderBatchWorker(
      rasterizer: PdfPageRasterizerAdapter(PdfPageRasterizer()),
      sink: sink,
    );
    final result = await worker.run(
      bytes,
      expectedSourceHash: sha256.convert(bytes).toString(),
      pageNumbers: const [1],
      width: 128,
    );
    expect(result.completedPageNumbers, const [1]);
    expect(sink.pages, hasLength(1));
    expect(sink.pages.single.width, 128);
    expect(sink.pages.single.pixels.length,
        sink.pages.single.width * sink.pages.single.height * 4);
  });
}

final class _CancellingSink implements PdfRenderSink {
  _CancellingSink(this.cancel, this.onEmit);

  final PdfRenderCancel cancel;
  final void Function() onEmit;

  @override
  Future<void> emit(RenderedPdfPage page, String stablePageId) async {
    onEmit();
    cancel.request();
  }
}
