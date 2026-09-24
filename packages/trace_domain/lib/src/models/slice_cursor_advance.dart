/// Pure creation, selection, and advancement rules for SliceCursor.
library;

import 'learning_slice.dart';
import 'slice_cursor.dart';

final _sha256 = RegExp(r'^[a-f0-9]{64}$');

SliceCursor createSliceCursor({
  required String id,
  required String libraryId,
  required String nodeId,
  required String plannerVersion,
  required String stateHash,
  required List<LearningSlice> slices,
  Map<String, int>? pageNumbers,
}) {
  _text(id, 'id');
  _text(libraryId, 'libraryId');
  _text(nodeId, 'nodeId');
  _text(plannerVersion, 'plannerVersion');
  _hash(stateHash, 'stateHash');
  _validateSlices(slices, nodeId);
  if (pageNumbers != null) _validateSlicePages(slices, pageNumbers);
  return SliceCursor.fromJson({
    'id': id,
    'version': 1,
    'stateHash': stateHash,
    'libraryId': libraryId,
    'nodeId': nodeId,
    'currentSliceId': slices.isEmpty ? null : slices.first.id,
    'nextBlockIndex': 0,
    'nextPageNumber': slices.isEmpty
        ? null
        : _firstPageNumber(slices.first, pageNumbers),
    'lookaheadState': slices.isEmpty
        ? 'end_of_node'
        : _lookaheadState(slices.first),
    'plannerVersion': plannerVersion,
  });
}

LearningSlice? selectNextSlice(
  SliceCursor cursor,
  List<LearningSlice> slices, {
  String? plannerVersion,
  Map<String, int>? pageNumbers,
}) {
  _validateSlices(slices, cursor.nodeId);
  if (plannerVersion != null && plannerVersion != cursor.plannerVersion) {
    throw const FormatException('Planner version mismatch');
  }
  if (pageNumbers != null) _validateSlicePages(slices, pageNumbers);
  if (cursor.lookaheadState == 'vision_required') {
    return null;
  }
  if (cursor.currentSliceId == null) {
    return slices.isEmpty ? null : _firstVisible(slices, cursor.nextPageNumber);
  }
  final index = slices.indexWhere((slice) => slice.id == cursor.currentSliceId);
  if (index < 0) throw const FormatException('Cursor slice is not in plan');
  final current = slices[index];
  if (cursor.nextBlockIndex > current.sourceBlockIds.length) {
    throw const FormatException('Cursor block index is outside slice');
  }
  if (cursor.nextBlockIndex < current.sourceBlockIds.length) {
    return _visibleOrNull(current, cursor.nextPageNumber) ?? current;
  }
  final remaining = slices.sublist(index + 1);
  return remaining.isEmpty
      ? null
      : _firstVisible(remaining, cursor.nextPageNumber);
}

SliceCursor advanceSliceCursor(
  SliceCursor cursor,
  List<LearningSlice> slices, {
  required String completedBlockId,
  required String nextStateHash,
  String? plannerVersion,
  Map<String, int>? pageNumbers,
  Map<String, String>? blockPageIds,
}) {
  _validateSlices(slices, cursor.nodeId);
  _hash(nextStateHash, 'nextStateHash');
  if (plannerVersion != null && plannerVersion != cursor.plannerVersion) {
    throw const FormatException('Planner version mismatch');
  }
  if (pageNumbers != null) _validateSlicePages(slices, pageNumbers);
  if (slices.isEmpty) throw const FormatException('Cannot advance empty plan');

  final selected = selectNextSlice(
    cursor,
    slices,
    plannerVersion: plannerVersion,
    pageNumbers: pageNumbers,
  );
  if (selected == null) throw const FormatException('Cursor is at end of plan');
  final index = slices.indexWhere((slice) => slice.id == selected.id);
  final blockIndex = selected.id == cursor.currentSliceId
      ? cursor.nextBlockIndex
      : 0;
  if (blockIndex >= selected.sourceBlockIds.length ||
      selected.sourceBlockIds[blockIndex] != completedBlockId) {
    throw const FormatException('Completed block is not next in cursor');
  }

  final nextBlockIndex = blockIndex + 1;
  final sliceComplete = nextBlockIndex >= selected.sourceBlockIds.length;
  if (!sliceComplete) {
    return SliceCursor.fromJson({
      'id': cursor.id,
      'version': cursor.version + 1,
      'stateHash': nextStateHash,
      'libraryId': cursor.libraryId,
      'nodeId': cursor.nodeId,
      'currentSliceId': selected.id,
      'nextBlockIndex': nextBlockIndex,
      'nextPageNumber': _nextBlockPageNumber(
        selected.sourceBlockIds[nextBlockIndex],
        blockPageIds,
        selected,
        pageNumbers,
      ),
      'lookaheadState': 'ready',
      'plannerVersion': cursor.plannerVersion,
    });
  }

  final boundaryVision = selected.nextVisionRequiredAt;
  if (boundaryVision != null) {
    return SliceCursor.fromJson({
      'id': cursor.id,
      'version': cursor.version + 1,
      'stateHash': nextStateHash,
      'libraryId': cursor.libraryId,
      'nodeId': cursor.nodeId,
      'currentSliceId': selected.id,
      'nextBlockIndex': selected.sourceBlockIds.length,
      'nextPageNumber': boundaryVision,
      'lookaheadState': 'vision_required',
      'plannerVersion': cursor.plannerVersion,
    });
  }

  final nextSliceIndex = index + 1;
  final nextSlice = nextSliceIndex < slices.length
      ? slices[nextSliceIndex]
      : null;
  if (nextSlice == null) {
    return SliceCursor.fromJson({
      'id': cursor.id,
      'version': cursor.version + 1,
      'stateHash': nextStateHash,
      'libraryId': cursor.libraryId,
      'nodeId': cursor.nodeId,
      'currentSliceId': selected.id,
      'nextBlockIndex': selected.sourceBlockIds.length,
      'nextPageNumber': null,
      'lookaheadState': 'end_of_node',
      'plannerVersion': cursor.plannerVersion,
    });
  }
  return SliceCursor.fromJson({
    'id': cursor.id,
    'version': cursor.version + 1,
    'stateHash': nextStateHash,
    'libraryId': cursor.libraryId,
    'nodeId': cursor.nodeId,
    'currentSliceId': nextSlice.id,
    'nextBlockIndex': 0,
    'nextPageNumber': _firstPageNumber(nextSlice, pageNumbers),
    'lookaheadState': _lookaheadState(nextSlice),
    'plannerVersion': cursor.plannerVersion,
  });
}

void _validateSlices(List<LearningSlice> slices, String nodeId) {
  var expectedOrder = 0;
  final seen = <String>{};
  for (final slice in slices) {
    if (slice.nodeId != nodeId || slice.order != expectedOrder++) {
      throw const FormatException('Slices must match cursor node and order');
    }
    for (final blockId in slice.sourceBlockIds) {
      if (!seen.add(blockId)) {
        throw const FormatException('Slices cannot repeat source blocks');
      }
    }
  }
}

void _validateSlicePages(
  List<LearningSlice> slices,
  Map<String, int> pageNumbers,
) {
  for (final slice in slices) {
    for (final pageId in slice.pageIds) {
      if (!pageNumbers.containsKey(pageId)) {
        throw const FormatException('Slice points at unknown page');
      }
    }
    if (slice.nextVisionRequiredAt != null &&
        !pageNumbers.containsValue(slice.nextVisionRequiredAt)) {
      throw const FormatException('Slice points at unknown Vision page');
    }
  }
}

LearningSlice? _firstVisible(List<LearningSlice> slices, int? nextPageNumber) {
  if (nextPageNumber == null) return slices.first;
  for (final slice in slices) {
    if (_visibleOrNull(slice, nextPageNumber) != null) return slice;
  }
  return null;
}

LearningSlice? _visibleOrNull(LearningSlice slice, int? nextPageNumber) {
  if (nextPageNumber == null) return slice;
  final boundaryVision = slice.nextVisionRequiredAt;
  return boundaryVision != null && boundaryVision < nextPageNumber
      ? null
      : slice;
}

String _lookaheadState(LearningSlice slice) => 'ready';

int? _nextBlockPageNumber(
  String blockId,
  Map<String, String>? blockPageIds,
  LearningSlice selected,
  Map<String, int>? pageNumbers,
) {
  final pageId = blockPageIds?[blockId];
  if (pageId == null || pageNumbers == null) {
    return _firstPageNumber(selected, pageNumbers);
  }
  final page = pageNumbers[pageId];
  if (page == null) {
    throw const FormatException('Slice points at unknown page');
  }
  return page;
}

int? _firstPageNumber(LearningSlice slice, Map<String, int>? pageNumbers) {
  if (pageNumbers == null) return null;
  int? result;
  for (final pageId in slice.pageIds) {
    final page = pageNumbers[pageId];
    if (page == null) {
      throw const FormatException('Slice points at unknown page');
    }
    result = result == null || page < result ? page : result;
  }
  return result;
}

void _text(String value, String field) {
  if (value.trim().isEmpty) throw FormatException('$field is required');
}

void _hash(String value, String field) {
  if (!_sha256.hasMatch(value)) {
    throw FormatException('$field must be lowercase SHA-256 hex');
  }
}
