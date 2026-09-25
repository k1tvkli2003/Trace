import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

Map<String, Object?> rehydrationAnchor({
  String quote = 'mechanism is stable',
  String prefix = 'source ',
  String suffix = ' today',
  int startOffset = 11,
  int endOffset = 30,
}) => {
  'id': 'anchor-1',
  'version': 1,
  'contentHashAtCreation': 'b' * 64,
  'sourceBlockId': 'block-1',
  'pageId': 'page-1',
  'lessonBlockId': null,
  'quote': quote,
  'prefix': prefix,
  'suffix': suffix,
  'startOffset': startOffset,
  'endOffset': endOffset,
  'bbox': {'x': 0.2, 'y': 0.1, 'w': 0.3, 'h': 0.05},
  'color': 'yellow',
  'status': 'attached',
};

void main() {
  test('rehydration keeps attached selection on exact block and hash', () {
    final anchor = HighlightAnchor.fromJson(rehydrationAnchor());
    final outcome = rehydrateHighlight(
      anchor: anchor,
      blockId: 'block-1',
      pageId: 'page-1',
      sourceHash: 'b' * 64,
      sourceText: 'The source mechanism is stable today.',
      blockBbox: const NormalizedBox(x: 0.1, y: 0.1, width: 0.8, height: 0.1),
    );
    expect(outcome.attached, isTrue);
    expect(outcome.reason, 'exact-block-hash-quote');
  });

  test('rehydration finds quote moved inside the same verified block', () {
    final anchor = HighlightAnchor.fromJson(rehydrationAnchor());
    final outcome = rehydrateHighlight(
      anchor: anchor,
      blockId: 'block-1',
      pageId: 'page-1',
      sourceHash: 'b' * 64,
      sourceText: 'Today the source mechanism is stable here.',
      blockBbox: const NormalizedBox(x: 0.1, y: 0.1, width: 0.8, height: 0.1),
    );
    expect(outcome.attached, isTrue);
    expect(outcome.reason, 'quote-inside-verified-block');
  });

  test('rehydration uses prefix and suffix when quote repeats', () {
    final anchor = HighlightAnchor.fromJson(
      rehydrationAnchor(
        quote: 'stable',
        prefix: 'mechanism is ',
        suffix: ' today',
        startOffset: 20,
        endOffset: 26,
      ),
    );
    final outcome = rehydrateHighlight(
      anchor: anchor,
      blockId: 'block-1',
      pageId: 'page-1',
      sourceHash: 'b' * 64,
      sourceText: 'stable start, mechanism is stable today.',
      blockBbox: const NormalizedBox(x: 0.1, y: 0.1, width: 0.8, height: 0.1),
    );
    expect(outcome.attached, isTrue);
    expect(outcome.reason, 'prefix-suffix-disambiguation');
    expect(outcome.startOffset, 27);
    expect(outcome.endOffset, 33);
  });

  test('rehydration detaches with page bbox context on hash change', () {
    final anchor = HighlightAnchor.fromJson(rehydrationAnchor());
    final outcome = rehydrateHighlight(
      anchor: anchor,
      blockId: 'block-1',
      pageId: 'page-1',
      sourceHash: 'c' * 64,
      sourceText: 'The source mechanism is stable today.',
      blockBbox: const NormalizedBox(x: 0.1, y: 0.1, width: 0.8, height: 0.1),
    );
    expect(outcome.attached, isFalse);
    expect(outcome.reason, 'page-bbox-fallback');
    expect(outcome.pageBboxFallback, isTrue);
  });

  test('rehydration detaches when quote is absent from source block', () {
    final anchor = HighlightAnchor.fromJson(rehydrationAnchor());
    final outcome = rehydrateHighlight(
      anchor: anchor,
      blockId: 'block-1',
      pageId: 'page-1',
      sourceHash: 'b' * 64,
      sourceText: 'The source wording changed completely.',
      blockBbox: const NormalizedBox(x: 0.1, y: 0.1, width: 0.8, height: 0.1),
    );
    expect(outcome.attached, isFalse);
    expect(outcome.reason, 'quote-absent');
  });

  test('rehydration matches Persian quote after whitespace change only', () {
    final anchor = HighlightAnchor.fromJson(
      rehydrationAnchor(
        quote: 'مکانیسم  پایدار',
        prefix: 'منبع ',
        suffix: ' است',
        startOffset: 5,
        endOffset: 18,
      ),
    );
    final outcome = rehydrateHighlight(
      anchor: anchor,
      blockId: 'block-1',
      pageId: 'page-1',
      sourceHash: 'b' * 64,
      sourceText: 'منبع مکانیسم پایدار است',
      blockBbox: const NormalizedBox(x: 0.1, y: 0.1, width: 0.8, height: 0.1),
    );
    expect(outcome.attached, isTrue);
    expect(outcome.reason, 'quote-inside-verified-block');
  });
}
