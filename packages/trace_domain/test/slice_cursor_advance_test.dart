import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('cursor starts at first slice and advances one block at a time', () {
    final slices = <LearningSlice>[
      _slice('slice-1', 0, ['b1', 'b2']),
      _slice('slice-2', 1, ['b3']),
    ];
    final initial = createSliceCursor(
      id: 'cursor-1',
      libraryId: 'library-1',
      nodeId: 'node-1',
      plannerVersion: 'planner-v1',
      stateHash: 'a' * 64,
      slices: slices,
    );

    expect(selectNextSlice(initial, slices)?.id, 'slice-1');
    final afterFirst = advanceSliceCursor(
      initial,
      slices,
      completedBlockId: 'b1',
      nextStateHash: 'b' * 64,
    );
    expect(afterFirst.currentSliceId, 'slice-1');
    expect(afterFirst.nextBlockIndex, 1);

    final afterSecond = advanceSliceCursor(
      afterFirst,
      slices,
      completedBlockId: 'b2',
      nextStateHash: 'c' * 64,
    );
    expect(afterSecond.currentSliceId, 'slice-2');
    expect(afterSecond.nextBlockIndex, 0);
    expect(selectNextSlice(afterSecond, slices)?.id, 'slice-2');

    final atEnd = advanceSliceCursor(
      afterSecond,
      slices,
      completedBlockId: 'b3',
      nextStateHash: 'd' * 64,
    );
    expect(atEnd.currentSliceId, 'slice-2');
    expect(atEnd.nextBlockIndex, 1);
    expect(selectNextSlice(atEnd, slices), isNull);
  });

  test(
    'cached slice remains ready until its final block reaches Vision boundary',
    () {
      final slices = [
        LearningSlice.fromJson({
          'id': 'slice-1',
          'version': 1,
          'contentHash': 'f' * 64,
          'nodeId': 'node-1',
          'order': 0,
          'sourceBlockIds': ['block-1'],
          'pageIds': ['page-1'],
          'conceptIds': <String>[],
          'estimatedEffort': 1,
          'boundaryReason': 'vision_required',
          'nextVisionRequiredAt': 2,
        }),
      ];
      final cursor = createSliceCursor(
        id: 'cursor',
        libraryId: 'library',
        nodeId: 'node-1',
        plannerVersion: 'planner-v1',
        stateHash: 'a' * 64,
        slices: slices,
        pageNumbers: {'page-1': 1, 'page-2': 2},
      );
      expect(cursor.lookaheadState, 'ready');
      expect(selectNextSlice(cursor, slices)?.id, 'slice-1');
      final pending = advanceSliceCursor(
        cursor,
        slices,
        completedBlockId: 'block-1',
        nextStateHash: 'b' * 64,
        pageNumbers: {'page-1': 1, 'page-2': 2},
      );
      expect(pending.lookaheadState, 'vision_required');
      expect(selectNextSlice(pending, slices), isNull);
    },
  );

  test('missing Vision boundary remains pending after last cached block', () {
    final slices = [
      LearningSlice.fromJson({
        'id': 'slice-1',
        'version': 1,
        'contentHash': 'f' * 64,
        'nodeId': 'node-1',
        'order': 0,
        'sourceBlockIds': ['b1'],
        'pageIds': ['page-1'],
        'conceptIds': [],
        'estimatedEffort': 1,
        'boundaryReason': 'vision_required',
        'nextVisionRequiredAt': 2,
      }),
    ];
    final cursor = createSliceCursor(
      id: 'cursor-1',
      libraryId: 'library-1',
      nodeId: 'node-1',
      plannerVersion: 'planner-v1',
      stateHash: 'a' * 64,
      slices: slices,
    );
    final waiting = advanceSliceCursor(
      cursor,
      slices,
      completedBlockId: 'b1',
      nextStateHash: 'b' * 64,
    );
    expect(waiting.lookaheadState, 'vision_required');
    expect(waiting.nextPageNumber, 2);
    expect(selectNextSlice(waiting, slices), isNull);
    expect(
      () => advanceSliceCursor(
        waiting,
        slices,
        completedBlockId: 'b1',
        nextStateHash: 'c' * 64,
      ),
      throwsFormatException,
    );
  });

  test('cursor reports actual next page from explicit page map', () {
    final slices = [
      _slice('slice-1', 0, ['b1']),
      LearningSlice.fromJson({
        ..._slice('slice-2', 1, ['b2']).toJson(),
        'pageIds': ['page-9'],
      }),
    ];
    final initial = createSliceCursor(
      id: 'cursor-1',
      libraryId: 'library-1',
      nodeId: 'node-1',
      plannerVersion: 'planner-v1',
      stateHash: 'a' * 64,
      slices: slices,
      pageNumbers: {'page-1': 1, 'page-9': 9},
    );
    expect(initial.nextPageNumber, 1);
    final next = advanceSliceCursor(
      initial,
      slices,
      completedBlockId: 'b1',
      nextStateHash: 'b' * 64,
      pageNumbers: {'page-1': 1, 'page-9': 9},
    );
    expect(next.nextPageNumber, 9);
    expect(selectNextSlice(next, slices)?.id, 'slice-2');
  });

  test('cursor resume rejects a block that is not the next block', () {
    final slices = [
      _slice('slice-1', 0, ['b1', 'b2']),
    ];
    final cursor = createSliceCursor(
      id: 'cursor-1',
      libraryId: 'library-1',
      nodeId: 'node-1',
      plannerVersion: 'planner-v1',
      stateHash: 'a' * 64,
      slices: slices,
    );

    expect(
      () => advanceSliceCursor(
        cursor,
        slices,
        completedBlockId: 'b2',
        nextStateHash: 'b' * 64,
      ),
      throwsFormatException,
    );
  });

  test('cursor resume rejects a planner version mismatch', () {
    final slices = [
      _slice('slice-1', 0, ['b1']),
    ];
    final cursor = createSliceCursor(
      id: 'cursor-1',
      libraryId: 'library-1',
      nodeId: 'node-1',
      plannerVersion: 'planner-v1',
      stateHash: 'a' * 64,
      slices: slices,
    );

    expect(
      () => selectNextSlice(cursor, slices, plannerVersion: 'planner-v2'),
      throwsFormatException,
    );
  });
}

LearningSlice _slice(String id, int order, List<String> blockIds) {
  return LearningSlice.fromJson({
    'id': id,
    'version': 1,
    'contentHash': 'f' * 64,
    'nodeId': 'node-1',
    'order': order,
    'sourceBlockIds': blockIds,
    'pageIds': ['page-1'],
    'conceptIds': [],
    'estimatedEffort': blockIds.length,
    'boundaryReason': order == 0 ? 'max_blocks' : 'end_of_node',
    'nextVisionRequiredAt': null,
  });
}
