import 'package:flutter/material.dart';
import 'package:trace_domain/trace_domain.dart';

/// Chat-first shell. No generated message or AI request exists in this phase.
class ChatWorkspace extends StatefulWidget {
  const ChatWorkspace({
    super.key,
    required this.entries,
    required this.selectedId,
    required this.onSelect,
    required this.onCreate,
    required this.onOpenSources,
    required this.sourceFuture,
    required this.onReadSource,
    required this.onOpenTeachingStage,
  });

  final List<LibraryEntrySummary> entries;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final VoidCallback onCreate;
  final VoidCallback onOpenSources;
  final Future<List<SourceDocument>>? sourceFuture;
  final ValueChanged<SourceDocument> onReadSource;
  final VoidCallback onOpenTeachingStage;

  @override
  State<ChatWorkspace> createState() => _ChatWorkspaceState();
}

class _ChatWorkspaceState extends State<ChatWorkspace> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _draft = TextEditingController();
  static const _ink = Color(0xff18292d);
  static const _surface = Color(0xfff8faf8);
  static const _muted = Color(0xff637573);
  static const _accent = Color(0xff1f665c);

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Future<void> _newChat() async {
    if (_scaffold.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    if (_draft.text.trim().isNotEmpty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Discard this draft?'),
          content: const Text('This text is not saved as a conversation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Keep writing'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Discard draft'),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }
    _draft.clear();
    widget.onSelect(null);
  }

  void _select(String? id) {
    widget.onSelect(id);
    if (_scaffold.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  Widget _navigation() => Material(
    color: _ink,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22, 20, 18, 24),
            child: Row(
              children: [
                Icon(
                  Icons.auto_stories_outlined,
                  color: Color(0xffbbdcd3),
                  size: 25,
                ),
                SizedBox(width: 12),
                Text(
                  'Trace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: OutlinedButton.icon(
              onPressed: () {
                _newChat();
              },
              icon: const Icon(Icons.edit_square, size: 19),
              label: const Text('New chat'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                alignment: AlignmentDirectional.centerStart,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xff536a69)),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 30, 16, 8),
            child: Text(
              'LIBRARY',
              style: TextStyle(
                color: Color(0xff9fb9b3),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                for (final entry in widget.entries)
                  ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    selected: entry.id == widget.selectedId,
                    selectedTileColor: const Color(0xff304a49),
                    leading: const Icon(
                      Icons.menu_book_outlined,
                      size: 19,
                      color: Color(0xffbfd9d2),
                    ),
                    title: Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => _select(entry.id),
                  ),
                if (widget.entries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No collections yet',
                      style: TextStyle(color: Color(0xffa9c1bc)),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.add, color: Color(0xffbfd9d2)),
                  title: const Text(
                    'New collection',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if (_scaffold.currentState?.isDrawerOpen ?? false) {
                      Navigator.of(context).pop();
                    }
                    widget.onCreate();
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Local workspace\nAI is not connected',
              style: TextStyle(
                color: Color(0xffa9c1bc),
                height: 1.5,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _contextBar(String title) {
    final future = widget.sourceFuture;
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsetsDirectional.fromSTEB(18, 8, 18, 8),
      decoration: const BoxDecoration(
        color: Color(0xffeef4ef),
        border: Border(bottom: BorderSide(color: Color(0xffdfe8e3))),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_tree_outlined, size: 17, color: _accent),
          const SizedBox(width: 8),
          Expanded(
            child: FutureBuilder<List<SourceDocument>>(
              future: future,
              builder: (context, snapshot) {
                final count = snapshot.data?.length;
                final label = count == null
                    ? 'Collection: $title'
                    : count == 0
                    ? 'Collection: $title · No sources yet'
                    : 'Collection: $title · $count source${count == 1 ? '' : 's'}';
                return Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          TextButton(
            onPressed: widget.onOpenSources,
            child: const Text('Manage'),
          ),
        ],
      ),
    );
  }

  Widget _welcome() => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffdfede7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.auto_awesome_outlined, color: _accent),
            ),
            const SizedBox(height: 26),
            Text(
              widget.selectedId == null
                  ? 'What are we learning today?'
                  : 'Your learning workspace.',
              style: const TextStyle(
                fontSize: 33,
                height: 1.13,
                color: _ink,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.selectedId == null
                  ? 'Bring a book into your workspace. Sources stay local, and each chapter remains within reach.'
                  : 'Add a source to begin reading. Your originals stay local; AI teaching waits for its connection.',
              style: const TextStyle(fontSize: 15, height: 1.55, color: _muted),
            ),
            const SizedBox(height: 30),
            _action(
              Icons.create_new_folder_outlined,
              widget.selectedId == null
                  ? 'Create a collection'
                  : 'Open sources',
              widget.selectedId == null
                  ? 'Start a private library for your books'
                  : 'Read originals and import more files',
              widget.selectedId == null
                  ? widget.onCreate
                  : widget.onOpenSources,
            ),
            if (widget.selectedId != null && widget.sourceFuture != null) ...[
              const SizedBox(height: 18),
              FutureBuilder<List<SourceDocument>>(
                future: widget.sourceFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      'Sources unavailable. Reopen this collection.',
                      style: TextStyle(color: _muted),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator(minHeight: 2);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final source in snapshot.data!.take(4))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: const Color(0xffe8f1ec),
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Icon(
                                source.format == SourceDocumentFormat.pdf
                                    ? Icons.picture_as_pdf_outlined
                                    : Icons.article_outlined,
                                color: _accent,
                              ),
                              title: Text(
                                source.relativePath,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                source.format == SourceDocumentFormat.pdf
                                    ? 'PDF · Waiting for Vision'
                                    : 'Verified original · Ready to read',
                              ),
                              trailing:
                                  source.format == SourceDocumentFormat.pdf
                                  ? null
                                  : TextButton(
                                      onPressed: () =>
                                          widget.onReadSource(source),
                                      child: const Text('Read chapter'),
                                    ),
                              onTap: () =>
                                  source.format == SourceDocumentFormat.pdf
                                  ? widget.onOpenSources()
                                  : widget.onReadSource(source),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
            if (widget.selectedId != null) ...[
              const SizedBox(height: 12),
              _action(
                Icons.school_outlined,
                'Preview teaching stage',
                'Offline layout preview · not an AI lesson',
                widget.onOpenTeachingStage,
              ),
            ],
            const SizedBox(height: 25),
            const Text(
              'Import → Read → Ask → Review',
              style: TextStyle(fontSize: 12, color: _muted, letterSpacing: 0.3),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _action(
    IconData icon,
    String title,
    String detail,
    VoidCallback onTap,
  ) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color(0xffdbe5e0)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon, color: _accent, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 13, color: _muted),
          ],
        ),
      ),
    ),
  );

  Widget _composer() => Container(
    color: _surface,
    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 14),
    child: Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 5, bottom: 9),
                child: Text(
                  'AI offline',
                  style: TextStyle(
                    color: _accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 10, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xffcbdad3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    key: const Key('chat-composer'),
                    controller: _draft,
                    maxLines: 3,
                    minLines: 1,
                    maxLength: 4000,
                    textDirection:
                        RegExp(r'[\u0600-\u06ff]').hasMatch(_draft.text)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ask about a source or describe what to learn…',
                      counterText: '',
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.selectedId == null
                            ? widget.onCreate
                            : widget.onOpenSources,
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'Add source',
                      ),
                      const Spacer(),
                      const Tooltip(
                        message: 'Connect OpenCode Go before sending',
                        child: IconButton(
                          key: Key('chat-send'),
                          onPressed: null,
                          icon: Icon(Icons.arrow_upward),
                          tooltip: 'Send message',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'AI is not connected · Draft stays here until you leave this chat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: _muted),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, limits) {
      final compact = limits.maxWidth < 700;
      final title = widget.selectedId == null
          ? 'New conversation'
          : widget.entries
                    .where((e) => e.id == widget.selectedId)
                    .map((e) => e.title)
                    .firstOrNull ??
                'New conversation';
      return Scaffold(
        key: _scaffold,
        backgroundColor: _surface,
        drawer: compact ? Drawer(width: 280, child: _navigation()) : null,
        body: SafeArea(
          child: Row(
            children: [
              if (!compact) SizedBox(width: 264, child: _navigation()),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 62,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xffdfe8e3)),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (compact)
                            IconButton(
                              tooltip: 'Open navigation',
                              onPressed: () =>
                                  _scaffold.currentState?.openDrawer(),
                              icon: const Icon(Icons.menu),
                            ),
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: _ink,
                              ),
                            ),
                          ),
                          if (widget.selectedId != null)
                            IconButton(
                              tooltip: 'Open sources',
                              onPressed: widget.onOpenSources,
                              icon: const Icon(Icons.library_books_outlined),
                            ),
                          const Padding(
                            padding: EdgeInsetsDirectional.only(start: 10),
                            child: Text(
                              '● Local',
                              style: TextStyle(color: _accent, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.selectedId != null) _contextBar(title),
                    Expanded(child: _welcome()),
                    _composer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
