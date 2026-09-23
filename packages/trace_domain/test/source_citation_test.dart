import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('SourceCitation preserves locator, quote, confidence, and hashes', () {
    final json = <String, Object?>{
      'id': 'citation-12',
      'version': 1,
      'contentHash': 'b' * 64,
      'sourceBlockId': 'block-12',
      'pageId': 'page-12',
      'figureId': null,
      'quote': 'متن دقیق منبع',
      'locator': 'p. 12 · block 4',
      'confidence': 0.93,
      'extractionVersion': 'vision-v1',
    };

    final citation = SourceCitation.fromJson(json);
    expect(citation.confidence, 0.93);
    expect(citation.toJson(), json);
  });
}
