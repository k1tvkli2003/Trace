import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/main.dart';

void main() {
  testWidgets(
    'Signal Console frames real collections without invented progress',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Atlas'));
      await tester.pumpWidget(MainApp(database: db));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('signal-console-navigation')),
        findsOneWidget,
      );
      expect(
        Theme.of(
          tester.element(find.byKey(const Key('chat-composer'))),
        ).brightness,
        Brightness.dark,
      );
      expect(find.text('YOUR WORKTREE'), findsOneWidget);
      expect(find.text('Atlas'), findsOneWidget);
      expect(find.text('0 due'), findsNothing);
      expect(find.textContaining('Complete'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Signal Console dark stage and composer have readable material surfaces',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await tester.pumpWidget(MainApp(database: db));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Material>(find.byKey(const Key('signal-console-stage')))
            .color,
        TraceColors.canvas,
      );
      expect(
        tester
            .widget<Material>(find.byKey(const Key('signal-console-composer')))
            .color,
        TraceColors.panel,
      );
      expect(find.text('AI offline'), findsOneWidget);
      expect(find.textContaining('OpenCode Go'), findsNothing);
      expect(find.text('PRIVATE WORKSPACE'), findsOneWidget);
      expect(find.text('What are we learning today?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [375.0, 1280.0]) {
    testWidgets(
      'chat workspace keeps draft without claiming AI reply at $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        final db = TraceDatabase(NativeDatabase.memory());
        addTearDown(db.close);
        await tester.pumpWidget(MainApp(database: db));
        await tester.pumpAndSettle();
        expect(find.text('What are we learning today?'), findsOneWidget);
        expect(find.byKey(const Key('chat-composer')), findsOneWidget);
        await tester.enterText(
          find.byKey(const Key('chat-composer')),
          'سلام، از این فصل شروع کنیم',
        );
        await tester.pump();
        expect(find.byKey(const Key('chat-send')), findsOneWidget);
        expect(
          tester
              .widget<IconButton>(find.byKey(const Key('chat-send')))
              .onPressed,
          isNull,
        );
        expect(find.textContaining('Works offline'), findsWidgets);
        expect(find.text('سلام، از این فصل شروع کنیم'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'onboarding has no dead CTA and offline state is visible before drafting',
    (tester) async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await tester.pumpWidget(MainApp(database: db));
      await tester.pumpAndSettle();
      expect(find.text('How learning works'), findsNothing);
      expect(find.text('Import → Read → Ask → Review'), findsOneWidget);
      expect(find.text('AI offline'), findsOneWidget);
      expect(find.text('Create a collection'), findsOneWidget);
    },
  );

  testWidgets(
    'selected collection opens an imported source from the welcome flow',
    (tester) async {
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(
        db,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Atlas'));
      await tester.pumpWidget(
        MainApp(
          database: db,
          pickText: () async => PickedTextSource(
            name: 'chapter.md',
            bytes: Uint8List.fromList(
              utf8.encode('# Chapter One\nSource evidence.'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Atlas'));
      await tester.pumpAndSettle();
      expect(find.text('Open sources'), findsOneWidget);
      await tester.tap(find.byTooltip('Open sources'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Import text'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Close sources'));
      await tester.pumpAndSettle();
      expect(find.text('chapter.md'), findsWidgets);
      expect(find.text('Collection: Atlas · 1 source'), findsOneWidget);
      expect(find.text('Read chapter'), findsOneWidget);
      final readChapter = find.text('Read chapter');
      await tester.ensureVisible(readChapter);
      await tester.tap(readChapter);
      await tester.pumpAndSettle();
      expect(find.textContaining('Source evidence.'), findsOneWidget);
    },
  );

  testWidgets('wide workspace can reveal and hide honest source rail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Atlas'));
    await tester.pumpWidget(MainApp(database: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Atlas'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('evidence-rail')), findsNothing);
    await tester.tap(find.byTooltip('Show source rail'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('evidence-rail')), findsOneWidget);
    expect(find.text('No sources imported yet'), findsOneWidget);
    await tester.tap(find.byTooltip('Hide source rail'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('evidence-rail')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet keeps source route instead of squeezing rail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(834, 1112);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await LocalLibraryRepository(
      db,
    ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'Atlas'));
    await tester.pumpWidget(MainApp(database: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Atlas'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Show source rail'), findsNothing);
    expect(find.byKey(const Key('evidence-rail')), findsNothing);
    expect(find.byTooltip('Open sources'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('New chat asks before discarding a typed draft', (tester) async {
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(MainApp(database: db));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('chat-composer')),
      'Unsaved idea',
    );
    await tester.tap(find.text('New chat'));
    await tester.pumpAndSettle();
    expect(find.text('Discard this draft?'), findsOneWidget);
    await tester.tap(find.text('Keep writing'));
    await tester.pumpAndSettle();
    expect(find.text('Unsaved idea'), findsOneWidget);
  });

  testWidgets('320px and 200% text keep composer reachable', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    final db = TraceDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(MainApp(database: db));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-composer')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'mobile drawer selects source context; source inspector opens separately',
    (tester) async {
      tester.view.physicalSize = const Size(375, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final db = TraceDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await LocalLibraryRepository(db).putEntry(
        const LibraryEntrySummary(id: 'lib', title: 'My learning book'),
      );
      await tester.pumpWidget(MainApp(database: db));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Open navigation'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My learning book'));
      await tester.pumpAndSettle();
      expect(find.textContaining('My learning book'), findsWidgets);
      expect(
        find.text('Collection: My learning book · No sources yet'),
        findsOneWidget,
      );
      expect(find.text('Pick up where you left off.'), findsNothing);
      expect(find.text('Your learning workspace.'), findsOneWidget);
      await tester.tap(find.byTooltip('Open sources'));
      await tester.pumpAndSettle();
      expect(find.text('Import text'), findsOneWidget);
      expect(find.text('Import PDF'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
