import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/main.dart';

void main() {
  testWidgets('creates a collection and shows it from SQLite', (tester) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(MainApp(database: database));
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      app.theme?.textTheme.bodyMedium?.fontFamily,
      'packages/trace_design/Inter',
    );
    await tester.pumpAndSettle();
    expect(find.text('Your library is empty'), findsOneWidget);
    await tester.tap(find.text('New collection'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('collection-title')),
      'Immunology',
    );
    await tester.tap(find.text('Create collection'));
    await tester.pumpAndSettle();
    expect(find.text('Immunology'), findsOneWidget);
    expect(
      (await LocalLibraryRepository(database).listEntries()).single.title,
      'Immunology',
    );
  });

  testWidgets('narrow screen can return from sources to collections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalLibraryRepository(database).putEntry(
      const LibraryEntrySummary(id: 'lib', title: 'Small screen book'),
    );
    await tester.pumpWidget(MainApp(database: database));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Small screen book'));
    await tester.pumpAndSettle();
    expect(find.text('Import text'), findsOneWidget);
    await tester.tap(find.text('Back to library'));
    await tester.pumpAndSettle();
    expect(find.text('Small screen book'), findsOneWidget);
  });

  testWidgets('selected collection imports a text original and lists it', (
    tester,
  ) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalLibraryRepository(
      database,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Book'));
    await tester.pumpWidget(
      MainApp(
        database: database,
        pickText: () async => PickedTextSource(
          name: 'chapter.md',
          bytes: Uint8List.fromList(utf8.encode('# سلام Trace ۱۲۳')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import text'));
    await tester.pumpAndSettle();
    expect(find.text('chapter.md · v1'), findsOneWidget);
    await tester.tap(find.text('chapter.md · v1'));
    await tester.pumpAndSettle();
    expect(find.text('RAW SOURCE'), findsOneWidget);
    expect(find.text('# سلام Trace 123'), findsOneWidget);
    expect(
      (await LocalTextSourceRepository(
        database,
      ).listForLibrary('lib')).single.relativePath,
      'chapter.md',
    );
  });
}
