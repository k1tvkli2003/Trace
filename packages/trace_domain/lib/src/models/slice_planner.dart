/// Deterministic planner for cache-backed learning slices.
///
/// This helper never infers concepts, invokes a model, or marks Vision work
/// complete. It only groups supplied, ordered SourceBlocks.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'learning_slice.dart';
import 'source_block.dart';

final class SlicePlan {
  SlicePlan({
    required this.nodeId,
    required this.version,
    required this.plannerVersion,
    required List<LearningSlice> slices,
    required this.nextVisionRequiredAt,
    required this.nextBlockIndex,
  }) : slices = List.unmodifiable(slices);

  final String nodeId;
  final int version;
  final String plannerVersion;
  final List<LearningSlice> slices;
  final int? nextVisionRequiredAt;
  final int nextBlockIndex;
}

SlicePlan planLearningSlices({
  required String nodeId,
  required int version,
  required String plannerVersion,
  required int nodeStartPage,
  required int nodeEndPage,
  required List<SourceBlock> blocks,
  required Set<String> completePageIds,
  required Map<String, int> pageNumbers,
  int maxBlocksPerSlice = 8,
  Map<String, Set<String>> requiredPageIdsByBlockId = const {},
}) {
  _text(nodeId, 'nodeId');
  _text(plannerVersion, 'plannerVersion');
  if (version < 1 || nodeStartPage < 1 || nodeEndPage < nodeStartPage) {
    throw const FormatException('Invalid planner or node page range');
  }
  if (maxBlocksPerSlice < 1) {
    throw const FormatException('maxBlocksPerSlice must be positive');
  }
  _validatePageNumbers(pageNumbers, nodeStartPage, nodeEndPage);
  if (blocks.isEmpty) {
    return SlicePlan(
      nodeId: nodeId,
      version: version,
      plannerVersion: plannerVersion,
      slices: const [],
      nextVisionRequiredAt: _firstMissingPage(
        completePageIds,
        pageNumbers,
        nodeStartPage,
        nodeEndPage,
      ),
      nextBlockIndex: 0,
    );
  }

  final ordered = List<SourceBlock>.from(blocks);
  _validateBlockOrder(ordered, pageNumbers, nodeStartPage, nodeEndPage);

  final firstMissingPage = _firstMissingPage(
    completePageIds,
    pageNumbers,
    nodeStartPage,
    nodeEndPage,
  );
  final result = <LearningSlice>[];
  var cursor = 0;
  var sliceOrder = 0;
  int? nextVisionRequiredAt = firstMissingPage;

  while (cursor < ordered.length) {
    final selected = <SourceBlock>[];
    var boundaryReason = 'end_of_node';
    int? boundaryVisionPage;

    while (cursor < ordered.length) {
      final candidate = ordered[cursor];
      final requiredVisionPage = _requiredVisionPage(
        candidate,
        firstMissingPage: firstMissingPage,
        completePageIds: completePageIds,
        pageNumbers: pageNumbers,
        requiredPageIdsByBlockId: requiredPageIdsByBlockId,
      );
      if (requiredVisionPage != null) {
        boundaryReason = 'vision_required';
        boundaryVisionPage = requiredVisionPage;
        nextVisionRequiredAt ??= requiredVisionPage;
        break;
      }
      if (selected.length >= maxBlocksPerSlice &&
          !(candidate.kind == SourceBlockKind.caption &&
              selected.isNotEmpty &&
              selected.last.kind == SourceBlockKind.figure)) {
        boundaryReason = 'max_blocks';
        break;
      }
      if (selected.isNotEmpty && candidate.kind == SourceBlockKind.heading) {
        boundaryReason = 'heading_boundary';
        break;
      }
      selected.add(candidate);
      cursor++;
    }

    if (selected.isEmpty) break;

    final pageIds = <String>[];
    for (final block in selected) {
      if (!pageIds.contains(block.pageId)) pageIds.add(block.pageId);
    }
    result.add(
      LearningSlice.fromJson({
        'id': '$nodeId-v$version-slice-$sliceOrder',
        'version': version,
        'contentHash': _sliceHash(selected),
        'nodeId': nodeId,
        'order': sliceOrder++,
        'sourceBlockIds': selected.map((block) => block.id).toList(),
        'pageIds': pageIds,
        'conceptIds': const <String>[],
        'estimatedEffort': selected.length,
        'boundaryReason': boundaryReason,
        'nextVisionRequiredAt': boundaryReason == 'vision_required'
            ? boundaryVisionPage
            : null,
      }),
    );
  }

  return SlicePlan(
    nodeId: nodeId,
    version: version,
    plannerVersion: plannerVersion,
    slices: result,
    nextVisionRequiredAt: nextVisionRequiredAt,
    nextBlockIndex: cursor,
  );
}

int? _requiredVisionPage(
  SourceBlock block, {
  required int? firstMissingPage,
  required Set<String> completePageIds,
  required Map<String, int> pageNumbers,
  required Map<String, Set<String>> requiredPageIdsByBlockId,
}) {
  final pageNumber = pageNumbers[block.pageId]!;
  if (firstMissingPage != null && pageNumber >= firstMissingPage) {
    return firstMissingPage;
  }
  if (!completePageIds.contains(block.pageId)) return pageNumber;

  int? result;
  for (final pageId in requiredPageIdsByBlockId[block.id] ?? const <String>{}) {
    if (!completePageIds.contains(pageId)) {
      final requiredPage = pageNumbers[pageId];
      if (requiredPage == null) {
        throw const FormatException('Figure dependency has unknown page');
      }
      result = result == null
          ? requiredPage
          : (requiredPage < result ? requiredPage : result);
    }
  }
  if (result != null && firstMissingPage != null &&
      firstMissingPage < result) {
    return firstMissingPage;
  }
  return result;
}

int? _firstMissingPage(
  Set<String> completePageIds,
  Map<String, int> pageNumbers,
  int start,
  int end,
) {
  for (var page = start; page <= end; page++) {
    final pageIds = pageNumbers.entries
        .where((entry) => entry.value == page)
        .map((entry) => entry.key);
    if (!pageIds.any(completePageIds.contains)) return page;
  }
  return null;
}

void _validatePageNumbers(Map<String, int> pageNumbers, int start, int end) {
  final seenNumbers = <int>{};
  for (final entry in pageNumbers.entries) {
    if (entry.key.trim().isEmpty ||
        entry.value < 1 ||
        !seenNumbers.add(entry.value)) {
      throw const FormatException('Page numbers must be unique and positive');
    }
  }
  for (var page = start; page <= end; page++) {
    if (!seenNumbers.contains(page)) {
      throw FormatException('Missing page number $page in node range');
    }
  }
}

void _validateBlockOrder(
  List<SourceBlock> blocks,
  Map<String, int> pageNumbers,
  int nodeStartPage,
  int nodeEndPage,
) {
  final seenIds = <String>{};
  var previousPage = nodeStartPage;
  var previousOrder = -1;
  String? previousPageId;
  for (final block in blocks) {
    if (block.kind == SourceBlockKind.unsupported || !seenIds.add(block.id)) {
      throw const FormatException('Unsupported or duplicate source block');
    }
    final pageNumber = pageNumbers[block.pageId];
    if (pageNumber == null ||
        pageNumber < nodeStartPage ||
        pageNumber > nodeEndPage) {
      throw const FormatException('Block page is outside node range');
    }
    if (pageNumber < previousPage ||
        (pageNumber == previousPage &&
            previousPageId == block.pageId &&
            block.order <= previousOrder)) {
      throw const FormatException('Blocks must be in reading order');
    }
    if (pageNumber != previousPage) previousOrder = -1;
    previousPage = pageNumber;
    previousPageId = block.pageId;
    previousOrder = block.order;
  }
}

String _sliceHash(List<SourceBlock> blocks) {
  final canonical = blocks.map((block) => jsonEncode(block.toJson())).join('|');
  return sha256.convert(utf8.encode(canonical)).toString();
}

void _text(String value, String field) {
  if (value.trim().isEmpty) throw FormatException('$field is required');
}
