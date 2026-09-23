import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('parses a source-bound Persian lesson and round-trips JSON', () {
    final lesson = LessonDocument.fromJson({
      'schemaVersion': 'lesson-ast-v1',
      'sliceId': 'slice-1',
      'language': 'fa',
      'blocks': [
        {
          'id': 'intro',
          'type': 'paragraph',
          'text': 'این مفهوم از دو مرحله ساخته می‌شود.',
          'sourceCitationIds': ['cite-12'],
        },
        {
          'id': 'definition',
          'type': 'definition_box',
          'text': 'تعریف دقیق مفهوم.',
          'sourceCitationIds': ['cite-12'],
        },
        {
          'id': 'figure',
          'type': 'figure',
          'figureId': 'figure-7',
          'sourceCitationIds': ['cite-13'],
        },
        {
          'id': 'figure-note',
          'type': 'figure_explanation',
          'figureId': 'figure-7',
          'text': 'رابطهٔ دو بخش در شکل دیده می‌شود.',
          'sourceCitationIds': ['cite-13'],
        },
      ],
    });

    expect(lesson.schemaVersion, 'lesson-ast-v1');
    expect(lesson.language, LessonLanguage.fa);
    expect(lesson.blocks[1].type, LessonBlockType.definitionBox);
    expect(lesson.blocks[2].figureId, 'figure-7');
    expect(lesson.toJson(), {
      'schemaVersion': 'lesson-ast-v1',
      'sliceId': 'slice-1',
      'language': 'fa',
      'blocks': [
        {
          'id': 'intro',
          'type': 'paragraph',
          'text': 'این مفهوم از دو مرحله ساخته می‌شود.',
          'sourceCitationIds': ['cite-12'],
        },
        {
          'id': 'definition',
          'type': 'definition_box',
          'text': 'تعریف دقیق مفهوم.',
          'sourceCitationIds': ['cite-12'],
        },
        {
          'id': 'figure',
          'type': 'figure',
          'sourceCitationIds': ['cite-13'],
          'figureId': 'figure-7',
        },
        {
          'id': 'figure-note',
          'type': 'figure_explanation',
          'text': 'رابطهٔ دو بخش در شکل دیده می‌شود.',
          'sourceCitationIds': ['cite-13'],
          'figureId': 'figure-7',
        },
      ],
    });
  });

  test('requires figure explanation and authorized source references', () {
    final input = <String, Object?>{
      'schemaVersion': 'lesson-ast-v1',
      'sliceId': 'slice-2',
      'language': 'fa',
      'blocks': [
        {
          'id': 'figure',
          'type': 'figure',
          'figureId': 'fig-1',
          'sourceCitationIds': ['citation-1'],
        },
      ],
    };
    expect(
      () => LessonDocument.fromJson(
        input,
        sliceId: 'slice-2',
        citationIds: {'citation-1'},
        figureIds: {'fig-1'},
      ),
      throwsFormatException,
    );
    final explained = {
      ...input,
      'blocks': [
        ...input['blocks'] as List,
        {
          'id': 'explanation',
          'type': 'figure_explanation',
          'figureId': 'fig-1',
          'text': 'توضیح شکل با ارجاع.',
          'sourceCitationIds': ['citation-1'],
        },
      ],
    };
    expect(
      () => LessonDocument.fromJson(
        explained,
        sliceId: 'wrong-slice',
        citationIds: {'citation-1'},
        figureIds: {'fig-1'},
      ),
      throwsFormatException,
    );
    expect(
      () => LessonDocument.fromJson(
        explained,
        sliceId: 'slice-2',
        citationIds: {'other-citation'},
        figureIds: {'fig-1'},
      ),
      throwsFormatException,
    );
    expect(
      LessonDocument.fromJson(
        explained,
        sliceId: 'slice-2',
        citationIds: {'citation-1'},
        figureIds: {'fig-1'},
      ).blocks.length,
      2,
    );
  });

  test('rejects malformed or unsafe AST blocks', () {
    final base = <String, Object?>{
      'schemaVersion': 'lesson-ast-v1',
      'sliceId': 'slice-1',
      'language': 'fa',
      'blocks': [
        {
          'id': 'p',
          'type': 'paragraph',
          'text': 'متن',
          'sourceCitationIds': ['cite-1'],
        },
      ],
    };

    expect(
      () => LessonDocument.fromJson({
        ...base,
        'blocks': [
          {
            'id': 'bad',
            'type': 'unknown_box',
            'text': 'متن',
            'sourceCitationIds': ['cite-1'],
          },
        ],
      }),
      throwsFormatException,
    );
    expect(
      () => LessonDocument.fromJson({
        ...base,
        'blocks': [
          {
            'id': 'no-citation',
            'type': 'paragraph',
            'text': 'متن',
            'sourceCitationIds': <String>[],
          },
        ],
      }),
      throwsFormatException,
    );
    expect(
      () => LessonDocument.fromJson({
        ...base,
        'blocks': [
          {
            'id': 'figure-with-text',
            'type': 'figure',
            'text': 'نباید متن آزاد داشته باشد',
            'figureId': 'figure-1',
            'sourceCitationIds': ['cite-1'],
          },
        ],
      }),
      throwsFormatException,
    );
    expect(
      () => LessonDocument.fromJson({
        ...base,
        'blocks': [
          {
            'id': 'injection',
            'type': 'paragraph',
            'text': '<script>alert(1)</script>',
            'sourceCitationIds': ['cite-1'],
            'html': '<b>unsafe</b>',
          },
        ],
      }),
      throwsFormatException,
    );
  });
}
