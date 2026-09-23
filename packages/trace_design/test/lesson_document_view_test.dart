import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_design/trace_design.dart';
import 'package:trace_domain/trace_domain.dart';

LessonDocument lesson() => LessonDocument.fromJson(
  {
    'schemaVersion': 'lesson-ast-v1',
    'sliceId': 'slice-1',
    'language': 'fa',
    'blocks': [
      {
        'id': 'p1',
        'type': 'definition_box',
        'text': 'تعریف منبع: مقدار ۱۲ در شکل آمده است.',
        'sourceCitationIds': ['cite-1'],
      },
      {
        'id': 'f1',
        'type': 'figure',
        'figureId': 'figure-1',
        'sourceCitationIds': ['cite-1'],
      },
      {
        'id': 'e1',
        'type': 'figure_explanation',
        'figureId': 'figure-1',
        'text': 'شکل این رابطه را نشان می‌دهد.',
        'sourceCitationIds': ['cite-1'],
      },
    ],
  },
  sliceId: 'slice-1',
  citationIds: {'cite-1'},
  figureIds: {'figure-1'},
);

void main() {
  testWidgets('renders inert Persian blocks and opens only supplied citation', (
    tester,
  ) async {
    String? opened;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LessonDocumentView(
            document: lesson(),
            citationLocators: const {'cite-1': 'Source page 12'},
            onOpenCitation: (id) => opened = id,
          ),
        ),
      ),
    );
    expect(find.text('تعریف منبع: مقدار 12 در شکل آمده است.'), findsOneWidget);
    expect(find.text('Source page 12'), findsWidgets);
    expect(find.text('Figure unavailable'), findsOneWidget);
    await tester.tap(find.text('Source page 12').first);
    expect(opened, 'cite-1');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'missing evidence cannot open and actions cannot mutate without owner',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonDocumentView(
              document: lesson(),
              citationLocators: const {},
            ),
          ),
        ),
      );
      expect(find.text('Source unavailable'), findsWidgets);
      expect(find.text('Study actions unavailable'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const Key('lesson-studied')))
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'source figure uses provided local bytes and actions report typed choice',
    (tester) async {
      LessonStudyAction? action;
      const png = <int>[
        137,
        80,
        78,
        71,
        13,
        10,
        26,
        10,
        0,
        0,
        0,
        13,
        73,
        72,
        68,
        82,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        1,
        8,
        6,
        0,
        0,
        0,
        31,
        21,
        196,
        137,
        0,
        0,
        0,
        11,
        73,
        68,
        65,
        84,
        120,
        156,
        99,
        248,
        207,
        192,
        240,
        31,
        0,
        5,
        0,
        1,
        255,
        137,
        153,
        61,
        29,
        0,
        0,
        0,
        0,
        73,
        69,
        78,
        68,
        174,
        66,
        96,
        130,
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonDocumentView(
              document: lesson(),
              citationLocators: const {'cite-1': 'Source page 12'},
              figureBytes: {'figure-1': Uint8List.fromList(png)},
              onStudyAction: (value) => action = value,
            ),
          ),
        ),
      );
      expect(find.byKey(const Key('lesson-figure-figure-1')), findsOneWidget);
      expect(find.text('Figure unavailable'), findsNothing);
      await tester.ensureVisible(find.byKey(const Key('lesson-studied')));
      await tester.tap(find.byKey(const Key('lesson-studied')));
      expect(action, LessonStudyAction.studied);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('narrow viewport and 200% text retain evidence and actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    tester.view.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.platformDispatcher.clearTextScaleFactorTestValue();
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: LessonDocumentView(
              document: lesson(),
              citationLocators: const {'cite-1': 'Source page 12'},
            ),
          ),
        ),
      ),
    );
    await tester.ensureVisible(find.byKey(const Key('lesson-studied')));
    expect(find.text('Source page 12'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
