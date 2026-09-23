import 'package:flutter/material.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';

/// A source reader: neither generated lesson nor PDF extraction.
class SourceReadingPage extends StatefulWidget {
  const SourceReadingPage({
    super.key,
    required this.sourceName,
    required this.sourceId,
    required this.sourceHash,
    required this.text,
    required this.markdown,
  });

  final String sourceName;
  final String sourceId;
  final String sourceHash;
  final String text;
  final bool markdown;

  @override
  State<SourceReadingPage> createState() => _SourceReadingPageState();
}

class _SourceReadingPageState extends State<SourceReadingPage> {
  late final SourceOutline outline;
  int selected = 0;

  @override
  void initState() {
    super.initState();
    outline = SourceOutline.parse(
      sourceId: widget.sourceId,
      sourceName: widget.sourceName,
      text: widget.text,
      markdown: widget.markdown,
    );
  }

  Widget _chapters({VoidCallback? close}) => ListView.builder(
    itemCount: outline.sections.length,
    itemBuilder: (context, index) {
      final section = outline.sections[index];
      return ListTile(
        selected: selected == index,
        contentPadding: EdgeInsetsDirectional.only(
          start: 16.0 + (section.level > 1 ? 12.0 : 0),
          end: 12,
        ),
        title: Text(
          TraceTypography.displayDigits(section.title),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: RegExp(r'[\u0600-\u06ff]').hasMatch(section.title)
              ? TraceTypography.persian
              : TraceTypography.english,
        ),
        subtitle: Text('Line ${section.startLine}'),
        onTap: () {
          setState(() => selected = index);
          close?.call();
        },
      );
    },
  );

  Widget _reader() {
    if (outline.sections.isEmpty) {
      return const Center(child: Text('This source has no readable text.'));
    }
    final section = outline.sections[selected];
    final persian = RegExp(r'[\u0600-\u06ff]').hasMatch(section.body);
    return SelectionArea(
      child: ListView(
        key: ValueKey(selected),
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'SOURCE READING',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            TraceTypography.displayDigits(section.title),
            style:
                (RegExp(r'[\u0600-\u06ff]').hasMatch(section.title)
                        ? TraceTypography.persian
                        : TraceTypography.english)
                    .copyWith(fontSize: 27, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Source lines ${section.startLine}-${section.endLine} · SHA-256 ${widget.sourceHash.substring(0, 12)}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Divider(height: 40),
          if (section.body.isEmpty)
            const Text('Heading only. No source passage in this section.')
          else
            Directionality(
              textDirection: persian ? TextDirection.rtl : TextDirection.ltr,
              child: SelectableText(
                TraceTypography.displayDigits(section.body),
                style:
                    (persian
                            ? TraceTypography.persian
                            : TraceTypography.english)
                        .copyWith(fontSize: 18, height: 1.85),
              ),
            ),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: selected + 1 < outline.sections.length
                  ? () => setState(() => selected++)
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next section'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Original source only. AI teaching and citations are not available yet.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 700;
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.sourceName, overflow: TextOverflow.ellipsis),
          actions: compact
              ? [
                  Builder(
                    builder: (context) => IconButton(
                      tooltip: 'Show chapters',
                      icon: const Icon(Icons.account_tree_outlined),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ]
              : null,
        ),
        endDrawer: compact
            ? Drawer(
                child: SafeArea(
                  child: _chapters(close: () => Navigator.of(context).pop()),
                ),
              )
            : null,
        body: compact
            ? _reader()
            : Row(
                children: [
                  SizedBox(
                    width: 270,
                    child: Material(
                      color: const Color(0xffe2e7e1),
                      child: _chapters(),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: _reader(),
                      ),
                    ),
                  ),
                ],
              ),
      );
    },
  );
}
