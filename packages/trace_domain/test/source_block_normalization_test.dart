import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  const hash = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

  test('mixed RTL and LTR keeps glyphs and reading order', () {
    final blocks = normalizeSourceBlocks(
      documentId: 'doc-1',
      pageId: 'page-1',
      version: 1,
      sourceHash: hash,
      fragments: const [
        SourceFragment(kind: 'paragraph', text: '  سلول  T-cell  فعال  '),
        SourceFragment(kind: 'formula', text: 'Ca2+'),
      ],
    );

    expect(blocks.map((block) => block.order), [0, 1]);
    expect(blocks.first.rawText, '  سلول  T-cell  فعال  ');
    expect(blocks.first.normalizedText, 'سلول T-cell فعال');
    expect(blocks.last.rawText, 'Ca2+');
    expect(blocks.last.normalizedText, 'Ca2+');
  });

  test('figure and paragraph bounding boxes survive normalization', () {
    final blocks = normalizeSourceBlocks(
      documentId: 'doc-1',
      pageId: 'page-1',
      version: 1,
      sourceHash: hash,
      fragments: const [
        SourceFragment(
          kind: 'figure',
          text: 'شکل ۱',
          bbox: {'x': 0.2, 'y': 0.3, 'w': 0.4, 'h': 0.5},
        ),
      ],
    );
    expect(blocks.single.bbox?.toJson(), {
      'x': 0.2, 'y': 0.3, 'w': 0.4, 'h': 0.5,
    });
    expect(
      () => normalizeSourceBlocks(
        documentId: 'doc-1',
        pageId: 'page-1',
        version: 1,
        sourceHash: hash,
        fragments: const [
          SourceFragment(kind: 'figure', text: 'شکل ۱',
              bbox: {'x': 0.9, 'y': 0.9, 'w': 0.3, 'h': 0.2}),
        ],
      ),
      throwsFormatException,
    );
  });

  test('same page in new version has distinct stable block identity', () {
    List<SourceBlock> convert(int version) => normalizeSourceBlocks(
      documentId: 'doc-1', pageId: 'page-1', version: version,
      sourceHash: hash,
      fragments: const [SourceFragment(kind: 'paragraph', text: 'متن')],
    );
    expect(convert(1).single.id, isNot(convert(2).single.id));
    expect(convert(1).single.id, convert(1).single.id);
  });

  test('unknown fragments cannot silently become usable source text', () {
    expect(
      () => normalizeSourceBlocks(
        documentId: 'doc-1', pageId: 'page-1', version: 1,
        sourceHash: hash,
        fragments: const [SourceFragment(kind: 'unknown', text: '')],
      ),
      throwsFormatException,
    );
  });

  test('table cells stay cells and formula symbols stay verbatim', () {
    final blocks = normalizeSourceBlocks(
      documentId: 'doc-1',
      pageId: 'page-2',
      version: 1,
      sourceHash: hash,
      fragments: const [
        SourceFragment(kind: 'table', text: 'A | B\n1 | 2'),
        SourceFragment(kind: 'formula', text: 'H2O → H+ + OH−'),
      ],
    );

    expect(blocks.first.kind, SourceBlockKind.table);
    expect(blocks.first.normalizedText, 'A | B\n1 | 2');
    expect(blocks.last.normalizedText, 'H2O → H+ + OH−');
  });

  test('cross-page paragraph keeps both locators without merging text', () {
    final first = normalizeSourceBlocks(
      documentId: 'doc-1',
      pageId: 'page-1',
      version: 1,
      sourceHash: hash,
      fragments: const [SourceFragment(kind: 'paragraph', text: 'شروع جمله')],
    );
    final second = normalizeSourceBlocks(
      documentId: 'doc-1',
      pageId: 'page-2',
      version: 1,
      sourceHash: hash,
      fragments: const [
        SourceFragment(
          kind: 'paragraph',
          text: 'ادامه جمله',
          continuesFromBlockId: 'pending',
        ),
      ],
    );

    expect(second.single.pageId, 'page-2');
    expect(second.single.rawText, 'ادامه جمله');
    expect(second.single.normalizedText, isNot(contains(first.single.rawText)));
  });

  test('rewrite, unknown kind, and hash mismatch fail closed', () {
    expect(
      () => normalizeSourceBlocks(
        documentId: 'doc-1',
        pageId: 'page-1',
        version: 1,
        sourceHash: 'bad',
        fragments: const [SourceFragment(kind: 'paragraph', text: 'متن')],
      ),
      throwsFormatException,
    );
    expect(
      () => normalizeSourceBlocks(
        documentId: 'doc-1',
        pageId: 'page-1',
        version: 1,
        sourceHash: hash,
        fragments: const [SourceFragment(kind: 'lesson', text: 'متن')],
      ),
      throwsFormatException,
    );
  });
}
