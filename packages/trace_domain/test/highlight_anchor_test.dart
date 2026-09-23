import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'highlight-1',
    'version': 1,
    'contentHashAtCreation': 'c' * 64,
    'sourceBlockId': 'block-1',
    'pageId': 'page-1',
    'lessonBlockId': 'lesson-block-1',
    'quote': 'متن انتخاب شده',
    'prefix': 'قبل از متن',
    'suffix': 'بعد از متن',
    'startOffset': 12,
    'endOffset': 26,
    'bbox': <String, Object>{'x': 0.1, 'y': 0.2, 'w': 0.3, 'h': 0.04},
    'color': 'amber',
    'status': 'attached',
  };

  test('HighlightAnchor round-trips source and lesson reattachment data', () {
    final highlight = HighlightAnchor.fromJson(fixture);
    expect(highlight.status, HighlightAnchorStatus.attached);
    expect(highlight.endOffset - highlight.startOffset, 14);
    expect(highlight.toJson(), fixture);
  });

  test('unknown anchor status stays unsupported without moving selection', () {
    final json = {...fixture, 'status': 'future-anchor-status'};
    final highlight = HighlightAnchor.fromJson(json);
    expect(highlight.status, HighlightAnchorStatus.unsupported);
    expect(highlight.toJson(), json);
  });

  test('HighlightAnchor rejects invalid offsets, hash and empty quote', () {
    for (final json in [
      {...fixture, 'startOffset': -1},
      {...fixture, 'endOffset': 12},
      {...fixture, 'contentHashAtCreation': 'bad'},
      {...fixture, 'quote': ''},
    ]) {
      expect(() => HighlightAnchor.fromJson(json), throwsFormatException);
    }
  });
}
