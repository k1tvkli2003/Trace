import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/pdf_page_rasterizer.dart';
import 'package:trace_flutter/pdf_render_batch_worker.dart';
import 'package:trace_flutter/services/pdf_vision_service.dart';
import 'package:trace_flutter/services/session_gateway.dart';
import 'package:trace_flutter/services/trace_gateway_client.dart';

final _pdfBytes = Uint8List.fromList(
  List<int>.generate(64, (i) => i % 256),
);

/// Minimal PDF the importer accepts: %PDF- header plus %%EOF tail.
Uint8List _realPdf() {
  final head = ascii.encode('%PDF-1.4\n');
  final tail = ascii.encode('%%EOF');
  final body = Uint8List.fromList(List<int>.filled(2100, 0x20));
  return Uint8List.fromList([...head, ...body, ...tail]);
}

RenderedPdfPage _page(String sourceHash) {
  final pixels = Uint8List.fromList(
    List<int>.generate(4 * 8 * 8, (i) => (i * 7) % 256),
  );
  return RenderedPdfPage(
    pageNumber: 1,
    width: 8,
    height: 8,
    pixels: pixels,
    sourceHash: sourceHash,
    pixelHash: sha256.convert(pixels).toString(),
    renderProfile: 'pdfium-bgra-white-annotations-v1-width256',
  );
}

String _extractJson(String sourceHash, String pixelHash) => jsonEncode({
  'schemaVersion': 'page-extract-v1',
  'sourceHash': sourceHash,
  'pixelHash': pixelHash,
  'renderProfile': 'pdfium-bgra-white-annotations-v1-width256',
  'pageRef': 'page-1',
  'extractionVersion': 'page-vision-extract-v1',
  'coverage': 'complete',
  'blocks': [
    {
      'id': 'b1',
      'order': 0,
      'kind': 'paragraph',
      'text': 'Vision text',
      'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.5, 'h': 0.1},
      'confidence': 0.9,
      'uncertain': false,
    },
  ],
  'figures': [],
});

void main() {
  test('vision service renders pages 1..3, runs gateway, caches extract',
      () async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalLibraryRepository(database).putEntry(
      const LibraryEntrySummary(id: 'lib', title: 'Book'),
    );
    final source = await LocalPdfSourceRepository(database).importPdf(
      libraryId: 'lib',
      name: 'book.pdf',
      bytes: _realPdf(),
    );
    final sourceHash = source.sourceHash;
    final page = _page(sourceHash);

    var gatewayCalls = 0;
    final sessions = LocalAuthSessionRepository(database);
    await sessions.save(
      TraceAuthSession(
        email: 'live@example.com',
        accessToken: 'jwt-live',
        refreshToken: 'refresh-1',
        expiresAtEpochSeconds:
            DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 + 3600,
        userId: 'user-1',
      ),
    );
    final runner = SessionGatewayRunner(
      sessions: sessions,
      client: TraceGatewayClient(
        endpoint: Uri.parse('https://example.invalid/api/trace-ai-run'),
        post: (uri, headers, body) async {
          gatewayCalls++;
          return _FakeResponse(
            200,
            jsonEncode({
              'receipt': {
                'requestId': 'a' * 32,
                'status': 'completed',
                'operation': 'op-1',
                'capability': 'page_vision_extract',
                'model': 'user-route',
                'reasoningEffort': 'high',
                'elapsedSeconds': 1.0,
              },
              'extract': jsonDecode(_extractJson(sourceHash, page.pixelHash)),
            }),
          );
        },
      ),
    );
    final service = PdfVisionService(
      database: database,
      rasterizer: _FakeRasterizer(page),
      runner: runner,
      pngEncoder: (_) async => Uint8List.fromList(
        List<int>.generate(64, (i) => i),
      ),
    );
    final result = await service.visionFirstPages(
      sourceId: source.id,
      sourceHash: sourceHash,
      sourceBytes: _realPdf(),
      documentVersion: 1,
      pageNumbers: const [1],
      operationBase: 'op-1',
    );
    expect(result.completed, 1);
    expect(result.failures, isEmpty);
    expect(gatewayCalls, 1);
    final hit = await LocalVisionCacheRepository(database).lookup(
      key: PageVisionCacheKey.fromJson({
        'sourceHash': sourceHash,
        'pageNumber': 1,
        'renderProfile': page.renderProfile,
        'visionModelProfile': 'user-route',
        'promptVersion': 'page-vision-extract-v1',
      }),
      pixelHash: page.pixelHash,
    );
    expect(hit, isNotNull);
    expect(hit!.payloadJson, contains('Vision text'));
  });
}

final class _FakeRasterizer implements PdfRenderRasterizer {
  _FakeRasterizer(this.page);
  final RenderedPdfPage page;
  @override
  Future<RenderedPdfPage> renderPage(
    Uint8List source, {
    required int pageNumber,
    required int width,
  }) async => page;
}

final class _FakeResponse implements TraceHttpResponse {
  const _FakeResponse(this.statusCode, this.body);
  @override
  final int statusCode;
  @override
  final String body;
}
