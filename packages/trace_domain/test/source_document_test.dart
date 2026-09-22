import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('source document JSON round-trips its immutable manifest identity', () {
    final json = <String, Object>{
      'id': 'doc-1',
      'libraryId': 'library-1',
      'version': 1,
      'sourceHash': 'a' * 64,
      'relativePath': 'part/chapter.pdf',
      'mimeType': 'application/pdf',
      'byteSize': 48,
      'importVersion': 1,
      'format': 'pdf',
    };

    final document = SourceDocument.fromJson(json);

    expect(document.format, SourceDocumentFormat.pdf);
    expect(document.toJson(), json);
    expect(SourceDocument.fromJson(document.toJson()).toJson(), json);
  });

  test('rejects a source hash that cannot bind immutable bytes', () {
    expect(
      () => SourceDocument.fromJson({
        'id': 'doc-bad',
        'libraryId': 'library-1',
        'version': 1,
        'sourceHash': 'not-a-sha256',
        'relativePath': 'book.pdf',
        'mimeType': 'application/pdf',
        'byteSize': 32,
        'importVersion': 1,
        'format': 'pdf',
      }),
      throwsFormatException,
    );
  });

  test('rejects traversal paths before a source can enter the manifest', () {
    for (final unsafePath in [
      '../secret.pdf',
      'book/../secret.pdf',
      '/absolute.pdf',
      r'C:\private\book.pdf',
    ]) {
      expect(
        () => SourceDocument.fromJson({
          'id': 'doc-unsafe',
          'libraryId': 'library-1',
          'version': 1,
          'sourceHash': 'a' * 64,
          'relativePath': unsafePath,
          'mimeType': 'application/pdf',
          'byteSize': 32,
          'importVersion': 1,
          'format': 'pdf',
        }),
        throwsFormatException,
        reason: unsafePath,
      );
    }
  });

  test('rejects invalid identity and import metadata', () {
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
    };
    for (final invalid in <(String, Object?)>[
      ('id', ''),
      ('libraryId', ''),
      ('version', 0),
      ('importVersion', 0),
      ('byteSize', -1),
      ('mimeType', ''),
      ('format', ''),
    ]) {
      expect(
        () => SourceDocument.fromJson({...valid, invalid.$1: invalid.$2}),
        throwsFormatException,
        reason: invalid.$1,
      );
    }
  });

  test(
    'unknown future format remains unsupported without losing its token',
    () {
      final json = <String, Object>{
        'id': 'doc-2',
        'libraryId': 'library-1',
        'version': 2,
        'sourceHash': 'b' * 64,
        'relativePath': 'chapter.epub',
        'mimeType': 'application/epub+zip',
        'byteSize': 256,
        'importVersion': 1,
        'format': 'epub',
      };

      final document = SourceDocument.fromJson(json);
      expect(document.format, SourceDocumentFormat.unsupported);
      expect(document.toJson(), json);
    },
  );
}
