import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('source document round-trips immutable provenance metadata', () {
    final json = <String, Object?>{
      'id': 'doc-1',
      'libraryId': 'library-1',
      'version': 1,
      'sourceHash': 'a' * 64,
      'relativePath': 'part/chapter.pdf',
      'mimeType': 'application/pdf',
      'byteSize': 48,
      'importVersion': 1,
      'format': 'pdf',
      'modifiedAt': '2026-09-24T12:34:56.000Z',
      'logicalRole': 'reference',
      'exclusionReason': 'not_lesson_source',
    };

    final document = SourceDocument.fromJson(json);

    expect(
      document.modifiedAt,
      DateTime.parse('2026-09-24T12:34:56.000Z'),
    );
    expect(document.logicalRole, 'reference');
    expect(document.exclusionReason, 'not_lesson_source');
    expect(document.toJson(), json);
    expect(SourceDocument.fromJson(document.toJson()).toJson(), json);
  });

  test('provenance keys are optional and default to unknown/primary', () {
    final document = SourceDocument.fromJson({
      'id': 'doc-1',
      'libraryId': 'library-1',
      'version': 1,
      'sourceHash': 'a' * 64,
      'relativePath': 'chapter.pdf',
      'mimeType': 'application/pdf',
      'byteSize': 48,
      'importVersion': 1,
      'format': 'pdf',
    });

    expect(document.modifiedAt, isNull);
    expect(document.rawModifiedAt, isNull);
    expect(document.logicalRole, 'primary');
    expect(document.exclusionReason, isNull);
  });

  test('rejects non-UTC modification time and blank provenance text', () {
    final valid = <String, Object?>{
      'id': 'doc-1',
      'libraryId': 'library-1',
      'version': 1,
      'sourceHash': 'a' * 64,
      'relativePath': 'chapter.pdf',
      'mimeType': 'application/pdf',
      'byteSize': 48,
      'importVersion': 1,
      'format': 'pdf',
      'modifiedAt': '2026-09-24T12:34:56.000Z',
      'logicalRole': 'reference',
      'exclusionReason': 'not_lesson_source',
    };

    for (final invalid in <(String, Object?)>[
      ('modifiedAt', '2026-09-24T12:34:56.000+03:30'),
      ('modifiedAt', 'not-a-timestamp'),
      ('modifiedAt', ''),
      ('logicalRole', ''),
      ('logicalRole', '   '),
      ('exclusionReason', ''),
      ('exclusionReason', '   '),
    ]) {
      expect(
        () => SourceDocument.fromJson({...valid, invalid.$1: invalid.$2}),
        throwsFormatException,
        reason: invalid.$1,
      );
    }
  });

  test('origin map keeps latest revision per path in sorted order', () {
    Map<String, Object?> doc({
      required String id,
      required String path,
      required int version,
    }) => {
      'id': id,
      'libraryId': 'library-1',
      'version': version,
      'sourceHash': 'a' * 64,
      'relativePath': path,
      'mimeType': 'text/plain',
      'byteSize': 1,
      'importVersion': 1,
      'format': 'text',
    };

    final documents = [
      SourceDocument.fromJson(doc(id: 'b1', path: 'b.txt', version: 1)),
      SourceDocument.fromJson(doc(id: 'a1', path: 'a.txt', version: 1)),
      SourceDocument.fromJson(doc(id: 'b2', path: 'b.txt', version: 2)),
    ];

    final origin = originMapFor(documents);

    expect(origin.keys.toList(), ['a.txt', 'b.txt']);
    expect(origin['a.txt']!.id, 'a1');
    expect(origin['b.txt']!.id, 'b2');
    expect(() => origin['c.txt'] = documents.first, throwsUnsupportedError);
  });
}
