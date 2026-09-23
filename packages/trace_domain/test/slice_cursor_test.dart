import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('SliceCursor round-trips deterministic resume state', () {
    final json = <String, Object?>{
      'id': 'cursor-library-node',
      'version': 3,
      'stateHash': 'f' * 64,
      'libraryId': 'library-1',
      'nodeId': 'node-1',
      'currentSliceId': 'slice-2',
      'nextBlockIndex': 2,
      'nextPageNumber': 18,
      'lookaheadState': 'page-19-required',
      'plannerVersion': 'planner-v1',
    };

    final cursor = SliceCursor.fromJson(json);
    expect(cursor.currentSliceId, 'slice-2');
    expect(cursor.toJson(), json);
  });

  test('SliceCursor rejects negative positions', () {
    final json = <String, Object?>{
      'id': 'cursor-1',
      'version': 1,
      'stateHash': 'f' * 64,
      'libraryId': 'library-1',
      'nodeId': 'node-1',
      'currentSliceId': null,
      'nextBlockIndex': -1,
      'nextPageNumber': null,
      'lookaheadState': 'none',
      'plannerVersion': 'planner-v1',
    };

    expect(() => SliceCursor.fromJson(json), throwsFormatException);
  });
}
