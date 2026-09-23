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

  final citation = SourceCitation.fromJson({
    'id': 'citation-1',
    'version': 1,
    'contentHash': 'b' * 64,
    'sourceBlockId': 'block-1',
    'pageId': 'page-1',
    'figureId': null,
    'quote': 'متن منبع محور.',
    'locator': 'p.1',
    'confidence': 1.0,
    'extractionVersion': 'vision-v1',
  });
  final approvedFigure = FigureAsset.fromJson({
    'id': 'untrusted-figure',
    'version': 1,
    'assetHash': 'a' * 64,
    'sourceHash': 'b' * 64,
    'pagePixelHash': 'c' * 64,
    'pageId': 'page-1',
    'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.4, 'h': 0.3},
    'widthPx': 1200,
    'heightPx': 900,
    'caption': 'شرح شکل',
    'altText': 'نمودار',
    'reviewStatus': 'approved',
  });

  test('LessonArtifact round-trips immutable AST provenance', () {
    expect(() => LessonArtifact.fromJson(fixture), throwsFormatException);
    final artifact = LessonArtifact.fromJson(
      fixture,
      verifiedCitations: [citation],
    );
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
    expect(() => LessonArtifact.fromJson(allowed), throwsFormatException);
    expect(
      LessonArtifact.fromJson(
        allowed,
        verifiedCitations: [citation],
        verifiedFigures: [approvedFigure],
      ).toJson(),
      allowed,
    );
  });

  test('LessonArtifact rejects figures not independently approved', () {
    final figureJson = {
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
    final payload = {
      ...fixture,
      'lessonAstJson': figureJson,
      'figureIds': ['untrusted-figure'],
    };
    final pending = FigureAsset.fromJson({
      ...approvedFigure.toJson(),
      'reviewStatus': 'pending',
    });
    expect(
      () => LessonArtifact.fromJson(
        payload,
        verifiedCitations: [citation],
        verifiedFigures: [pending],
      ),
      throwsFormatException,
    );
    expect(
      () => LessonArtifact.fromJson(payload, verifiedCitations: [citation]),
      throwsFormatException,
    );
    expect(
      () => LessonArtifact.fromJson(fixture, verifiedCitations: []),
      throwsFormatException,
    );
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
