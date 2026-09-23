library;

import 'package:flutter/material.dart';

export 'src/lesson_document_view.dart';

/// Display policy only. Source bytes and citation quotes remain unchanged.
abstract final class TraceTypography {
  static const english = TextStyle(fontFamily: 'packages/trace_design/Inter');
  static const persian = TextStyle(
    fontFamily: 'packages/trace_design/Vazirmatn',
  );

  static String displayDigits(String text) => String.fromCharCodes(
    text.runes.map((rune) {
      if (rune >= 0x06F0 && rune <= 0x06F9) return rune - 0x06F0 + 0x30;
      if (rune >= 0x0660 && rune <= 0x0669) return rune - 0x0660 + 0x30;
      return rune;
    }),
  );
}

/// Script-aware display entry point for Persian teaching content.
class TraceText extends StatelessWidget {
  const TraceText.persian(this.value, {super.key}) : isPersian = true;
  const TraceText.english(this.value, {super.key}) : isPersian = false;

  final String value;
  final bool isPersian;

  @override
  Widget build(BuildContext context) => Text(
    TraceTypography.displayDigits(value),
    textDirection: isPersian ? TextDirection.rtl : TextDirection.ltr,
    style: isPersian ? TraceTypography.persian : TraceTypography.english,
  );
}
