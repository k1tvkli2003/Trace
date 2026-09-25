import 'package:flutter/material.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';

import 'app/review_inbox_view_model.dart';

/// Cache-only review surface. Never generates a lesson or calls AI.
class ReviewInboxPage extends StatefulWidget {
  const ReviewInboxPage({super.key, required this.database, this.nowUtc});

  final TraceDatabase database;
  final DateTime Function()? nowUtc;

  @override
  State<ReviewInboxPage> createState() => _ReviewInboxPageState();
}

class _ReviewInboxPageState extends State<ReviewInboxPage> {
  late final ReviewInboxViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = ReviewInboxViewModel(
      LocalReviewInboxRepository(widget.database),
      nowUtc: widget.nowUtc,
    );
    _model.load();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: TraceTheme.dark(),
    child: Scaffold(
      backgroundColor: TraceColors.canvas,
      appBar: AppBar(
        title: const Text('Review inbox · cached only'),
        backgroundColor: TraceColors.canvas,
        foregroundColor: TraceColors.onCanvas,
      ),
      body: ListenableBuilder(
        listenable: _model,
        builder: (context, _) => _body(),
      ),
    ),
  );

  Widget _body() {
    final opened = _model.opened;
    if (opened != null) return _lesson(opened);
    switch (_model.status) {
      case ReviewInboxStatus.idle:
      case ReviewInboxStatus.loading:
      case ReviewInboxStatus.opening:
        return const Center(child: CircularProgressIndicator());
      case ReviewInboxStatus.failed:
        return _error();
      case ReviewInboxStatus.ready:
      case ReviewInboxStatus.opened:
        if (_model.items.isEmpty) {
          return const Center(
            child: Text(
              'No reviews are due. Finish a lesson first.',
              key: Key('review-inbox-empty'),
            ),
          );
        }
        return _list(_model.items);
    }
  }

  Widget _error() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _model.errorMessage ?? 'Reviews unavailable.',
          key: const Key('review-inbox-error'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _model.load,
          child: const Text('Retry offline'),
        ),
      ],
    ),
  );

  Widget _list(List<ReviewItem> items) => ListView.separated(
    key: const Key('review-inbox-list'),
    padding: const EdgeInsets.all(20),
    itemCount: items.length,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (context, index) {
      final item = items[index];
      return ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: TraceColors.edge),
        ),
        title: Text('Lesson due · ${item.id}'),
        subtitle: Text('Due ${item.rawDueAt} · offline cache'),
        trailing: TextButton(
          onPressed: () => _model.open(item.id),
          child: const Text('Open cached lesson'),
        ),
      );
    },
  );

  Widget _lesson(CachedReviewLesson replay) => Column(
    children: [
      MaterialBanner(
        backgroundColor: TraceColors.panel,
        content: Text(
          'Cached lesson · SHA ${replay.artifact.contentHash.substring(0, 12)} · Source hash verified',
          style: const TextStyle(color: TraceColors.onCanvas),
        ),
        actions: [
          TextButton(
            onPressed: _model.load,
            child: const Text(
              'Back to due list',
              style: TextStyle(color: TraceColors.seaGlass),
            ),
          ),
        ],
      ),
      Expanded(
        child: LessonDocumentView(
          key: const Key('review-cached-lesson'),
          document: replay.artifact.lesson,
          citationLocators: {
            for (final entry in replay.citations.entries)
              entry.key: '${entry.value.locator} · ${entry.value.sourceName}',
          },
          onOpenCitation: (citationId) {
            final evidence = replay.citations[citationId];
            if (evidence == null) return;
            showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Source evidence'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${evidence.sourceName} · ${evidence.locator}'),
                      const SizedBox(height: 12),
                      SelectableText(evidence.quote),
                      const SizedBox(height: 12),
                      Text('Page ID: ${evidence.citation.pageId}'),
                      Text(
                        'Source ID: ${evidence.sourceId}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}
