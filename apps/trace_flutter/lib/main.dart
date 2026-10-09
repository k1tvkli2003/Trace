import 'dart:convert';
import 'dart:io' show HttpClient;

import 'package:flutter/material.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:uuid/uuid.dart';

import 'local_connection.dart';
import 'review_inbox_page.dart';
import 'services/ai_route.dart';
import 'services/trace_auth_client.dart';
import 'sign_in_page.dart';
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
  const MainApp({
    super.key,
    this.database,
    this.pickText,
    this.pickPdf,
    this.routeProbe,
    this.authClient,
    this.authSessionRepository,
    this.startSignedOut = false,
  });

  final AiRouteProbe? routeProbe;

  /// Injected for tests; production opens an app-private database lazily.
  final TraceDatabase? database;
  final Future<PickedTextSource?> Function()? pickText;
  final Future<PickedPdfSource?> Function()? pickPdf;

  /// Injected for tests; production builds the Supabase Auth client and
  /// gateway endpoint from --dart-define TRACE_SUPABASE_URL /
  /// TRACE_SUPABASE_ANON_KEY / TRACE_GATEWAY_URL.
  final TraceAuthClient? authClient;
  final LocalAuthSessionRepository? authSessionRepository;

  /// Test escape hatch: skip restored-session short-circuit.
  final bool startSignedOut;

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
  late final LocalAuthSessionRepository _authSessions;
  late Future<List<LibraryEntrySummary>> _entries;
  Future<List<SourceDocument>>? _selectedSources;
  bool _ownsDatabase = false;
  bool _pdfImporting = false;
  StateSetter? _panelRefresh;
  String? _selectedId;
  TraceAuthSession? _session;
  bool _sessionChecked = false;

  @override
  void initState() {
    super.initState();
    _ownsDatabase = widget.database == null;
    _database = widget.database ?? TraceDatabase(openLocalConnection());
    _library = LocalLibraryRepository(_database);
    _sources = LocalTextSourceRepository(_database);
    _pdfSources = LocalPdfSourceRepository(_database);
    _authSessions =
        widget.authSessionRepository ??
        LocalAuthSessionRepository(_database);
    _entries = _library.listEntries();
    if (!widget.startSignedOut) {
      _restoreSession();
    } else {
      _sessionChecked = true;
    }
  }

  Future<void> _restoreSession() async {
    try {
      final stored = await _authSessions.current();
      if (!mounted || stored == null) {
        if (mounted) setState(() => _sessionChecked = true);
        return;
      }
      if (!stored.isExpired) {
        if (!mounted) return;
        setState(() {
          _session = stored;
          _sessionChecked = true;
        });
        return;
      }
      // Access token expired: try one silent refresh before asking sign-in.
      try {
        final client = widget.authClient ?? _productionAuthClient();
        final refreshed = await client.refreshSession(stored.refreshToken);
        final session = TraceAuthSession(
          email: stored.email,
          accessToken: refreshed.accessToken,
          refreshToken: refreshed.refreshToken,
          expiresAtEpochSeconds: refreshed.expiresAtEpochSeconds,
          userId: refreshed.userId,
        );
        await _authSessions.save(session);
        if (!mounted) return;
        setState(() {
          _session = session;
          _sessionChecked = true;
        });
      } on TraceAuthFailure {
        // Refresh rejected (revoked/rotated): stale session must go.
        await _authSessions.clear();
        if (!mounted) return;
        setState(() => _sessionChecked = true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _sessionChecked = true);
    }
  }

  Future<TraceAuthTokens> _signIn(String email, String password) {
    final client = widget.authClient ?? _productionAuthClient();
    return client.signInOrSignUp(email, password);
  }

  /// Production auth wiring: compile-time endpoint config, runtime http.
  /// Throws a safe failure when the build has no Supabase config so the
  /// sign-in screen explains instead of crashing.
  TraceAuthClient _productionAuthClient() {
    const url = String.fromEnvironment('TRACE_SUPABASE_URL');
    const anonKey = String.fromEnvironment('TRACE_SUPABASE_ANON_KEY');
    if (url.isEmpty || anonKey.isEmpty) {
      throw const TraceAuthFailure('AUTH_SERVICE_UNAVAILABLE');
    }
    return TraceAuthClient(
      supabaseUrl: Uri.parse(url),
      anonKey: anonKey,
      post: _httpPost,
    );
  }

  Future<_HttpAuthResponse> _httpPost(
    Uri uri,
    Map<String, String> headers,
    String body,
  ) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      headers.forEach(request.headers.set);
      request.write(body);
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final text = await response.transform(utf8.decoder).join();
      return _HttpAuthResponse(response.statusCode, text);
    } finally {
      client.close();
    }
  }

  Future<void> _onSignedIn(TraceAuthTokens tokens) async {
    final session = TraceAuthSession(
      email: tokens.email,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresAtEpochSeconds: tokens.expiresAtEpochSeconds,
      userId: tokens.userId,
    );
    await _authSessions.save(session);
    if (!mounted) return;
    setState(() => _session = session);
  }

  Future<void> _signOut() async {
    final previous = _session;
    if (previous != null) {
      try {
        final client = widget.authClient ?? _productionAuthClient();
        await client.signOut(previous.accessToken);
      } catch (_) {
        // Best effort: local state clears regardless.
      }
    }
    await _authSessions.clear();
    if (!mounted) return;
    setState(() => _session = null);
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

  Future<void> _openReviewInbox() async {
    if (!mounted) return;
    await Navigator.of(_navigator.currentContext!).push(
      MaterialPageRoute<void>(
        builder: (context) => ReviewInboxPage(database: _database),
      ),
    );
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
      home: !_sessionChecked
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : _session == null
              ? SignInPage(signIn: _signIn, onSignedIn: _onSignedIn)
              : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      _session!.email,
                      style: const TextStyle(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: _signOut,
                        child: const Text('Sign out'),
                      ),
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
              onOpenReviewInbox: _openReviewInbox,
              routeProbe: widget.routeProbe,
            );
          },
        ),
      ),
    );
  }
}

/// Minimal [TraceAuthHttpResponse] over dart:io. Kept private: only the
/// status code and body string cross into the auth client.
final class _HttpAuthResponse implements TraceAuthHttpResponse {
  const _HttpAuthResponse(this.statusCode, this.body);

  @override
  final int statusCode;

  @override
  final String body;
}
