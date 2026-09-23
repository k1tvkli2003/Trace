import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:uuid/uuid.dart';

import 'local_connection.dart';
import 'text_picker.dart';

export 'text_picker.dart' show PickedTextSource;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, this.database, this.pickText});

  /// Injected for tests; production opens an app-private database lazily.
  final TraceDatabase? database;
  final Future<PickedTextSource?> Function()? pickText;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigator = GlobalKey<NavigatorState>();
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  late final TraceDatabase _database;
  late final LocalLibraryRepository _library;
  late final LocalTextSourceRepository _sources;
  late Future<List<LibraryEntrySummary>> _entries;
  Future<List<SourceDocument>>? _selectedSources;
  bool _ownsDatabase = false;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _ownsDatabase = widget.database == null;
    _database = widget.database ?? TraceDatabase(openLocalConnection());
    _library = LocalLibraryRepository(_database);
    _sources = LocalTextSourceRepository(_database);
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
      await _library.putEntry(
        LibraryEntrySummary(id: const Uuid().v4(), title: title.trim()),
      );
      if (mounted) {
        setState(() {
          _entries = _library.listEntries();
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

  Future<void> _openSource(SourceDocument source) async {
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
                onPressed: () => setState(() {
                  _selectedId = null;
                  _selectedSources = null;
                }),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to library'),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FilledButton.icon(
                onPressed: _importText,
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Import text'),
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
    const ink = Color(0xff1b2429);
    return MaterialApp(
      title: 'Trace',
      navigatorKey: _navigator,
      scaffoldMessengerKey: _messenger,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: TraceTypography.english.fontFamily,
        scaffoldBackgroundColor: const Color(0xffedeae2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff264349),
          surface: const Color(0xfff9f7f1),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'packages/trace_design/Inter'),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ink,
          foregroundColor: const Color(0xfff8f3e8),
          title: const Text(
            'TRACE',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 2),
          ),
          actions: [
            TextButton.icon(
              onPressed: _createCollection,
              icon: const Icon(Icons.add),
              label: const Text('New collection'),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
            const SizedBox(width: 16),
          ],
        ),
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
                      onPressed: () => setState(() {
                        _entries = _library.listEntries();
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final entries = snapshot.data!;
            if (entries.isEmpty) {
              return const Center(child: Text('Your library is empty'));
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 700;
                final list = ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 26, 22, 12),
                      child: Text(
                        'YOUR LIBRARY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: Color(0xff9a5230),
                        ),
                      ),
                    ),
                    for (final entry in entries)
                      ListTile(
                        title: Text(entry.title),
                        selected: _selectedId == entry.id,
                        onTap: () => _selectCollection(entry.id),
                      ),
                  ],
                );
                if (narrow) {
                  return _selectedId == null
                      ? list
                      : _sourcePanel(narrow: true);
                }
                return Row(
                  children: [
                    SizedBox(
                      width: 270,
                      child: Material(
                        color: const Color(0xffe2e7e1),
                        child: list,
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: _sourcePanel()),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
