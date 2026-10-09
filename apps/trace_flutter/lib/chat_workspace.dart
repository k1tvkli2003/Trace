import 'package:flutter/material.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';

import 'services/ai_route.dart';
import 'services/ai_route_live.dart';

/// Chat-first shell. Composer badge reflects the live dual AI route.
/// Pass [routeProbe] in tests to avoid live localhost probes; production
/// uses the device-local dual-route probe.
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
    required this.onOpenReviewInbox,
    this.routeProbe,
  });

  final List<LibraryEntrySummary> entries;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final VoidCallback onCreate;
  final VoidCallback onOpenSources;
  final Future<List<SourceDocument>>? sourceFuture;
  final ValueChanged<SourceDocument> onReadSource;
  final VoidCallback onOpenTeachingStage;
  final VoidCallback onOpenReviewInbox;
  final AiRouteProbe? routeProbe;

  @override
  State<ChatWorkspace> createState() => _ChatWorkspaceState();
}

class _ChatWorkspaceState extends State<ChatWorkspace> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _draft = TextEditingController();
  bool _showEvidenceRail = false;
  AiRouteStatus? _route;
  static const _ink = TraceColors.onCanvas;
  static const _surface = TraceColors.canvas;
  static const _muted = TraceColors.muted;
  static const _accent = TraceColors.accent;

  @override
  void initState() {
    super.initState();
    _refreshRoute();
  }

  Future<void> _refreshRoute() async {
    final probe =
        widget.routeProbe ?? const LiveAiRouteFetchers().probe();
    final status = await probe.detect();
    if (!mounted) return;
    setState(() => _route = status);
  }

  /// One truth for every route surface: top-bar dot, composer badge, and
  /// footnote all read the same [_route]. No hardcoded 'Local'/offline copy.
  String get _routeTruth {
    final route = _route;
    if (route == null) return 'probing';
    if (route.kind == AiRouteKind.nineRouter) return 'nineRouter';
    if (route.kind == AiRouteKind.localRuntime) return 'localRuntime';
    return 'offline';
  }

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
    key: const Key('signal-console-navigation'),
    color: TraceColors.navigation,
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
                  color: TraceColors.seaGlass,
                  size: 25,
                ),
                SizedBox(width: TraceSpace.s3),
                Text(
                  'Trace',
                  style: TextStyle(
                    color: TraceColors.onCanvas,
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
                foregroundColor: TraceColors.onCanvas,
                side: const BorderSide(color: TraceColors.edge),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 30, 16, 8),
            child: Text(
              'YOUR WORKTREE',
              style: TextStyle(
                color: TraceColors.seaGlass,
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
                    selectedTileColor: TraceColors.navigationSelected,
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: TraceMotion.quick,
                          width: 3,
                          height: 28,
                          decoration: BoxDecoration(
                            color: entry.id == widget.selectedId
                                ? TraceColors.navigationMarker
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Icon(
                          Icons.menu_book_outlined,
                          size: 19,
                          color: TraceColors.seaGlass,
                        ),
                      ],
                    ),
                    title: Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: TraceColors.onCanvas),
                    ),
                    onTap: () => _select(entry.id),
                  ),
                if (widget.entries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No collections yet',
                      style: TextStyle(color: TraceColors.navigationMuted),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.add, color: TraceColors.seaGlass),
                  title: const Text(
                    'New collection',
                    style: TextStyle(color: TraceColors.onCanvas),
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
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              _routeTruth == 'offline'
                  ? 'Local workspace\nAI offline — library stays on this device'
                  : _routeTruth == 'nineRouter'
                      ? 'Local workspace\nAI online via 9Router'
                      : _routeTruth == 'localRuntime'
                          ? 'Local workspace\nAI online via local runtime'
                          : 'Local workspace\nChecking AI route…',
              style: TextStyle(
                color: TraceColors.seaGlass,
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
        color: TraceColors.context,
        border: Border(bottom: BorderSide(color: TraceColors.edge)),
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

  Widget _welcome() => Material(
    key: const Key('signal-console-stage'),
    color: TraceColors.canvas,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PRIVATE WORKSPACE',
                style: TextStyle(
                  color: TraceColors.seaGlass,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: TraceSpace.s6),
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
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.55,
                  color: _muted,
                ),
              ),
              const SizedBox(height: 30),
              _action(
                Icons.create_new_folder_outlined,
                widget.selectedId == null
                    ? 'Create a collection'
                    : 'Open sources',
                widget.selectedId == null
                    ? 'Start a private library for your books'
                    : 'Import a source or open your originals',
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
                              color: TraceColors.panel,
                              borderRadius: BorderRadius.circular(
                                TraceRadius.panel,
                              ),
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
                  Icons.history_outlined,
                  'Open review inbox',
                  'Due lessons from cache · no AI call',
                  widget.onOpenReviewInbox,
                ),
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
                style: TextStyle(
                  fontSize: 12,
                  color: _muted,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
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
    color: TraceColors.panel,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TraceRadius.panel),
      side: const BorderSide(color: TraceColors.edge),
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

  Widget _evidenceRail() => Material(
    key: const Key('evidence-rail'),
    color: TraceColors.rail,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24, 28, 16, 6),
          child: Text(
            'SOURCE INDEX',
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 16, 18),
          child: Text(
            'Your originals',
            style: TextStyle(
              color: _ink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<SourceDocument>>(
            future: widget.sourceFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Sources unavailable. Open sources to retry.'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No sources imported yet'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final source = snapshot.data![index];
                  final ready = source.format != SourceDocumentFormat.pdf;
                  return ListTile(
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      24,
                      12,
                      20,
                      12,
                    ),
                    title: Text(
                      source.relativePath,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        ready
                            ? 'Original · Ready to read'
                            : 'PDF · Waiting for Vision',
                        style: const TextStyle(color: _muted),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: ready
                        ? () => widget.onReadSource(source)
                        : widget.onOpenSources,
                  );
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(18),
          child: OutlinedButton.icon(
            onPressed: widget.onOpenSources,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Manage sources'),
          ),
        ),
      ],
    ),
  );

  Widget _composer() => Material(
    key: const Key('signal-console-composer'),
    color: TraceColors.panel,
    child: Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 34),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 5, bottom: 9),
                  child: GestureDetector(
                    onTap: _refreshRoute,
                    child: Text(
                      _route?.label ?? 'AI …',
                      style: const TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 10, 8),
                decoration: BoxDecoration(
                  color: TraceColors.canvas,
                  border: Border.all(color: TraceColors.edge),
                  borderRadius: BorderRadius.circular(TraceRadius.stage),
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
                        hintText:
                            'Draft notes on this device… (chat send is unavailable in this build)',
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
                        Tooltip(
                          message: _route == null
                              ? 'Probing AI routes on this device'
                              : _route!.online
                                  ? '${_route!.detail} Chat send is unavailable in this build — imports and reading keep working.'
                                  : _route!.detail,
                          child: IconButton(
                            key: const Key('chat-send'),
                            // Truthful dead end: no chat thread/message
                            // repository exists yet. The button announces
                            // itself as unavailable (never "Send message")
                            // instead of pretending an AI reply will arrive.
                            onPressed: null,
                            icon: const Icon(Icons.arrow_upward),
                            tooltip: 'Send unavailable — chat threads are not in this build',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              _ComposerFootnote(truth: _routeTruth),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, limits) {
      final compact = TraceGeometry.isCompact(limits.maxWidth);
      final sourceRailFits = TraceGeometry.canShowEvidenceRail(limits.maxWidth);
      final title = widget.selectedId == null
          ? 'New conversation'
          : widget.entries
                    .where((e) => e.id == widget.selectedId)
                    .map((e) => e.title)
                    .firstOrNull ??
                'New conversation';
      return Theme(
        data: TraceTheme.dark(),
        child: Scaffold(
          key: _scaffold,
          backgroundColor: _surface,
          drawer: compact ? Drawer(width: 280, child: _navigation()) : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!compact)
                  SizedBox(
                    width: TraceGeometry.navigationWidth,
                    child: _navigation(),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 62,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: const BoxDecoration(
                          color: TraceColors.canvas,
                          border: Border(
                            bottom: BorderSide(color: TraceColors.edge),
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
                            if (sourceRailFits && widget.selectedId != null)
                              IconButton(
                                tooltip: _showEvidenceRail
                                    ? 'Hide source rail'
                                    : 'Show source rail',
                                onPressed: () => setState(
                                  () => _showEvidenceRail = !_showEvidenceRail,
                                ),
                                icon: Icon(
                                  _showEvidenceRail
                                      ? Icons.view_sidebar
                                      : Icons.view_sidebar_outlined,
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 10),
                              child: _RouteDot(truth: _routeTruth),
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
                if (sourceRailFits &&
                    _showEvidenceRail &&
                    widget.selectedId != null)
                  SizedBox(
                    width: TraceGeometry.evidenceWidth(limits.maxWidth),
                    child: _evidenceRail(),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Top-bar dot mirrors the composer badge truth: probing / nineRouter /
/// localRuntime / offline. No independent 'Local' claim.
final class _RouteDot extends StatelessWidget {
  const _RouteDot({required this.truth});
  final String truth;

  @override
  Widget build(BuildContext context) {
    final label = switch (truth) {
      'nineRouter' => '● 9Router',
      'localRuntime' => '● Local',
      'offline' => '○ Offline',
      _ => '● …',
    };
    return Text(
      label,
      style: const TextStyle(color: TraceColors.accent, fontSize: 12),
    );
  }
}

/// Footnote mirrors the same truth; offline copy never claims AI online.
final class _ComposerFootnote extends StatelessWidget {
  const _ComposerFootnote({required this.truth});
  final String truth;

  @override
  Widget build(BuildContext context) {
    final copy = switch (truth) {
      'nineRouter' => 'Online via 9Router · Draft stays on this device',
      'localRuntime' => 'Online via local runtime · Draft stays on this device',
      'offline' => 'Offline · Draft stays on this device',
      _ => 'Checking AI route… · Draft stays on this device',
    };
    return Text(
      copy,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 11, color: TraceColors.muted),
    );
  }
}
