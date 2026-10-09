import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

import '../pdf_page_rasterizer.dart';
import '../pdf_render_batch_worker.dart';
import 'session_gateway.dart';
import 'trace_gateway_client.dart';

/// Outcome of one bounded first-pages vision run. No exception for
/// per-page failure: failures carry safe codes only.
final class PdfVisionOutcome {
  const PdfVisionOutcome({required this.completed, required this.failures});

  final int completed;
  final Map<int, String> failures;
}

/// Renders pages 1..3 of a PDF original, runs each through the authorized
/// gateway, and persists validated extracts to the local vision cache.
///
/// Identity chain per page: source hash (original bytes) → pixel hash
/// (rendered BGRA) → single-page PNG → gateway request → bound receipt
/// extract → vision cache. Any link mismatch fails that page closed with
/// a safe code; other pages still run.
final class PdfVisionService {
  PdfVisionService({
    required this.database,
    required this.rasterizer,
    required this.runner,
    required this.pngEncoder,
    this.renderWidth = 1024,
  });

  static const maxPages = 3;

  final TraceDatabase database;
  final PdfRenderRasterizer rasterizer;
  final SessionGatewayRunner runner;
  final Future<Uint8List> Function(RenderedPdfPage page) pngEncoder;
  final int renderWidth;

  Future<PdfVisionOutcome> visionFirstPages({
    required String sourceId,
    required String sourceHash,
    required Uint8List sourceBytes,
    required int documentVersion,
    required List<int> pageNumbers,
    required String operationBase,
    String reasoningEffort = 'high',
  }) async {
    if (sha256.convert(sourceBytes).toString() != sourceHash) {
      throw StateError('PDF source hash mismatch; refusing vision run');
    }
    final pages = pageNumbers.where((p) => p >= 1 && p <= maxPages).toList()
      ..sort();
    if (pages.isEmpty || pages.length > maxPages) {
      throw ArgumentError.value(
        pageNumbers,
        'pageNumbers',
        'Must contain 1..$maxPages pages within 1..$maxPages',
      );
    }
    final visionCache = LocalVisionCacheRepository(database);
    final pageRepo = LocalSourcePageRepository(database);
    var completed = 0;
    final failures = <int, String>{};
    for (final pageNumber in pages) {
      try {
        final rendered = await rasterizer.renderPage(
          sourceBytes,
          pageNumber: pageNumber,
          width: renderWidth,
        );
        if (rendered.pageNumber != pageNumber ||
            rendered.sourceHash != sourceHash) {
          throw const TraceGatewayFailure('AI_PAGE_IMAGE_MISMATCH');
        }
        final png = await pngEncoder(rendered);
        if (png.lengthInBytes < 16 ||
            png.lengthInBytes > 3 * 1024 * 1024) {
          throw const TraceGatewayFailure('AI_PAGE_IMAGE_INVALID');
        }
        // Pixel identity stays bound to the rendered BGRA buffer hash
        // (verified inside pngEncoder); PNG bytes differ by construction.
        final request = TraceGatewayRequest(
          operation: '$operationBase-p$pageNumber',
          capability: 'page_vision_extract',
          pageRef: 'page-$pageNumber',
          sourceHash: sourceHash,
          pixelHash: rendered.pixelHash,
          renderProfile: rendered.renderProfile,
          pagePngBase64: base64.encode(png),
          reasoningEffort: reasoningEffort,
          maxOutputTokens: 4096,
          maxElapsedSeconds: 300,
          idempotencyKey:
              '${operationBase.hashCode.toUnsigned(20)}-p$pageNumber-$sourceHash'
                  .substring(0, 64),
        );
        final receipt = await runner.run(request);
        final bound = receipt.boundTo(request);
        if (bound.extract.isEmpty) {
          throw const TraceGatewayFailure('AI_SCHEMA_REJECTED');
        }
        await pageRepo.putPage(
          SourcePage.fromJson({
            'id': 'page-$pageNumber',
            'documentId': sourceId,
            'version': documentVersion,
            'pageNumber': pageNumber,
            'pixelHash': rendered.pixelHash,
            'renderProfile': rendered.renderProfile,
            'thumbnailPath': 'vision/page-$pageNumber.png',
            'visionStatus': 'pending',
          }),
        );
        await visionCache.put(
          key: PageVisionCacheKey.fromJson({
            'sourceHash': sourceHash,
            'pageNumber': pageNumber,
            'renderProfile': rendered.renderProfile,
            'visionModelProfile': bound.model,
            'promptVersion': 'page-vision-extract-v1',
          }),
          pixelHash: rendered.pixelHash,
          payloadJson: jsonEncode(bound.extract),
        );
        completed++;
      } on TraceGatewayFailure catch (error) {
        failures[pageNumber] = error.code;
      } on StateError {
        failures[pageNumber] = 'AI_PAGE_IMAGE_MISMATCH';
      } on ArgumentError {
        failures[pageNumber] = 'AI_VISION_REQUEST_INVALID';
      } on FormatException {
        failures[pageNumber] = 'AI_SCHEMA_REJECTED';
      } catch (_) {
        failures[pageNumber] = 'AI_PROVIDER_FAILURE';
      }
    }
    return PdfVisionOutcome(completed: completed, failures: failures);
  }
}
