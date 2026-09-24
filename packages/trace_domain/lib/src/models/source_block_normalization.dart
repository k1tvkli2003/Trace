/// Mechanical normalization for Vision or parsed fragments into immutable blocks.
/// Whitespace-only normalization. Never rewrites wording, symbols, or tables.
library;

import 'source_block.dart';
final class SourceFragment {
  const SourceFragment({
    required this.kind,
    required this.text,
    this.bbox,
    this.continuesFromBlockId,
  });

  final String kind;
  final String text;
  final Map<String, Object?>? bbox;
  final String? continuesFromBlockId;
}

const _kinds = <String>{
  'heading', 'paragraph', 'list', 'table',
  'formula', 'caption', 'footnote', 'figure', 'unknown',
};

List<SourceBlock> normalizeSourceBlocks({
  required String documentId,
  required String pageId,
  required int version,
  required String sourceHash,
  required List<SourceFragment> fragments,
}) {
  if (documentId.trim().isEmpty || pageId.trim().isEmpty) {
    throw const FormatException('SourceBlock identity is required');
  }
  if (version < 1) {
    throw const FormatException('version must be a positive integer');
  }
  if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(sourceHash)) {
    throw const FormatException('sourceHash must be lowercase SHA-256 hex');
  }
  if (fragments.isEmpty || fragments.length > 300) {
    throw const FormatException('Fragment count must be 1..300');
  }

  final blocks = <SourceBlock>[];
  for (var index = 0; index < fragments.length; index++) {
    final fragment = fragments[index];
    if (!_kinds.contains(fragment.kind)) {
      throw FormatException('Unsupported fragment kind ${fragment.kind}');
    }
    if (fragment.kind == 'table' && fragment.text.contains('<table')) {
      throw const FormatException('HTML tables are not source blocks');
    }
    if (fragment.kind == 'unknown') {
      throw const FormatException('Unknown fragments stay quarantined');
    }
    blocks.add(
      SourceBlock.fromJson({
        'id': '$pageId-v$version-$index',
        'documentId': documentId,
        'pageId': pageId,
        'version': version,
        'sourceHash': sourceHash,
        'order': index,
        'kind': fragment.kind,
        'rawText': fragment.text,
        'normalizedText': _normalizeWhitespace(fragment.text),
        if (fragment.bbox != null) 'bbox': fragment.bbox,
      }),
    );
  }
  return List.unmodifiable(blocks);
}

String _normalizeWhitespace(String text) =>
    text.split('\n').map((line) => _collapseSpaces(line).trim()).join('\n').trim();

String _collapseSpaces(String line) {
  final buffer = StringBuffer();
  var spaces = 0;
  for (final rune in line.runes) {
    final char = String.fromCharCode(rune);
    if (char == ' ' || char == '\t' || char == '\r') {
      spaces++;
      if (spaces == 1) buffer.write(' ');
      continue;
    }
    spaces = 0;
    buffer.write(char);
  }
  return buffer.toString();
}
