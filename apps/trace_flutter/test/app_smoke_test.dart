import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/main.dart';

void main() {
  testWidgets('development scaffold launches', (tester) async {
    await tester.pumpWidget(const MainApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      app.theme?.textTheme.bodyMedium?.fontFamily,
      'packages/trace_design/Inter',
    );
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
