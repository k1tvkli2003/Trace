import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_design/trace_design.dart';

void main() {
  test('Persian and Arabic-Indic numerals display as ASCII digits', () {
    expect(
      TraceTypography.displayDigits('صفحه ۱۲، ٣۴ و 0-9'),
      'صفحه 12، 34 و 0-9',
    );
  });

  test('English and Persian text use distinct bundled families', () {
    expect(TraceTypography.english.fontFamily, 'packages/trace_design/Inter');
    expect(
      TraceTypography.persian.fontFamily,
      'packages/trace_design/Vazirmatn',
    );
  });

  testWidgets('Persian content keeps RTL and English digits', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TraceText.persian('درس ۱۲ از ٣٠')),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text).last);
    expect(text.data, 'درس 12 از 30');
    expect(text.textDirection, TextDirection.rtl);
    expect(text.style?.fontFamily, 'packages/trace_design/Vazirmatn');
  });
}
