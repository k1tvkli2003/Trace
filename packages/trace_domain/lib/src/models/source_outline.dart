/// Read-only navigation over an already hash-verified Markdown or TXT original.
/// It is not an AI lesson, PDF transcription, or canonical source rewrite.
final class SourceOutline {
  const SourceOutline(this.sections);

  final List<SourceReadingSection> sections;

  static SourceOutline parse({
    required String sourceId,
    required String sourceName,
    required String text,
    required bool markdown,
  }) {
    if (sourceId.isEmpty || sourceName.isEmpty) {
      throw const FormatException('Source identity is required');
    }
    final lines = text.split('\n');
    final headings = <(int, int, String)>[];
    if (markdown) {
      String? fence;
      var fenceLength = 0;
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index].replaceFirst(RegExp(r'\r$'), '');
        final candidate = line.trimLeft();
        if (line.length - candidate.length <= 3 &&
            candidate.isNotEmpty &&
            (candidate[0] == '`' || candidate[0] == '~')) {
          final mark = candidate[0];
          final count = candidate.split('').takeWhile((c) => c == mark).length;
          if (count >= 3) {
            if (fence == null) {
              fence = mark;
              fenceLength = count;
              continue;
            }
            if (fence == mark &&
                count >= fenceLength &&
                candidate.substring(count).trim().isEmpty) {
              fence = null;
              continue;
            }
          }
        }
        if (fence != null) continue;
        final match = RegExp(
          r'^ {0,3}(#{1,6})(?:[ \t]+(.*)|[ \t]*)$',
        ).firstMatch(line);
        if (match == null) continue;
        final title = (match.group(2) ?? '')
            .replaceFirst(RegExp(r'[ \t]+#+[ \t]*$'), '')
            .trim();
        if (title.isNotEmpty) {
          headings.add((index, match.group(1)!.length, title));
        }
      }
    }
    final sections = <SourceReadingSection>[];
    void add({
      required String title,
      required int level,
      required int start,
      required int bodyStart,
      required int stop,
    }) {
      if (stop < start) return;
      var last = stop;
      while (last >= bodyStart && lines[last].trim().isEmpty) {
        last--;
      }
      final body = last < bodyStart
          ? ''
          : lines.sublist(bodyStart, last + 1).join('\n').trim();
      if (level == 0 && body.isEmpty) return;
      sections.add(
        SourceReadingSection(
          sourceId: sourceId,
          title: title,
          level: level,
          startLine: start + 1,
          endLine: last < bodyStart ? start + 1 : last + 1,
          body: body,
        ),
      );
    }

    if (headings.isEmpty) {
      add(
        title: sourceName,
        level: 0,
        start: 0,
        bodyStart: 0,
        stop: lines.length - 1,
      );
    } else {
      if (headings.first.$1 > 0) {
        add(
          title: 'Before first heading',
          level: 0,
          start: 0,
          bodyStart: 0,
          stop: headings.first.$1 - 1,
        );
      }
      for (var index = 0; index < headings.length; index++) {
        final (start, level, title) = headings[index];
        add(
          title: title,
          level: level,
          start: start,
          bodyStart: start + 1,
          stop: index + 1 < headings.length
              ? headings[index + 1].$1 - 1
              : lines.length - 1,
        );
      }
    }
    return SourceOutline(List.unmodifiable(sections));
  }
}

final class SourceReadingSection {
  const SourceReadingSection({
    required this.sourceId,
    required this.title,
    required this.level,
    required this.startLine,
    required this.endLine,
    required this.body,
  });

  final String sourceId;
  final String title;
  final int level;
  final int startLine;
  final int endLine;
  final String body;
}
