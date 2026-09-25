import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:uuid/uuid.dart';

import 'local_connection.dart';
import 'text_picker.dart';
import 'pdf_picker.dart';
import 'source_reading_page.dart';
import 'chat_workspace.dart';
import 'teaching_preview_page.dart';

export 'text_picker.dart' show PickedTextSource;
export 'pdf_picker.dart' show PickedPdfSource;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, this.database, this.pickText, this.pickPdf});

  /// Injected for tests; production opens an app-private database lazily.
  final TraceDatabase? database;
  final Future<PickedTextSource?> Function()? pickText;
  final Future<PickedPdfSource?> Function()? pickPdf;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigator = GlobalKey<NavigatorState>();
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  late final TraceDatabase _database;
  late final LocalLibraryRepository _library;
  late final LocalTextSourceRepository _sources;
  late final LocalPdfSourceRepository _pdfSources;
  late Future<List<LibraryEntrySummary>> _entries;
  Future<List<SourceDocument>>? _selectedSources;
  bool _ownsDatabase = false;
  bool _pdfImporting = false;
  StateSetter? _panelRefresh;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _ownsDatabase = widget.database == null;
    _database = widget.database ?? TraceDatabase(openLocalConnection());
    _library = LocalLibraryRepository(_database);
    _sources = LocalTextSourceRepository(_database);
    _pdfSources = LocalPdfSourceRepository(_database);
    _entries = _library.listEntries();
  }

  @override
  void dispose() {
    if (_ownsDatabase) {
      _database.close();
    }
    super.dispose();
  }

  Future<void> _createCollection() async {
    var draft = '';
    try {
      final title = await showDialog<String>(
        context: _navigator.currentContext!,
        builder: (dialogContext) => AlertDialog(
          title: const Text('New collection'),
          content: TextField(
            key: const Key('collection-title'),
            onChanged: (value) => draft = value,
            autofocus: true,
            maxLength: 160,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Collection name'),
            onSubmitted: (value) => Navigator.pop(dialogContext, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, draft),
              child: const Text('Create collection'),
            ),
          ],
        ),
      );
      if (!mounted || title == null || title.trim().isEmpty) {
        return;
      }
      final id = const Uuid().v4();
      await _library.putEntry(LibraryEntrySummary(id: id, title: title.trim()));
      if (mounted) {
        setState(() {
          _entries = _library.listEntries();
          _selectedId = id;
          _selectedSources = _sources.listForLibrary(id);
        });
      }
    } catch (_) {
      if (mounted) {
        _messenger.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Could not save collection. Try again.'),
          ),
        );
      }
    }
  }

  void _selectCollection(String id) {
    setState(() {
      _selectedId = id;
      _selectedSources = _sources.listForLibrary(id);
    });
  }

  Future<void> _importText() async {
    final libraryId = _selectedId;
    if (libraryId == null) return;
    try {
      final picked = await (widget.pickText ?? pickTextSource)();
      if (picked == null) return;
      await _sources.importText(
        libraryId: libraryId,
        name: picked.name,
        bytes: picked.bytes,
      );
      if (mounted && _selectedId == libraryId) {
        setState(() {
          _selectedSources = _sources.listForLibrary(libraryId);
        });
        _panelRefresh?.call(() {});
      }
    } catch (error) {
      if (mounted) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              error is FormatException
                  ? 'Unsupported text file, invalid UTF-8, or file exceeds 8 MB.'
                  : 'Import could not be confirmed. Reopen collection before retrying.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _importPdf() async {
    final libraryId = _selectedId;
    if (libraryId == null || _pdfImporting) return;
    setState(() => _pdfImporting = true);
    try {
      final picked = await (widget.pickPdf ?? pickPdfSource)();
      if (picked == null) return;
      await _pdfSources.importPdf(
        libraryId: libraryId,
        name: picked.name,
        bytes: picked.bytes,
      );
      if (mounted && _selectedId == libraryId) {
        setState(() {
          _selectedSources = _sources.listForLibrary(libraryId);
        });
        _panelRefresh?.call(() {});
      }
    } catch (error) {
      if (mounted) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              error is FormatException
                  ? 'Invalid PDF or file exceeds 16 MB.'
                  : 'PDF import could not be confirmed. Reopen collection before retrying.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfImporting = false);
    }
  }

  Future<void> _openSource(SourceDocument source) async {
    if (source.format == SourceDocumentFormat.pdf) {
      try {
        // Verify original before presenting its status; never decode PDF bytes as text.
        await _pdfSources.readOriginal(source.id);
        if (!mounted) return;
        await showDialog<void>(
          context: _navigator.currentContext!,
          builder: (context) => AlertDialog(
            title: const Text('PDF original stored'),
            content: const Text(
              'Awaiting page-image Vision. PDF text is not extracted or available for lessons yet.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } catch (_) {
        if (mounted) {
          _messenger.currentState?.showSnackBar(
            const SnackBar(content: Text('Cannot verify PDF original.')),
          );
        }
      }
      return;
    }
    try {
      final bytes = await _sources.readOriginal(source.id);
      if (!mounted) return;
      final original = utf8.decode(bytes, allowMalformed: false);
      final preview = original.length > 20000
          ? '${original.substring(0, 20000)}\n\n[Preview ends; original remains stored intact]'
          : original;
      final persian = RegExp(r'[\u0600-\u06ff]').hasMatch(preview);
      await showDialog<void>(
        context: _navigator.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('RAW SOURCE'),
          content: SizedBox(
            width: 620,
            height: 450,
            child: SingleChildScrollView(
              child: SelectableText(
                TraceTypography.displayDigits(preview),
                textDirection: persian ? TextDirection.rtl : TextDirection.ltr,
                style: persian
                    ? TraceTypography.persian
                    : TraceTypography.english,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (_) {
      if (mounted) {
        _messenger.currentState?.showSnackBar(
          const SnackBar(content: Text('Cannot verify source original.')),
        );
      }
    }
  }

  Future<void> _startReading(SourceDocument source) async {
    if (source.format != SourceDocumentFormat.markdown &&
        source.format != SourceDocumentFormat.text) {
      return;
    }
    try {
      // Repository verifies immutable original bytes against source hash.
      final bytes = await _sources.readOriginal(source.id);
      final text = utf8.decode(bytes, allowMalformed: false);
      if (!mounted) return;
      await Navigator.of(_navigator.currentContext!).push(
        MaterialPageRoute<void>(
          builder: (context) => SourceReadingPage(
            sourceName: source.relativePath,
            sourceId: source.id,
            sourceHash: source.sourceHash,
            text: text,
            markdown: source.format == SourceDocumentFormat.markdown,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        _messenger.currentState?.showSnackBar(
          const SnackBar(content: Text('Cannot verify source original.')),
        );
      }
    }
  }

  Future<void> _openTeachingPreview() async {
    if (!mounted || _selectedId == null) return;
    await Navigator.of(_navigator.currentContext!).push(
      MaterialPageRoute<void>(
        builder: (context) => const TeachingPreviewPage(),
      ),
    );
  }

  Future<void> _showSources() async {
    if (_selectedId == null || !mounted) return;
    try {
      await showDialog<void>(
        context: _navigator.currentContext!,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 760,
              maxHeight: MediaQuery.sizeOf(context).height * .86,
            ),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 32,
              height: MediaQuery.sizeOf(context).height * .8,
              child: StatefulBuilder(
                builder: (context, refresh) {
                  _panelRefresh = refresh;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          20,
                          8,
                          8,
                          4,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Sources',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              tooltip: 'Close sources',
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _sourcePanel()),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    } finally {
      _panelRefresh = null;
    }
  }

  Widget _sourcePanel({bool narrow = false}) {
    if (_selectedId == null) {
      return const Center(child: Text('Choose a collection'));
    }
    return FutureBuilder<List<SourceDocument>>(
      future: _selectedSources,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: () => _selectCollection(_selectedId!),
              child: const Text('Could not read sources · Retry'),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            if (narrow)
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to chat'),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _importText,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Import text'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _pdfImporting ? null : _importPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text(
                      _pdfImporting ? 'Importing PDF…' : 'Import PDF',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: snapshot.data!.isEmpty
                  ? const Center(child: Text('No sources imported yet'))
                  : ListView(
                      children: [
                        for (final source in snapshot.data!)
                          ListTile(
                            leading: const Icon(Icons.description_outlined),
                            title: Text(
                              '${TraceTypography.displayDigits(source.relativePath)} · v${source.version}',
                            ),
                            onTap: () => _openSource(source),
                            trailing: source.format == SourceDocumentFormat.pdf
                                ? null
                                : TextButton(
                                    onPressed: () => _startReading(source),
                                    child: const Text('Start reading'),
                                  ),
                            subtitle: Text(
                              '${source.byteSize} bytes · SHA-256 ${source.sourceHash.substring(0, 12)}',
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trace',
      navigatorKey: _navigator,
      scaffoldMessengerKey: _messenger,
      theme: TraceTheme.dark(),
      darkTheme: TraceTheme.dark(),
      home: Scaffold(
        body: FutureBuilder<List<LibraryEntrySummary>>(
          future: _entries,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Library unavailable'),
                    TextButton(
                      onPressed: () =>
                          setState(() => _entries = _library.listEntries()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ChatWorkspace(
              entries: snapshot.data!,
              selectedId: _selectedId,
              onSelect: (id) {
                if (id == null) {
                  setState(() {
                    _selectedId = null;
                    _selectedSources = null;
                  });
                } else {
                  _selectCollection(id);
                }
              },
              onCreate: _createCollection,
              onOpenSources: _showSources,
              sourceFuture: _selectedSources,
              onReadSource: _startReading,
              onOpenTeachingStage: _openTeachingPreview,
            );
          },
        ),
      ),
    );
  }
}
