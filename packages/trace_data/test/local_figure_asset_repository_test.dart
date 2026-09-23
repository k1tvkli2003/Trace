import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'figure crop bytes are hash-verified, bound to page and replayable',
    () async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
      final original = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
      final source = await LocalPdfSourceRepository(
        db,
      ).importPdf(libraryId: 'lib', name: 'book.pdf', bytes: original);
      await LocalSourcePageRepository(db).putPage(
        SourcePage.fromJson({
          'id': 'page-1',
          'documentId': source.id,
          'version': 1,
          'pageNumber': 1,
          'pixelHash': 'a' * 64,
          'renderProfile': 'hires-v1',
          'thumbnailPath': 'thumbs/page-1.webp',
          'visionStatus': 'complete',
        }),
      );
      final crop = Uint8List.fromList(utf8.encode('synthetic crop bytes'));
      Map<String, Object?> figureJson({
        String id = 'figure-1',
        String? assetHash,
        String? pagePixelHash,
        String? sourceHash,
        String reviewStatus = 'pending',
      }) => {
        'id': id,
        'version': 1,
        'assetHash': assetHash ?? sha256.convert(crop).toString(),
        'sourceHash': sourceHash ?? source.sourceHash,
        'pagePixelHash': pagePixelHash ?? 'a' * 64,
        'pageId': 'page-1',
        'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.4, 'h': 0.3},
        'widthPx': 200,
        'heightPx': 150,
        'caption': 'Figure',
        'altText': 'Diagram',
        'reviewStatus': reviewStatus,
      };
      final repo = LocalFigureAssetRepository(db);
      final figure = FigureAsset.fromJson(figureJson());
      await repo.putCrop(figure, crop);
      await repo.putCrop(figure, crop);
      final saved = await repo.readCrop(figure.id);
      expect(saved?.$1.toJson(), figure.toJson());
      expect(saved?.$2, crop);
      await expectLater(
        repo.putCrop(figure, Uint8List.fromList([1])),
        throwsStateError,
      );
      await expectLater(
        repo.putCrop(
          FigureAsset.fromJson(
            figureJson(id: 'bad-page-hash', pagePixelHash: 'b' * 64),
          ),
          crop,
        ),
        throwsStateError,
      );
      await expectLater(
        repo.putCrop(
          FigureAsset.fromJson(
            figureJson(id: 'bad-source-hash', sourceHash: 'b' * 64),
          ),
          crop,
        ),
        throwsStateError,
      );
      await expectLater(
        repo.putCrop(
          FigureAsset.fromJson(
            figureJson(id: 'self-approved', reviewStatus: 'approved'),
          ),
          crop,
        ),
        throwsStateError,
      );
      expect(await repo.readCrop('self-approved'), isNull);
    },
  );
}
