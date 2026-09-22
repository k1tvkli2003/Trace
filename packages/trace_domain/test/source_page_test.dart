import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('source page round-trips its hash-bound render metadata', () {
    final json = <String, Object>{
      'id': 'page-1',
      'documentId': 'doc-1',
      'version': 1,
      'pageNumber': 2,
      'pixelHash': 'b' * 64,
      'renderProfile': 'pdf-144dpi-v1',
      'thumbnailPath': 'pages/doc-1/2.webp',
      'visionStatus': 'not_started',
    };
    final page = SourcePage.fromJson(json);
    expect(page.visionStatus, SourcePageVisionStatus.notStarted);
    expect(page.toJson(), json);
    expect(SourcePage.fromJson(page.toJson()).toJson(), json);
  });

  test('unknown vision status is preserved but not treated as complete', () {
    final page = SourcePage.fromJson({
      'id': 'page-1',
      'documentId': 'doc-1',
      'version': 1,
      'pageNumber': 1,
      'pixelHash': 'a' * 64,
      'renderProfile': 'pdf-144dpi-v1',
      'thumbnailPath': 'pages/1.webp',
      'visionStatus': 'future_state',
    });
    expect(page.visionStatus, SourcePageVisionStatus.unsupported);
    expect(page.toJson()['visionStatus'], 'future_state');
  });

  test('rejects invalid rendered page identity before caching', () {
    final valid = <String, Object?>{
      'id': 'page-1',
      'documentId': 'doc-1',
      'version': 1,
      'pageNumber': 1,
      'pixelHash': 'a' * 64,
      'renderProfile': 'pdf-144dpi-v1',
      'thumbnailPath': 'pages/1.webp',
      'visionStatus': 'not_started',
    };
    for (final invalid in <(String, Object?)>[
      ('id', '  '),
      ('documentId', ''),
      ('version', 0),
      ('pageNumber', 0),
      ('pixelHash', 'A' * 64),
      ('renderProfile', ''),
      ('thumbnailPath', '../outside.webp'),
      ('thumbnailPath', r'C:\private\page.webp'),
      ('visionStatus', ''),
    ]) {
      expect(
        () => SourcePage.fromJson({...valid, invalid.$1: invalid.$2}),
        throwsFormatException,
        reason: invalid.$1,
      );
    }
  });
}
