import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('Markdown headings create ordered source-bound reading sections', () {
    final outline = SourceOutline.parse(
      sourceId: 'hash-bound-source',
      sourceName: 'chapter.md',
      markdown: true,
      text:
          '# First\nAn opening idea.\n\n## Detail\nImportant detail.\n\n# Next\nFinal thought.',
    );
    expect(outline.sections.map((s) => s.title).toList(), [
      'First',
      'Detail',
      'Next',
    ]);
    expect(outline.sections.map((s) => s.startLine).toList(), [1, 4, 7]);
    expect(outline.sections.map((s) => s.body).toList(), [
      'An opening idea.',
      'Important detail.',
      'Final thought.',
    ]);
    expect(outline.sections[1].sourceId, 'hash-bound-source');
    expect(outline.sections[1].endLine, 5);
  });

  test('heading-like lines in fences remain source content', () {
    final outline = SourceOutline.parse(
      sourceId: 'id',
      sourceName: 'code.md',
      markdown: true,
      text: '# Code\n```md\n# not a chapter\n```\nAfter the code.',
    );
    expect(outline.sections, hasLength(1));
    expect(outline.sections.single.body, contains('# not a chapter'));
  });

  test('text without headings stays in one honest source section', () {
    final outline = SourceOutline.parse(
      sourceId: 'id',
      sourceName: 'raw.txt',
      markdown: false,
      text: 'Line one\n# literal line\nLine three',
    );
    expect(outline.sections, hasLength(1));
    expect(outline.sections.single.title, 'raw.txt');
    expect(outline.sections.single.body, contains('# literal line'));
  });

  test('a heading-only and an empty source never manufacture a lesson', () {
    final outline = SourceOutline.parse(
      sourceId: 'id',
      sourceName: 'chapter.md',
      markdown: true,
      text: '# Header\n\n## Empty',
    );
    expect(outline.sections, hasLength(2));
    expect(outline.sections.last.body, isEmpty);
    final empty = SourceOutline.parse(
      sourceId: 'id',
      sourceName: 'blank.txt',
      markdown: false,
      text: ' \n  ',
    );
    expect(empty.sections, isEmpty);
  });
}
