import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trace_domain/trace_domain.dart';

import 'typography.dart';

/// Intent only. Caller owns authorization and durable local mutation.
enum LessonStudyAction { studied, notLearned, later, mastered, skipped }

/// Renders validated, inert lesson data. Missing evidence is never invented.
class LessonDocumentView extends StatelessWidget {
  const LessonDocumentView({
    super.key,
    required this.document,
    required this.citationLocators,
    this.figureBytes = const {},
    this.onOpenCitation,
    this.onStudyAction,
  });

  final LessonDocument document;
  final Map<String, String> citationLocators;
  final Map<String, Uint8List> figureBytes;
  final ValueChanged<String>? onOpenCitation;
  final ValueChanged<LessonStudyAction>? onStudyAction;

  static const _ink = Color(0xff18292d);
  static const _muted = Color(0xff637573);
  static const _edge = Color(0xffdbe5e0);
  static const _accent = Color(0xff1f665c);

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'درس مستند',
                  style: TraceTypography.persian.copyWith(
                    color: _ink,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ارجاع هر بخش را در منبع اصلی بررسی کنید',
                  style: TraceTypography.persian.copyWith(color: _muted),
                ),
                const SizedBox(height: 22),
                for (final block in document.blocks) ...[
                  _block(context, block),
                  const SizedBox(height: 14),
                ],
                const Divider(color: _edge, height: 32),
                _actions(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _block(BuildContext context, LessonBlock block) {
    final accent = switch (block.type) {
      LessonBlockType.warningBox => const Color(0xffa25332),
      LessonBlockType.mechanismBox => const Color(0xff3e557e),
      LessonBlockType.keyTakeaway => const Color(0xff8b6134),
      _ => _accent,
    };
    final label = switch (block.type) {
      LessonBlockType.paragraph => null,
      LessonBlockType.definitionBox => 'تعریف',
      LessonBlockType.mechanismBox => 'سازوکار',
      LessonBlockType.tipBox => 'نکته',
      LessonBlockType.warningBox => 'هشدار',
      LessonBlockType.comparisonTable => 'مقایسه',
      LessonBlockType.formulaBox => 'فرمول',
      LessonBlockType.exampleBox => 'مثال',
      LessonBlockType.figure => 'شکل منبع',
      LessonBlockType.figureExplanation => 'توضیح شکل',
      LessonBlockType.keyTakeaway => 'جمع بندی',
      LessonBlockType.recallPrompt => 'یادآوری',
    };
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: TraceTypography.persian.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (block.type == LessonBlockType.figure)
          _figure(block.figureId!)
        else
          SelectableText(
            TraceTypography.displayDigits(block.text!),
            textDirection: TextDirection.rtl,
            style: TraceTypography.persian.copyWith(
              fontSize: 16,
              height: 1.8,
              color: _ink,
            ),
          ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [for (final id in block.sourceCitationIds) _citation(id)],
        ),
      ],
    );
    if (block.type == LessonBlockType.paragraph) return content;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(accent.withValues(alpha: .045), Colors.white),
        border: BorderDirectional(start: BorderSide(color: accent, width: 3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: content),
    );
  }

  Widget _citation(String id) {
    final locator = citationLocators[id];
    final resolved = locator != null && locator.trim().isNotEmpty;
    return OutlinedButton.icon(
      onPressed: resolved && onOpenCitation != null
          ? () => onOpenCitation!(id)
          : null,
      icon: const Icon(Icons.my_location_outlined, size: 15),
      label: Text(
        resolved
            ? TraceTypography.displayDigits(locator)
            : 'Source unavailable',
        textDirection: resolved ? TextDirection.ltr : TextDirection.rtl,
      ),
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        foregroundColor: _accent,
        side: const BorderSide(color: _edge),
      ),
    );
  }

  Widget _figure(String id) {
    final bytes = figureBytes[id];
    if (bytes == null || bytes.isEmpty) return _figureMissing();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        bytes,
        key: Key('lesson-figure-$id'),
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => _figureMissing(),
      ),
    );
  }

  Widget _figureMissing() => Container(
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 100),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: _edge),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      'Figure unavailable',
      style: TraceTypography.english.copyWith(color: _muted),
    ),
  );

  Widget _actions() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        onStudyAction == null ? 'Study actions unavailable' : 'وضعیت یادگیری',
        style: TraceTypography.persian.copyWith(color: _muted, fontSize: 12),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (action, label) in [
            (LessonStudyAction.studied, 'خواندم'),
            (LessonStudyAction.notLearned, 'یاد نگرفتم'),
            (LessonStudyAction.later, 'بعداً'),
            (LessonStudyAction.mastered, 'مسلطم'),
            (LessonStudyAction.skipped, 'رد کردن'),
          ])
            OutlinedButton(
              key: Key('lesson-${action.name}'),
              onPressed: onStudyAction == null
                  ? null
                  : () => onStudyAction!(action),
              child: Text(label, style: TraceTypography.persian),
            ),
        ],
      ),
    ],
  );
}
