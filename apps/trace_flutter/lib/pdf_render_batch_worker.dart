import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'pdf_page_rasterizer.dart';

/// Stage12 bounded PDF thumbnail batch worker.
///
/// Pixel evidence only. No PDF text, OCR, or annotation extraction.
/// Pages render in strict [pageNumber] order, at most [maxPagesPerBatch]
/// per run. Identity is immutable: `sourceHash` binds the original bytes,
/// `pixelHash` binds the rendered BGRA8888 buffer, `renderProfile` binds
/// the renderer configuration. Cancellation is honored at page boundaries.
/// Any source-hash mismatch fails closed before rendering or emitting.
final class PdfRenderBatchWorker {
  PdfRenderBatchWorker({required this.rasterizer, required this.sink});

  static const int maxPagesPerBatch = 8;

  final PdfRenderRasterizer rasterizer;
  final PdfRenderSink sink;

  Future<PdfRenderResult> run(
    Uint8List source, {
    required String expectedSourceHash,
    required List<int> pageNumbers,
    required int width,
    PdfRenderCheckpoint? resumeFrom,
    PdfRenderCancel? cancel,
  }) async {
    if (pageNumbers.isEmpty || pageNumbers.length > maxPagesPerBatch) {
      throw ArgumentError.value(
        pageNumbers.length,
        'pageNumbers',
        'Batch must contain 1..$maxPagesPerBatch pages',
      );
    }
    for (var i = 0; i < pageNumbers.length; i++) {
      if (pageNumbers[i] < 1) {
        throw ArgumentError.value(pageNumbers[i], 'pageNumbers');
      }
      if (i > 0 && pageNumbers[i] <= pageNumbers[i - 1]) {
        throw ArgumentError.value(
          pageNumbers,
          'pageNumbers',
          'Pages must be strictly increasing',
        );
      }
    }
    if (width < 64 || width > 2048) {
      throw RangeError.value(width, 'width');
    }
    if (source.isEmpty) throw const FormatException('Empty PDF source');

    final actualSourceHash = sha256.convert(source).toString();
    if (actualSourceHash != expectedSourceHash) {
      throw StateError('PDF source hash mismatch; refusing to render');
    }
    final renderProfile = _renderProfileForWidth(width);

    final completed = <int>[];
    final stableIds = <int, String>{};
    final pixelHashes = <int, String>{};
    if (resumeFrom != null) {
      if (resumeFrom.sourceHash != actualSourceHash ||
          resumeFrom.renderProfile != renderProfile) {
        throw StateError(
          'Checkpoint source hash or render profile mismatch; refusing resume',
        );
      }
      final requested = pageNumbers.toSet();
      final seen = <int>{};
      for (final page in resumeFrom.completedPageNumbers) {
        if (page < 1 || !requested.contains(page) || !seen.add(page)) {
          throw const FormatException('Invalid checkpoint page order');
        }
      }
      final ordered = resumeFrom.completedPageNumbers.toList()..sort();
      for (var i = 0; i < ordered.length; i++) {
        if (resumeFrom.completedPageNumbers[i] != ordered[i]) {
          throw const FormatException('Invalid checkpoint page order');
        }
      }
      for (final page in resumeFrom.completedPageNumbers) {
        final expectedId = stablePdfPageId(
          sourceHash: actualSourceHash,
          pageNumber: page,
          renderProfile: renderProfile,
        );
        final pixelHash = resumeFrom.pixelHashes[page];
        if (resumeFrom.stablePageIds[page] != expectedId ||
            pixelHash == null ||
            !RegExp(r'^[a-f0-9]{64}$').hasMatch(pixelHash)) {
          throw const FormatException('Checkpoint page identity mismatch');
        }
        completed.add(page);
        stableIds[page] = expectedId;
        pixelHashes[page] = pixelHash;
      }
    }
    final resumedSet = completed.toSet();

    for (final pageNumber in pageNumbers) {
      if (resumedSet.contains(pageNumber)) continue;
      if (cancel?.isRequested == true) break;
      final rendered = await rasterizer.renderPage(
        source,
        pageNumber: pageNumber,
        width: width,
      );
      if (rendered.pageNumber != pageNumber ||
          rendered.sourceHash != actualSourceHash ||
          rendered.renderProfile != renderProfile ||
          rendered.pixels.length != rendered.width * rendered.height * 4 ||
          sha256.convert(rendered.pixels).toString() != rendered.pixelHash) {
        throw StateError('Rendered page identity mismatch; failing closed');
      }
      final stableId = stablePdfPageId(
        sourceHash: actualSourceHash,
        pageNumber: pageNumber,
        renderProfile: renderProfile,
      );
      await sink.emit(rendered, stableId);
      completed.add(pageNumber);
      stableIds[pageNumber] = stableId;
      pixelHashes[pageNumber] = rendered.pixelHash;
    }

    final cancelled = (cancel?.isRequested == true) &&
        completed.length < pageNumbers.length;
    return PdfRenderResult(
      sourceHash: actualSourceHash,
      renderProfile: renderProfile,
      completedPageNumbers: List.unmodifiable(completed),
      stablePageIds: Map.unmodifiable(stableIds),
      pixelHashes: Map.unmodifiable(pixelHashes),
      cancelled: cancelled,
      checkpoint: PdfRenderCheckpoint(
        sourceHash: actualSourceHash,
        renderProfile: renderProfile,
        completedPageNumbers: List.unmodifiable(completed),
        stablePageIds: Map.unmodifiable(stableIds),
        pixelHashes: Map.unmodifiable(pixelHashes),
      ),
    );
  }
}

String _renderProfileForWidth(int width) =>
    'pdfium-bgra-white-annotations-v1-width$width';

/// Stable page identity derived from source, page, and render profile.
String stablePdfPageId({
  required String sourceHash,
  required int pageNumber,
  required String renderProfile,
}) {
  return sha256
      .convert('$sourceHash|$pageNumber|$renderProfile'.codeUnits)
      .toString();
}

/// Injectable rasterizer boundary for testability.
abstract interface class PdfRenderRasterizer {
  Future<RenderedPdfPage> renderPage(
    Uint8List source, {
    required int pageNumber,
    required int width,
  });
}

/// Adapter over the real pdfrx-backed rasterizer.
final class PdfPageRasterizerAdapter implements PdfRenderRasterizer {
  PdfPageRasterizerAdapter(this.inner);

  final PdfPageRasterizer inner;

  @override
  Future<RenderedPdfPage> renderPage(
    Uint8List source, {
    required int pageNumber,
    required int width,
  }) =>
      inner.renderPage(source, pageNumber: pageNumber, width: width);
}

/// Injectable emission sink; no persistent store required in this slice.
abstract interface class PdfRenderSink {
  Future<void> emit(RenderedPdfPage page, String stablePageId);
}

/// Cooperative cancellation honored at page boundaries.
final class PdfRenderCancel {
  bool _requested = false;

  bool get isRequested => _requested;

  void request() => _requested = true;
}

/// Checkpoint/resume manifest. JSON round-trippable, no file I/O here.
final class PdfRenderCheckpoint {
  PdfRenderCheckpoint({
    required this.sourceHash,
    required this.renderProfile,
    required this.completedPageNumbers,
    required this.stablePageIds,
    required this.pixelHashes,
  });

  final String sourceHash;
  final String renderProfile;
  final List<int> completedPageNumbers;
  final Map<int, String> stablePageIds;
  final Map<int, String> pixelHashes;

  Map<String, Object?> toJson() => {
        'sourceHash': sourceHash,
        'renderProfile': renderProfile,
        'completed': completedPageNumbers.toList(),
        'stablePageIds':
            stablePageIds.map((k, v) => MapEntry(k.toString(), v)),
        'pixelHashes':
            pixelHashes.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory PdfRenderCheckpoint.fromJson(Map<String, Object?> json) {
    final completed = (json['completed'] as List)
        .map((e) => (e as num).toInt())
        .toList();
    Map<int, String> intKeyMap(Object? value) {
      if (value is! Map) return const {};
      return value.map(
        (k, v) => MapEntry(int.parse(k.toString()), v.toString()),
      );
    }

    return PdfRenderCheckpoint(
      sourceHash: json['sourceHash'].toString(),
      renderProfile: json['renderProfile'].toString(),
      completedPageNumbers: completed,
      stablePageIds: intKeyMap(json['stablePageIds']),
      pixelHashes: intKeyMap(json['pixelHashes']),
    );
  }
}

final class PdfRenderResult {
  PdfRenderResult({
    required this.sourceHash,
    required this.renderProfile,
    required this.completedPageNumbers,
    required this.stablePageIds,
    required this.pixelHashes,
    required this.cancelled,
    required this.checkpoint,
  });

  final String sourceHash;
  final String renderProfile;
  final List<int> completedPageNumbers;
  final Map<int, String> stablePageIds;
  final Map<int, String> pixelHashes;
  final bool cancelled;
  final PdfRenderCheckpoint checkpoint;
}
