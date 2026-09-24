import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

const pageId = 'page-1';
final pdf = Uint8List.fromList(ascii.encode('%PDF-1.4\n%%EOF'));
final sourceHash = sha256.convert(pdf).toString();
final pixelHash = 'b' * 64;

PageVisionCacheKey key([Map<String, Object?> overrides = const {}]) =>
    PageVisionCacheKey.fromJson({
      'sourceHash': sourceHash,
      'pageNumber': 1,
      'renderProfile': 'full-v1',
      'visionModelProfile': 'own-model-v1',
      'promptVersion': 'page-vision-extract-v1',
      ...overrides,
    });

String extract({String? pageRef, String? source, String? pixel, String? profile}) =>
    jsonEncode({
      'schemaVersion': 'page-extract-v1',
      'sourceHash': source ?? sourceHash,
      'pixelHash': pixel ?? pixelHash,
      'renderProfile': profile ?? 'full-v1',
      'pageRef': pageRef ?? pageId,
      'extractionVersion': 'page-vision-extract-v1',
      'coverage': 'complete',
      'blocks': [
        {
          'id': 'block-1', 'order': 0, 'kind': 'paragraph', 'text': 'متن منبع',
          'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.5, 'h': 0.1},
          'confidence': 0.9, 'uncertain': false,
        },
      ],
      'figures': [],
    });

Future<TraceDatabase> seededDatabase() async {
  final db = TraceDatabase(NativeDatabase.memory());
  await LocalLibraryRepository(db).putEntry(
    const LibraryEntrySummary(id: 'lib', title: 'Book'),
  );
  final source = await LocalPdfSourceRepository(db).importPdf(
    libraryId: 'lib', name: 'book.pdf', bytes: pdf,
  );
  await LocalSourcePageRepository(db).putPage(SourcePage.fromJson({
    'id': pageId,
    'documentId': source.id,
    'version': source.version,
    'pageNumber': 1,
    'pixelHash': pixelHash,
    'renderProfile': 'full-v1',
    'thumbnailPath': 'thumbs/page-1.webp',
    'visionStatus': 'not_started',
  }));
  return db;
}

void main() {
  test('same bound key hits and survives repeated identical writes', () async {
    final db = await seededDatabase();
    addTearDown(db.close);
    final repository = LocalVisionCacheRepository(db);
    await repository.put(key: key(), pixelHash: pixelHash, payloadJson: extract());
    await repository.put(key: key(), pixelHash: pixelHash, payloadJson: extract());
    final hit = await repository.lookup(key: key(), pixelHash: pixelHash);
    expect(hit?.payloadJson, extract());
    expect(hit?.reason, 'hit');
  });

  test('source, page, profile, model, prompt or pixel change misses', () async {
    final db = await seededDatabase();
    addTearDown(db.close);
    final repository = LocalVisionCacheRepository(db);
    await repository.put(key: key(), pixelHash: pixelHash, payloadJson: extract());
    for (final variant in [
      key({'sourceHash': 'c' * 64}),
      key({'pageNumber': 2}),
      key({'renderProfile': 'thumb-v1'}),
      key({'visionModelProfile': 'other'}),
      key({'promptVersion': 'extract-v2'}),
    ]) {
      expect(await repository.lookup(key: variant, pixelHash: pixelHash), isNull);
    }
    expect(await repository.lookup(key: key(), pixelHash: 'd' * 64), isNull);
  });

  test('rejects forged payload, invalid raster and overwrite without mutation', () async {
    final db = await seededDatabase();
    addTearDown(db.close);
    final repository = LocalVisionCacheRepository(db);
    for (final invalid in [
      '{', '{}', '{"ok":true}', extract(pageRef: 'foreign'),
      extract(source: 'd' * 64), extract(pixel: 'c' * 64),
      extract(profile: 'thumb-v1'),
      jsonEncode({...jsonDecode(extract()), 'coverage': 'partial'}),
      jsonEncode({...jsonDecode(extract()), 'textLayer': 'not vision'}),
      jsonEncode({...jsonDecode(extract()), 'blocks': []}),
    ]) {
      await expectLater(
        repository.put(key: key(), pixelHash: pixelHash, payloadJson: invalid),
        throwsFormatException,
      );
    }
    expect(await repository.lookup(key: key(), pixelHash: pixelHash), isNull);
    await expectLater(
      repository.put(key: key(), pixelHash: 'c' * 64, payloadJson: extract(pixel: 'c' * 64)),
      throwsStateError,
    );
    await repository.put(key: key(), pixelHash: pixelHash, payloadJson: extract());
    await expectLater(
      repository.put(key: key(), pixelHash: pixelHash,
          payloadJson: jsonEncode({...jsonDecode(extract()), 'blocks': [
            {...(jsonDecode(extract())['blocks'][0] as Map), 'text': 'different'},
          ]})),
      throwsStateError,
    );
    expect((await repository.lookup(key: key(), pixelHash: pixelHash))?.payloadJson, extract());
  });

  test('corrupted stored row fails closed on lookup', () async {
    final db = await seededDatabase();
    addTearDown(db.close);
    final repository = LocalVisionCacheRepository(db);
    await repository.put(key: key(), pixelHash: pixelHash, payloadJson: extract());
    await db.customStatement(
      'UPDATE vision_cache_entries SET payload_json = ? WHERE cache_key = ?',
      ['{', key().value],
    );
    await expectLater(repository.lookup(key: key(), pixelHash: pixelHash), throwsFormatException);
  });

  test('v10 file upgrades to v11 without losing original source page', () async {
    final directory = await Directory.systemTemp.createTemp('trace-vision-v10-');
    final file = File('${directory.path}/library.sqlite');
    try {
      final old = sqlite3.open(file.path);
      old.execute('CREATE TABLE library_entries (id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL)');
      old.execute("INSERT INTO library_entries VALUES ('lib','Book')");
      old.execute('''CREATE TABLE source_entries (
        id TEXT NOT NULL PRIMARY KEY, library_id TEXT NOT NULL,
        name TEXT NOT NULL, version INTEGER NOT NULL DEFAULT 1,
        source_hash TEXT NOT NULL, mime_type TEXT NOT NULL, format TEXT NOT NULL,
        original_bytes BLOB NOT NULL, modified_at TEXT,
        logical_role TEXT NOT NULL DEFAULT 'primary', exclusion_reason TEXT
      )''');
      old.execute('CREATE UNIQUE INDEX source_version_unique ON source_entries (library_id, name, version)');
      old.execute('INSERT INTO source_entries VALUES (?,?,?,?,?,?,?,?,?,?,?)', [
        'source-1', 'lib', 'book.pdf', 1, sourceHash, 'application/pdf', 'pdf',
        pdf, null, 'primary', null,
      ]);
      old.execute('''CREATE TABLE source_pages (
        id TEXT NOT NULL PRIMARY KEY, document_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1, page_number INTEGER NOT NULL,
        pixel_hash TEXT NOT NULL, render_profile TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL, vision_status TEXT NOT NULL
      )''');
      old.execute('INSERT INTO source_pages VALUES (?,?,?,?,?,?,?,?)', [
        pageId, 'source-1', 1, 1, pixelHash, 'full-v1',
        'thumbs/page-1.webp', 'not_started',
      ]);
      old.execute('PRAGMA user_version = 10');
      old.close();
      final upgraded = TraceDatabase(NativeDatabase.createInBackground(file));
      try {
        expect(await LocalSourcePageRepository(upgraded).listForDocument('source-1'), hasLength(1));
        await LocalVisionCacheRepository(upgraded)
            .put(key: key(), pixelHash: pixelHash, payloadJson: extract());
        expect(await upgraded.customSelect('PRAGMA user_version').getSingle()
            .then((r) => r.read<int>('user_version')), 11);
        expect(await upgraded.customSelect("SELECT name FROM sqlite_master WHERE type='index' AND name='vision_cache_key_unique'").get(), hasLength(1));
      } finally {
        await upgraded.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
