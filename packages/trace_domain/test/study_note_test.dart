import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'note-1',
    'version': 1,
    'contentHash': 'd' * 64,
    'anchorId': 'highlight-1',
    'sourceBlockId': 'block-1',
    'figureId': null,
    'lessonBlockId': 'lesson-block-1',
    'body': 'این نکته را دوباره مرور کن.',
    'pinned': true,
    'createdAt': '2026-09-23T10:30:00Z',
    'updatedAt': '2026-09-23T10:35:00Z',
  };

  test('StudyNote round-trips linked annotation and UTC timestamps', () {
    final note = StudyNote.fromJson(fixture);
    expect(note.pinned, isTrue);
    expect(note.updatedAt.isUtc, isTrue);
    expect(note.toJson(), fixture);
  });

  test('StudyNote requires at least one source or lesson target', () {
    final json = {
      ...fixture,
      'anchorId': null,
      'sourceBlockId': null,
      'figureId': null,
      'lessonBlockId': null,
    };
    expect(() => StudyNote.fromJson(json), throwsFormatException);
  });

  test('StudyNote rejects invalid hash, body and timestamp ordering', () {
    expect(
      () => StudyNote.fromJson({...fixture, 'contentHash': 'bad'}),
      throwsFormatException,
    );
    expect(
      () => StudyNote.fromJson({...fixture, 'body': ''}),
      throwsFormatException,
    );
    expect(
      () =>
          StudyNote.fromJson({...fixture, 'updatedAt': '2026-09-23T10:29:00Z'}),
      throwsFormatException,
    );
  });
}
