import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'LearningSlice round-trips ordered source scope and boundary policy',
    () {
      final json = <String, Object?>{
        'id': 'slice-1',
        'version': 1,
        'contentHash': 'e' * 64,
        'nodeId': 'node-1',
        'order': 0,
        'sourceBlockIds': ['block-1', 'block-2'],
        'pageIds': ['page-1'],
        'conceptIds': ['concept-1'],
        'estimatedEffort': 12,
        'boundaryReason': 'concept_complete',
        'nextVisionRequiredAt': null,
      };

      final slice = LearningSlice.fromJson(json);
      expect(slice.sourceBlockIds, ['block-1', 'block-2']);
      expect(slice.toJson(), json);
    },
  );

  test('LearningSlice rejects duplicate source IDs and negative effort', () {
    final base = <String, Object?>{
      'id': 'slice-1',
      'version': 1,
      'contentHash': 'e' * 64,
      'nodeId': 'node-1',
      'order': 0,
      'sourceBlockIds': ['block-1'],
      'pageIds': ['page-1'],
      'conceptIds': [],
      'estimatedEffort': 12,
      'boundaryReason': 'concept_complete',
      'nextVisionRequiredAt': null,
    };
    expect(
      () => LearningSlice.fromJson({
        ...base,
        'sourceBlockIds': ['block-1', 'block-1'],
      }),
      throwsFormatException,
    );
    expect(
      () => LearningSlice.fromJson({...base, 'estimatedEffort': -1}),
      throwsFormatException,
    );
  });
}
