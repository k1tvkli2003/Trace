import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('KnowledgeNode round-trips source range and user override', () {
    final json = <String, Object?>{
      'id': 'node-1',
      'parentId': null,
      'version': 2,
      'contentHash': 'c' * 64,
      'order': 3,
      'kind': 'section',
      'title': 'بخش نخست',
      'sourceRange': {'startPage': 12, 'endPage': 14},
      'confidence': 0.88,
      'userOverride': true,
    };

    final node = KnowledgeNode.fromJson(json);
    expect(node.kind, KnowledgeNodeKind.section);
    expect(node.sourceRange?.endPage, 14);
    expect(node.toJson(), json);
  });

  test('unknown node kind remains non-processable and round-trips', () {
    final node = KnowledgeNode.fromJson({
      'id': 'node-future',
      'parentId': 'node-1',
      'version': 1,
      'contentHash': 'd' * 64,
      'order': 0,
      'kind': 'future_kind',
      'title': 'Future',
      'sourceRange': null,
      'confidence': 0.1,
      'userOverride': false,
    });

    expect(node.kind, KnowledgeNodeKind.unsupported);
    expect(node.toJson()['kind'], 'future_kind');
  });
}
