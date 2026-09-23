import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('v4 source evidence survives migration to v5 figure storage', () async {
    final directory = await Directory.systemTemp.createTemp('trace-v4-');
    final file = File('${directory.path}/library.sqlite');
    final sourceBytes = utf8.encode('%PDF-1.4\n%%EOF');
    final sourceHash = sha256.convert(sourceBytes).toString();
    final cropBytes = Uint8List.fromList(utf8.encode('synthetic figure crop'));
    try {
      final old = sqlite3.open(file.path);
      old.execute('''CREATE TABLE library_entries (
        id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL)''');
      old.execute('''CREATE TABLE source_entries (
        id TEXT NOT NULL PRIMARY KEY, library_id TEXT NOT NULL REFERENCES library_entries(id),
        name TEXT NOT NULL, version INTEGER NOT NULL DEFAULT 1,
        source_hash TEXT NOT NULL, mime_type TEXT NOT NULL, format TEXT NOT NULL,
        original_bytes BLOB NOT NULL)''');
      old.execute('''CREATE UNIQUE INDEX source_version_unique
        ON source_entries(library_id, name, version)''');
      old.execute('''CREATE TABLE source_pages (
        id TEXT NOT NULL PRIMARY KEY, document_id TEXT NOT NULL REFERENCES source_entries(id),
        version INTEGER NOT NULL DEFAULT 1, page_number INTEGER NOT NULL,
        pixel_hash TEXT NOT NULL, render_profile TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL, vision_status TEXT NOT NULL)''');
      old.execute(
        '''CREATE UNIQUE INDEX source_page_document_page_version_profile_unique
        ON source_pages(document_id, page_number, version, render_profile)''',
      );
      old.execute('''CREATE TABLE source_blocks (
        id TEXT NOT NULL PRIMARY KEY, document_id TEXT NOT NULL REFERENCES source_entries(id),
        page_id TEXT NOT NULL REFERENCES source_pages(id), version INTEGER NOT NULL DEFAULT 1,
        source_hash TEXT NOT NULL, "order" INTEGER NOT NULL, kind TEXT NOT NULL,
        raw_text TEXT NOT NULL, normalized_text TEXT NOT NULL,
        bbox_x REAL, bbox_y REAL, bbox_width REAL, bbox_height REAL)''');
      old.execute('''CREATE UNIQUE INDEX source_block_page_version_order_unique
        ON source_blocks(page_id, version, "order")''');
      old.execute('''CREATE TABLE source_citations (
        id TEXT NOT NULL PRIMARY KEY, version INTEGER NOT NULL DEFAULT 1,
        content_hash TEXT NOT NULL, source_block_id TEXT NOT NULL REFERENCES source_blocks(id),
        page_id TEXT NOT NULL REFERENCES source_pages(id), figure_id TEXT,
        quote TEXT NOT NULL, locator TEXT NOT NULL, confidence REAL NOT NULL,
        extraction_version TEXT NOT NULL)''');
      old.execute("INSERT INTO library_entries VALUES ('lib', 'Preserved')");
      old.execute('INSERT INTO source_entries VALUES (?,?,?,?,?,?,?,?)', [
        'source-1',
        'lib',
        'book.pdf',
        1,
        sourceHash,
        'application/pdf',
        'pdf',
        sourceBytes,
      ]);
      old.execute('INSERT INTO source_pages VALUES (?,?,?,?,?,?,?,?)', [
        'page-1',
        'source-1',
        1,
        1,
        'a' * 64,
        'hires-v1',
        'thumbs/page-1.webp',
        'complete',
      ]);
      old.execute('PRAGMA user_version = 4');
      old.close();

      final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
      final repo = LocalFigureAssetRepository(upgraded);
      final figure = FigureAsset.fromJson({
        'id': 'figure-1',
        'version': 1,
        'assetHash': sha256.convert(cropBytes).toString(),
        'sourceHash': sourceHash,
        'pagePixelHash': 'a' * 64,
        'pageId': 'page-1',
        'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.4, 'h': 0.3},
        'widthPx': 200,
        'heightPx': 150,
        'caption': 'Figure',
        'altText': 'Diagram',
        'reviewStatus': 'pending',
      });
      await repo.putCrop(figure, cropBytes);
      await upgraded.close();

      final reopened = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        expect(
          (await LocalLibraryRepository(reopened).listEntries()).single.title,
          'Preserved',
        );
        expect(
          await LocalPdfSourceRepository(reopened).readOriginal('source-1'),
          sourceBytes,
        );
        expect(
          (await LocalSourcePageRepository(
            reopened,
          ).listForDocument('source-1')).single.id,
          'page-1',
        );
        expect(
          (await LocalFigureAssetRepository(reopened).readCrop('figure-1'))?.$2,
          cropBytes,
        );
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
