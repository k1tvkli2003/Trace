import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'figure-12',
    'version': 1,
    'assetHash': 'a' * 64,
    'sourceHash': 'b' * 64,
    'pagePixelHash': 'c' * 64,
    'pageId': 'page-12',
    'bbox': <String, Object>{'x': 0.1, 'y': 0.2, 'w': 0.4, 'h': 0.3},
    'widthPx': 1200,
    'heightPx': 900,
    'caption': 'شرح شکل',
    'altText': 'نمودار بخش اول',
    'reviewStatus': 'pending',
  };

  test('FigureAsset round-trips crop identity and source provenance', () {
    final figure = FigureAsset.fromJson(fixture);
    expect(figure.assetHash, 'a' * 64);
    expect(figure.bbox.width, 0.4);
    expect(figure.reviewStatus, FigureReviewStatus.pending);
    expect(figure.toJson(), fixture);
  });

  test('unknown review status stays unsupported without losing wire value', () {
    final json = {...fixture, 'reviewStatus': 'vendor-new-status'};
    final figure = FigureAsset.fromJson(json);
    expect(figure.reviewStatus, FigureReviewStatus.unsupported);
    expect(figure.toJson(), json);
  });

  test('zero-area figure crop is rejected', () {
    for (final dimension in ['w', 'h']) {
      final box = <String, Object>{'x': 0.1, 'y': 0.2, 'w': 0.4, 'h': 0.3};
      box[dimension] = 0;
      expect(
        () => FigureAsset.fromJson({...fixture, 'bbox': box}),
        throwsFormatException,
      );
    }
  });

  test('crop outside normalized page is rejected', () {
    final json = {
      ...fixture,
      'bbox': <String, Object>{'x': 0.8, 'y': 0.2, 'w': 0.4, 'h': 0.3},
    };
    expect(() => FigureAsset.fromJson(json), throwsFormatException);
  });

  test('invalid hash and dimensions are rejected', () {
    expect(
      () => FigureAsset.fromJson({...fixture, 'assetHash': 'abc'}),
      throwsFormatException,
    );
    expect(
      () => FigureAsset.fromJson({...fixture, 'pagePixelHash': 'abc'}),
      throwsFormatException,
    );
    expect(
      () => FigureAsset.fromJson({...fixture, 'widthPx': 0}),
      throwsFormatException,
    );
  });
}
