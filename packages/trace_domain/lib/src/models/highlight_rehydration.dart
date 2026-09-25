/// Ordered highlight rehydration. Offsets alone never define identity.
///
/// Order: exact block plus hash, quote inside the verified block, prefix and
/// suffix disambiguation, page plus bbox fallback, then detached. Whitespace
/// differences collapse; wording, Yeh/Kaf, and symbols are never rewritten.
///
/// A hash mismatch means the source changed: the anchor becomes a detached
/// repair candidate keeping its last-known offsets when both bboxes exist.
/// A matching hash with an absent quote means corrupt evidence: detached.
library;

import 'highlight_anchor.dart';
import 'source_block.dart';

enum HighlightRehydrationKind {
  exactBlockHashQuote('exact-block-hash-quote'),
  quoteInsideVerifiedBlock('quote-inside-verified-block'),
  prefixSuffixDisambiguation('prefix-suffix-disambiguation'),
  pageBboxFallback('page-bbox-fallback'),
  quoteAbsent('quote-absent');

  const HighlightRehydrationKind(this.reason);
  final String reason;
}

final class HighlightRehydration {
  const HighlightRehydration({
    required this.attached,
    required this.reason,
    required this.startOffset,
    required this.endOffset,
    required this.pageBboxFallback,
  });

  final bool attached;
  final String reason;
  final int startOffset;
  final int endOffset;
  final bool pageBboxFallback;
}

HighlightRehydration rehydrateHighlight({
  required HighlightAnchor anchor,
  required String blockId,
  required String pageId,
  required String sourceHash,
  required String sourceText,
  required NormalizedBox? blockBbox,
}) {
  HighlightRehydration detached(String reason, {bool fallback = false}) =>
      HighlightRehydration(
        attached: false,
        reason: reason,
        startOffset: anchor.startOffset,
        endOffset: anchor.endOffset,
        pageBboxFallback: fallback,
      );

  if (anchor.sourceBlockId != blockId || anchor.pageId != pageId) {
    return detached(HighlightRehydrationKind.quoteAbsent.reason);
  }
  if (anchor.contentHashAtCreation != sourceHash) {
    if (anchor.bbox != null && blockBbox != null) {
      return detached(
        HighlightRehydrationKind.pageBboxFallback.reason,
        fallback: true,
      );
    }
    return detached(HighlightRehydrationKind.quoteAbsent.reason);
  }

  final normalizedSource = _collapse(sourceText);
  final normalizedQuote = _collapse(anchor.quote);
  if (normalizedQuote.isEmpty || !normalizedSource.contains(normalizedQuote)) {
    return detached(HighlightRehydrationKind.quoteAbsent.reason);
  }

  final exactIndex = sourceText.indexOf(anchor.quote);
  if (exactIndex == anchor.startOffset &&
      exactIndex + anchor.quote.length == anchor.endOffset) {
    return HighlightRehydration(
      attached: true,
      reason: HighlightRehydrationKind.exactBlockHashQuote.reason,
      startOffset: anchor.startOffset,
      endOffset: anchor.endOffset,
      pageBboxFallback: false,
    );
  }

  final disambiguated = _prefixSuffixOffset(
    source: sourceText,
    quote: anchor.quote,
    prefix: anchor.prefix,
    suffix: anchor.suffix,
  );
  if (disambiguated != null &&
      (disambiguated.$1 != anchor.startOffset ||
          disambiguated.$2 != anchor.endOffset)) {
    final matches = _offsets(sourceText, anchor.quote).toList();
    if (matches.length > 1) {
      return HighlightRehydration(
        attached: true,
        reason: HighlightRehydrationKind.prefixSuffixDisambiguation.reason,
        startOffset: disambiguated.$1,
        endOffset: disambiguated.$2,
        pageBboxFallback: false,
      );
    }
  }
  if (disambiguated != null) {
    return HighlightRehydration(
      attached: true,
      reason: HighlightRehydrationKind.quoteInsideVerifiedBlock.reason,
      startOffset: disambiguated.$1,
      endOffset: disambiguated.$2,
      pageBboxFallback: false,
    );
  }

  final normalizedIndex = normalizedSource.indexOf(normalizedQuote);
  if (normalizedIndex >= 0) {
    return HighlightRehydration(
      attached: true,
      reason: HighlightRehydrationKind.quoteInsideVerifiedBlock.reason,
      startOffset: normalizedIndex,
      endOffset: normalizedIndex + normalizedQuote.length,
      pageBboxFallback: false,
    );
  }
  return detached(HighlightRehydrationKind.quoteAbsent.reason);
}

(int, int)? _prefixSuffixOffset({
  required String source,
  required String quote,
  required String prefix,
  required String suffix,
}) {
  final candidates = _offsets(source, quote).toList();
  if (candidates.isEmpty) return null;
  if (candidates.length == 1) return candidates.single;
  for (final candidate in candidates) {
    final before = candidate.$1 >= prefix.length
        ? source.substring(candidate.$1 - prefix.length, candidate.$1)
        : source.substring(0, candidate.$1);
    final afterEnd = candidate.$2 + suffix.length <= source.length
        ? candidate.$2 + suffix.length
        : source.length;
    final after = source.substring(candidate.$2, afterEnd);
    if (before.endsWith(prefix) && after.startsWith(suffix)) return candidate;
  }
  return candidates.first;
}

Iterable<(int, int)> _offsets(String source, String quote) sync* {
  var start = source.indexOf(quote);
  while (start >= 0) {
    yield (start, start + quote.length);
    start = source.indexOf(quote, start + 1);
  }
}

String _collapse(String text) => text
    .split('\n')
    .map((line) => _collapseSpaces(line).trim())
    .join('\n')
    .trim();

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
