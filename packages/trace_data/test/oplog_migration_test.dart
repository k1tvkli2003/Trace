import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test(
    'v8 SQLite preserves source and review while adding oplog and AI ledger',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'trace-v8-oplog-',
      );
      final file = File('${directory.path}/library.sqlite');
      final original = Uint8List.fromList(utf8.encode('%PDF-1.4\n%%EOF'));
      try {
        final created = TraceDatabase(NativeDatabase(file));
        await LocalLibraryRepository(created).putEntry(
          const LibraryEntrySummary(id: 'library-1', title: 'Preserved'),
        );
        final source = await LocalPdfSourceRepository(
          created,
        ).importPdf(libraryId: 'library-1', name: 'book.pdf', bytes: original);
        final review = ReviewItem.fromJson({
          'id': 'review-1',
          'version': 1,
          'contentHash': 'e' * 64,
          'targetType': 'lesson_box',
          'targetId': 'lesson-block-1',
          'dueAt': '2026-09-24T10:30:00Z',
          'intervalDays': 1,
          'ease': 2.5,
          'lapses': 0,
          'state': 'active',
          'schedulerVersion': 'fixed-ladder-v1',
        });
        await LocalReviewRepository(created).putReviewItem(review);
        await created.close();

        // Fixture represents exact v8 delta; do not remove older tables or data.
        final old = sqlite3.open(file.path);
        old.execute('DROP TABLE sync_operations');
        old.execute('DROP TABLE ai_run_ledgers');
        old.execute('PRAGMA user_version = 8');
        old.close();

        final upgraded = TraceDatabase(NativeDatabase(file));
        expect(
          await LocalPdfSourceRepository(upgraded).readOriginal(source.id),
          original,
        );
        expect(
          (await LocalReviewRepository(
            upgraded,
          ).readReviewItem(review.id))?.toJson(),
          review.toJson(),
        );
        final index = await upgraded
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'index' AND name = 'sync_operations_state_created'",
            )
            .get();
        expect(index, hasLength(1));
        final repo = LocalOplogRepository(upgraded);
        final operation = SyncOperation.fromJson({
          'operationId': 'sync-1',
          'version': 1,
          'contentHash': 'a' * 64,
          'entityType': 'study_note',
          'entityId': 'note-1',
          'mutationType': 'insert',
          'payload': <String, Object?>{'text': 'saved'},
          'localVersion': 1,
          'syncState': 'pending',
          'retryCount': 0,
          'createdAt': '2026-09-24T10:00:00Z',
        });
        final run = AiRunLedger.fromJson({
          'runId': 'run-1',
          'version': 1,
          'contentHash': 'b' * 64,
          'capability': 'teacher_fa',
          'inputHashes': ['a' * 64],
          'modelProfile': 'opencode-go/user-selected',
          'promptVersion': 'v1',
          'inputTokens': 10,
          'outputTokens': 20,
          'costMicros': null,
          'latencyMs': 30,
          'retryCount': 0,
          'outcome': 'succeeded',
          'createdAt': '2026-09-24T10:01:00Z',
        });
        await repo.putBatch(operations: [operation], runs: [run]);
        await upgraded.close();

        final reopened = TraceDatabase(NativeDatabase(file));
        try {
          expect(
            (await LocalOplogRepository(
              reopened,
            ).readOperation(operation.operationId))?.toJson(),
            operation.toJson(),
          );
          expect(
            (await LocalOplogRepository(reopened).readRun(run.runId))?.toJson(),
            run.toJson(),
          );
          expect(
            await LocalPdfSourceRepository(reopened).readOriginal(source.id),
            original,
          );
          expect(
            (await LocalReviewRepository(
              reopened,
            ).readReviewItem(review.id))?.toJson(),
            review.toJson(),
          );
        } finally {
          await reopened.close();
        }
      } finally {
        await _deleteTemp(directory);
      }
    },
  );
}

Future<void> _deleteTemp(Directory directory) async {
  // Windows releases the SQLite file lock slightly after close() returns;
  // retry briefly, then leave cleanup best-effort so a green migration
  // proof never fails on temp-folder lock timing.
  for (var attempt = 0; attempt < 100; attempt++) {
    try {
      await directory.delete(recursive: true);
      return;
    } on PathAccessException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  try {
    await directory.delete(recursive: true);
  } on PathAccessException {
    // Best-effort only: assertions already passed above.
    print('WARNING: temp cleanup skipped, still locked: ${directory.path}');
  }
}
