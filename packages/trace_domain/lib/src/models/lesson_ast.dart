/// Versioned, source-bound lesson data. Text is inert; no HTML or widget input.
enum LessonLanguage { fa }

enum LessonBlockType {
  paragraph('paragraph'),
  definitionBox('definition_box'),
  mechanismBox('mechanism_box'),
  tipBox('tip_box'),
  warningBox('warning_box'),
  comparisonTable('comparison_table'),
  formulaBox('formula_box'),
  exampleBox('example_box'),
  figure('figure'),
  figureExplanation('figure_explanation'),
  keyTakeaway('key_takeaway'),
  recallPrompt('recall_prompt');

  const LessonBlockType(this.wireName);
  final String wireName;
}

final class LessonDocument {
  LessonDocument._(this.sliceId, this.blocks);

  static const wireSchemaVersion = 'lesson-ast-v1';
  String get schemaVersion => wireSchemaVersion;
  final String sliceId;
  LessonLanguage get language => LessonLanguage.fa;
  final List<LessonBlock> blocks;

  factory LessonDocument.fromJson(
    Map<String, Object?> json, {
    String? sliceId,
    Set<String>? citationIds,
    Set<String>? figureIds,
  }) {
    _onlyKeys(json, {'schemaVersion', 'sliceId', 'language', 'blocks'});
    if (json['schemaVersion'] != wireSchemaVersion ||
        json['language'] != 'fa') {
      throw const FormatException('Unsupported lesson schema or language');
    }
    final slice = _limitedString(json['sliceId'], 'sliceId', 512);
    if (sliceId != null && slice != sliceId) {
      throw const FormatException('Lesson slice is outside requested scope');
    }
    final rawBlocks = json['blocks'];
    if (rawBlocks is! List || rawBlocks.isEmpty || rawBlocks.length > 48) {
      throw const FormatException('Lesson must contain 1–48 blocks');
    }
    final blocks = <LessonBlock>[];
    final ids = <String>{};
    final figureIdsUsed = <String>{};
    final explanationIds = <String>{};
    for (final raw in rawBlocks) {
      if (raw is! Map<String, Object?>) {
        throw const FormatException('Invalid lesson block');
      }
      final block = LessonBlock.fromJson(raw);
      if (citationIds != null &&
          block.sourceCitationIds.any((id) => !citationIds.contains(id))) {
        throw const FormatException(
          'Lesson cites source outside requested scope',
        );
      }
      if (figureIds != null &&
          block.figureId != null &&
          !figureIds.contains(block.figureId)) {
        throw const FormatException(
          'Lesson cites figure outside requested scope',
        );
      }
      if (block.type == LessonBlockType.figure) {
        if (!figureIdsUsed.add(block.figureId!)) {
          throw const FormatException('Duplicate figure block');
        }
      } else if (block.type == LessonBlockType.figureExplanation) {
        if (!explanationIds.add(block.figureId!)) {
          throw const FormatException('Duplicate figure explanation');
        }
      }
      if (!ids.add(block.id)) {
        throw const FormatException('Duplicate lesson block ID');
      }
      blocks.add(block);
    }
    if (figureIdsUsed.length != explanationIds.length ||
        !figureIdsUsed.containsAll(explanationIds)) {
      throw const FormatException('Figure explanation required');
    }
    return LessonDocument._(slice, List.unmodifiable(blocks));
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'sliceId': sliceId,
    'language': 'fa',
    'blocks': blocks.map((block) => block.toJson()).toList(),
  };
}

final class LessonBlock {
  LessonBlock._({
    required this.id,
    required this.type,
    required this.text,
    required this.figureId,
    required this.sourceCitationIds,
  });

  final String id;
  final LessonBlockType type;
  final String? text;
  final String? figureId;
  final List<String> sourceCitationIds;

  factory LessonBlock.fromJson(Map<String, Object?> json) {
    _onlyKeys(json, {'id', 'type', 'text', 'sourceCitationIds', 'figureId'});
    final id = _limitedString(json['id'], 'id', 512);
    final typeName = json['type'];
    final type = LessonBlockType.values
        .where((t) => t.wireName == typeName)
        .firstOrNull;
    if (type == null) throw const FormatException('Unknown lesson block type');
    final rawCitations = json['sourceCitationIds'];
    if (rawCitations is! List || rawCitations.isEmpty) {
      throw const FormatException('Citation required');
    }
    final citations = <String>[];
    final seen = <String>{};
    for (final raw in rawCitations) {
      final citation = _limitedString(raw, 'sourceCitationId', 512);
      if (!seen.add(citation)) {
        throw const FormatException('Duplicate citation');
      }
      citations.add(citation);
    }
    final figure = json.containsKey('figureId')
        ? _limitedString(json['figureId'], 'figureId', 512)
        : null;
    if (figure != null &&
        type != LessonBlockType.figure &&
        type != LessonBlockType.figureExplanation) {
      throw const FormatException('Unexpected figure reference');
    }
    if (type == LessonBlockType.figure && json.containsKey('text')) {
      throw const FormatException('Figure may not contain text');
    }
    if ((type == LessonBlockType.figure ||
            type == LessonBlockType.figureExplanation) &&
        figure == null) {
      throw const FormatException('Figure reference required');
    }
    final text = type == LessonBlockType.figure
        ? null
        : _limitedString(json['text'], 'text', 3000);
    if (text != null && _unsafeLessonText.hasMatch(text)) {
      throw const FormatException('Unsafe lesson text');
    }
    return LessonBlock._(
      id: id,
      type: type,
      text: text,
      figureId: figure,
      sourceCitationIds: List.unmodifiable(citations),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.wireName,
    if (text != null) 'text': text,
    'sourceCitationIds': sourceCitationIds.toList(),
    if (figureId != null) 'figureId': figureId,
  };
}

String _limitedString(Object? value, String name, int maxLength) {
  if (value is! String ||
      value.isEmpty ||
      value.trim().isEmpty ||
      value.length > maxLength) {
    throw FormatException('Invalid $name');
  }
  return value;
}

final _unsafeLessonText = RegExp(
  r'<\s*/?\s*[a-zA-Z!][^>]*>|\b(?:javascript|data)\s*:',
  caseSensitive: false,
);

void _onlyKeys(Map<String, Object?> value, Set<String> allowed) {
  if (value.keys.any((key) => !allowed.contains(key))) {
    throw const FormatException('Unexpected lesson field');
  }
}
