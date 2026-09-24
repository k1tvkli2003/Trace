import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'bounded plan covers ordered blocks across two pages without replay',
    () {
      final plan = planLearningSlices(
        nodeId: 'node-1',
        version: 1,
        plannerVersion: 'planner-v1',
        nodeStartPage: 1,
        nodeEndPage: 2,
        blocks: [
          _block('b1', 'p1', 0, 'heading', 'One'),
          _block('b2', 'p1', 1, 'paragraph', 'A'),
          _block('b3', 'p1', 2, 'paragraph', 'B'),
          _block('b4', 'p2', 0, 'paragraph', 'C'),
        ],
        completePageIds: {'p1', 'p2'},
        pageNumbers: {'p1': 1, 'p2': 2},
        maxBlocksPerSlice: 2,
      );
      expect(plan.slices.map((slice) => slice.sourceBlockIds), [
        ['b1', 'b2'],
        ['b3', 'b4'],
      ]);
      expect(plan.slices.map((slice) => slice.boundaryReason), [
        'max_blocks',
        'end_of_node',
      ]);
      expect(plan.slices.map((slice) => slice.pageIds), [
        ['p1'],
        ['p1', 'p2'],
      ]);
      expect(plan.nextVisionRequiredAt, isNull);
      expect(plan.nextBlockIndex, 4);
    },
  );

  test('missing page stops plan before later cached page', () {
    final plan = planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 3,
      blocks: [
        _block('b1', 'p1', 0, 'paragraph', 'A'),
        _block('b3', 'p3', 0, 'paragraph', 'C'),
      ],
      completePageIds: {'p1', 'p3'},
      pageNumbers: {'p1': 1, 'p2': 2, 'p3': 3},
    );
    expect(plan.slices.single.sourceBlockIds, ['b1']);
    expect(plan.slices.single.boundaryReason, 'vision_required');
    expect(plan.slices.single.nextVisionRequiredAt, 2);
    expect(plan.nextVisionRequiredAt, 2);
    expect(plan.nextBlockIndex, 1);
  });

  test(
    'first missing page produces no slice and explicit next Vision page',
    () {
      final plan = planLearningSlices(
        nodeId: 'node-1',
        version: 1,
        plannerVersion: 'planner-v1',
        nodeStartPage: 1,
        nodeEndPage: 2,
        blocks: [_block('b2', 'p2', 0, 'paragraph', 'B')],
        completePageIds: {'p2'},
        pageNumbers: {'p1': 1, 'p2': 2},
      );
      expect(plan.slices, isEmpty);
      expect(plan.nextVisionRequiredAt, 1);
      expect(plan.nextBlockIndex, 0);
    },
  );

  test('figure and its caption remain together at block cap', () {
    final plan = planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 2,
      blocks: [
        _block('figure-1', 'p1', 0, 'figure', ''),
        _block('caption-1', 'p1', 1, 'caption', 'Caption'),
        _block('explain-1', 'p2', 0, 'paragraph', 'Explanation'),
      ],
      completePageIds: {'p1', 'p2'},
      pageNumbers: {'p1': 1, 'p2': 2},
      maxBlocksPerSlice: 1,
      requiredPageIdsByBlockId: {
        'figure-1': {'p2'},
      },
    );
    expect(plan.slices.first.sourceBlockIds, ['figure-1', 'caption-1']);
    expect(plan.slices.last.sourceBlockIds, ['explain-1']);
  });

  test('earliest missing page wins over a later figure dependency', () {
    final plan = planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 9,
      blocks: [
        _block('b1', 'p1', 0, 'paragraph', 'A'),
        _block('figure-1', 'p1', 1, 'figure', ''),
      ],
      completePageIds: {'p1', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8'},
      pageNumbers: {for (var page = 1; page <= 9; page++) 'p$page': page},
      requiredPageIdsByBlockId: {'figure-1': {'p9'}},
    );
    expect(plan.slices.single.sourceBlockIds, ['b1']);
    expect(plan.slices.single.nextVisionRequiredAt, 2);
    expect(plan.nextVisionRequiredAt, 2);
  });

  test('missing figure dependency blocks it and reports required page', () {
    final plan = planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 2,
      blocks: [_block('figure-1', 'p1', 0, 'figure', '')],
      completePageIds: {'p1'},
      pageNumbers: {'p1': 1, 'p2': 2},
      requiredPageIdsByBlockId: {
        'figure-1': {'p2'},
      },
    );
    expect(plan.slices, isEmpty);
    expect(plan.nextVisionRequiredAt, 2);
  });

  test('caption after a non-figure cannot bypass block cap', () {
    final plan = planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 1,
      blocks: [
        _block('b1', 'p1', 0, 'paragraph', 'A'),
        _block('c1', 'p1', 1, 'caption', 'Caption'),
      ],
      completePageIds: {'p1'},
      pageNumbers: {'p1': 1},
      maxBlocksPerSlice: 1,
    );
    expect(plan.slices.map((slice) => slice.sourceBlockIds), [
      ['b1'],
      ['c1'],
    ]);
  });

  test('source wording change changes slice contentHash', () {
    SlicePlan make(String text) => planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 1,
      blocks: [_block('b1', 'p1', 0, 'paragraph', text)],
      completePageIds: {'p1'},
      pageNumbers: {'p1': 1},
    );
    expect(
      make('A').slices.single.contentHash,
      isNot(make('B').slices.single.contentHash),
    );
  });

  test('rejects duplicate blocks and unsupported source kind', () {
    SlicePlan make(List<SourceBlock> blocks) => planLearningSlices(
      nodeId: 'node-1',
      version: 1,
      plannerVersion: 'planner-v1',
      nodeStartPage: 1,
      nodeEndPage: 1,
      blocks: blocks,
      completePageIds: {'p1'},
      pageNumbers: {'p1': 1},
    );
    final block = _block('b1', 'p1', 0, 'paragraph', 'A');
    expect(() => make([block, block]), throwsFormatException);
    expect(
      () => make([_block('b1', 'p1', 0, 'future_kind', 'A')]),
      throwsFormatException,
    );
  });
}

SourceBlock _block(
  String id,
  String pageId,
  int order,
  String kind,
  String text,
) => SourceBlock.fromJson({
  'id': id,
  'documentId': 'doc-1',
  'pageId': pageId,
  'version': 1,
  'sourceHash': 'e' * 64,
  'order': order,
  'kind': kind,
  'rawText': text,
  'normalizedText': text,
});
