import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final pdfBlock = <String, Object?>{
    'id': 'block-12',
    'documentId': 'doc-1',
    'pageId': 'page-12',
    'version': 1,
    'sourceHash': 'a' * 64,
    'order': 4,
    'kind': 'paragraph',
    'rawText': 'متن دقیق منبع',
    'normalizedText': 'متن دقیق منبع',
    'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.7, 'h': 0.1},
  };

  test('PDF SourceBlock round-trips page geometry and hash-bound wording', () {
    final block = SourceBlock.fromJson(pdfBlock);
    expect(block.kind, SourceBlockKind.paragraph);
    expect(block.pageId, 'page-12');
    expect(block.toJson(), pdfBlock);
    expect(SourceBlock.fromJson(block.toJson()).toJson(), pdfBlock);
  });
}
