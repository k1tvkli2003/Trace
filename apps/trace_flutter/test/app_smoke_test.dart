import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/main.dart';

void main() {
  testWidgets('review inbox opens from selected workspace without AI', (
    tester,
  ) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalLibraryRepository(
      database,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Review book'));
    await tester.pumpWidget(MainApp(database: database));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review book'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Open review inbox'));
    await tester.tap(find.text('Open review inbox'));
    await tester.pumpAndSettle();
    expect(find.text('Review inbox · cached only'), findsOneWidget);
    expect(find.byKey(const Key('review-inbox-empty')), findsOneWidget);
    expect(find.text('AI artifact not generated'), findsNothing);
  });

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
    expect(find.text('What are we learning today?'), findsOneWidget);
    await tester.tap(find.text('New collection'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('collection-title')),
      'Immunology',
    );
    await tester.tap(find.text('Create collection'));
    await tester.pumpAndSettle();
    expect(find.text('Immunology'), findsWidgets);
    expect(
      (await LocalLibraryRepository(database).listEntries()).single.title,
      'Immunology',
    );
  });

  testWidgets('selected workspace opens typed offline teaching preview', (
    tester,
  ) async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalLibraryRepository(
      database,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Teaching book'));
    await tester.pumpWidget(MainApp(database: database));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teaching book'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Preview teaching stage'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview teaching stage'));
    await tester.pumpAndSettle();
    expect(find.text('Offline teaching preview'), findsOneWidget);
    expect(find.text('درس مستند'), findsOneWidget);
    expect(find.text('Source unavailable'), findsWidgets);
    expect(find.text('Figure unavailable'), findsOneWidget);
    expect(find.text('AI artifact not generated'), findsOneWidget);
    expect(tester.takeException(), isNull);
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
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Small screen book'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open sources'));
    await tester.pumpAndSettle();
    expect(find.text('Import text'), findsOneWidget);
    await tester.tap(find.byTooltip('Close sources'));
    await tester.pumpAndSettle();
    expect(find.text('Small screen book'), findsOneWidget);
  });

  testWidgets(
    'second PDF tap cannot open a second picker while first is pending',
    (tester) async {
      final database = TraceDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await LocalLibraryRepository(
        database,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'PDF library'));
      final pending = Completer<PickedPdfSource?>();
      var pickerCalls = 0;
      await tester.pumpWidget(
        MainApp(
          database: database,
          pickPdf: () {
            pickerCalls++;
            return pending.future;
          },
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('PDF library'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Open sources'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Import PDF'));
      await tester.pump();
      expect(find.text('Importing PDF…'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(
              find.ancestor(
                of: find.text('Importing PDF…'),
                matching: find.byType(OutlinedButton),
              ),
            )
            .onPressed,
        isNull,
      );
      expect(pickerCalls, 1);
      pending.complete(null);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'selected collection imports PDF original without claiming text extraction',
    (tester) async {
      final database = TraceDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await LocalLibraryRepository(
        database,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'PDF library'));
      final original = File('test/fixtures/dummy.pdf').readAsBytesSync();
      await tester.pumpWidget(
        MainApp(
          database: database,
          pickPdf: () async =>
              PickedPdfSource(name: 'sample.pdf', bytes: original),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('PDF library'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Open sources'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Import PDF'));
      await tester.pumpAndSettle();
      expect(find.text('sample.pdf · v1'), findsOneWidget);
      await tester.tap(find.text('sample.pdf · v1'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Awaiting page-image Vision'), findsOneWidget);
      expect(find.text('RAW SOURCE'), findsNothing);
      final saved = (await LocalPdfSourceRepository(
        database,
      ).listForLibrary('lib')).single;
      expect(
        await LocalPdfSourceRepository(database).readOriginal(saved.id),
        original,
      );
    },
  );

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
    await tester.tap(find.byTooltip('Open sources'));
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
