import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/main.dart';

void main() {
  for (final width in [375.0, 1280.0]) {
    testWidgets('source-backed chapter navigation at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final database = TraceDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await LocalLibraryRepository(
        database,
      ).putEntry(const LibraryEntrySummary(id: 'lib', title: 'My book'));
      await LocalTextSourceRepository(database).importText(
        libraryId: 'lib',
        name: 'chapter.md',
        bytes: utf8.encode('# آغاز\nتوضیح نخست.\n\n## مفهوم بعد\nتوضیح دوم.'),
      );
      await tester.pumpWidget(MainApp(database: database));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My book'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start reading'));
      await tester.pumpAndSettle();
      expect(find.text('SOURCE READING'), findsOneWidget);
      expect(find.text('توضیح نخست.'), findsOneWidget);
      expect(find.text('توضیح دوم.'), findsNothing);
      if (width < 700) {
        expect(find.byTooltip('Show chapters'), findsOneWidget);
        await tester.tap(find.byTooltip('Show chapters'));
        await tester.pumpAndSettle();
        expect(find.text('مفهوم بعد'), findsWidgets);
        await tester.tap(find.text('مفهوم بعد').last);
      } else {
        await tester.tap(find.text('مفهوم بعد').last);
      }
      await tester.pumpAndSettle();
      expect(find.text('توضیح دوم.'), findsOneWidget);
      expect(find.textContaining('Source lines'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
