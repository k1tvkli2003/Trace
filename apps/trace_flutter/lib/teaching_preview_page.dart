import 'package:flutter/material.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';

/// Deliberate sample only: never stored as a generated or studied lesson.
class TeachingPreviewPage extends StatelessWidget {
  const TeachingPreviewPage({super.key});

  static final _sample = LessonDocument.fromJson(
    {
      'schemaVersion': 'lesson-ast-v1',
      'sliceId': 'offline-preview',
      'language': 'fa',
      'blocks': [
        {
          'id': 'sample-definition',
          'type': 'definition_box',
          'text':
              'این باکس نمونه فقط چینش یک درس فارسی را نشان می‌دهد؛ محتوای کتاب نیست.',
          'sourceCitationIds': ['sample-citation'],
        },
        {
          'id': 'sample-figure',
          'type': 'figure',
          'figureId': 'sample-figure-id',
          'sourceCitationIds': ['sample-citation'],
        },
        {
          'id': 'sample-figure-explanation',
          'type': 'figure_explanation',
          'figureId': 'sample-figure-id',
          'text':
              'توضیح شکل، پس از تأیید تصویر و منبع، کنار خود شکل نمایش داده می‌شود.',
          'sourceCitationIds': ['sample-citation'],
        },
      ],
    },
    sliceId: 'offline-preview',
    citationIds: {'sample-citation'},
    figureIds: {'sample-figure-id'},
  );

  @override
  Widget build(BuildContext context) => Theme(
    data: TraceTheme.dark(),
    child: Scaffold(
      backgroundColor: TraceColors.canvas,
      appBar: AppBar(
        title: const Text('Offline teaching preview'),
        backgroundColor: TraceColors.canvas,
        foregroundColor: TraceColors.onCanvas,
      ),
      body: Column(
        children: [
          MaterialBanner(
            backgroundColor: TraceColors.panel,
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI artifact not generated',
                  style: TextStyle(color: TraceColors.onCanvas),
                ),
                Text(
                  'Sample content only · no source linked',
                  style: TextStyle(color: TraceColors.muted),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Back',
                  style: TextStyle(color: TraceColors.seaGlass),
                ),
              ),
            ],
          ),
          Expanded(
            child: LessonDocumentView(
              document: _sample,
              citationLocators: const {},
            ),
          ),
        ],
      ),
    ),
  );
}
