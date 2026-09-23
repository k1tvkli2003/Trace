import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final lessonJson = <String, Object?>{
    'schemaVersion': 'lesson-ast-v1',
    'sliceId': 'slice-1',
    'language': 'fa',
    'blocks': [
      {
        'id': 'intro',
        'type': 'paragraph',
        'text': 'متن منبع محور.',
        'sourceCitationIds': ['citation-1'],
      },
    ],
  };

  final fixture = <String, Object?>{
    'id': 'artifact-1',
    'version': 2,
    'contentHash': 'a' * 64,
    'sliceId': 'slice-1',
    'lessonAstJson': lessonJson,
    'citationIds': ['citation-1'],
    'figureIds': <String>[],
    'modelProfile': 'personal-approved-route',
    'promptVersion': 'teacher-fa-v1',
    'createdAt': '2026-09-23T10:30:00Z',
  };

  test('LessonArtifact round-trips immutable AST provenance', () {
    final artifact = LessonArtifact.fromJson(fixture);
    expect(artifact.lessonAstJson['sliceId'], 'slice-1');
    expect(artifact.createdAt.isUtc, isTrue);
    expect(artifact.toJson(), fixture);
  });

  test('LessonArtifact rejects unapproved figure references', () {
    final withFigure = <String, Object?>{
      'schemaVersion': 'lesson-ast-v1',
      'sliceId': 'slice-1',
      'language': 'fa',
      'blocks': [
        {
          'id': 'figure',
          'type': 'figure',
          'figureId': 'untrusted-figure',
          'sourceCitationIds': ['citation-1'],
        },
        {
          'id': 'explanation',
          'type': 'figure_explanation',
          'figureId': 'untrusted-figure',
          'text': 'شرح شکل.',
          'sourceCitationIds': ['citation-1'],
        },
      ],
    };
    expect(
      () => LessonArtifact.fromJson({...fixture, 'lessonAstJson': withFigure}),
      throwsFormatException,
    );
    final allowed = {
      ...fixture,
      'lessonAstJson': withFigure,
      'figureIds': ['untrusted-figure'],
    };
    expect(LessonArtifact.fromJson(allowed).toJson(), allowed);
  });

  test('LessonArtifact rejects duplicate citations and non-UTC time', () {
    expect(
      () => LessonArtifact.fromJson({
        ...fixture,
        'citationIds': ['citation-1', 'citation-1'],
      }),
      throwsFormatException,
    );
    expect(
      () => LessonArtifact.fromJson({
        ...fixture,
        'createdAt': '2026-09-23T10:30:00+03:30',
      }),
      throwsFormatException,
    );
  });
}
