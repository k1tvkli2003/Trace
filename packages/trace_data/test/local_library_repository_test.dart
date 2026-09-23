import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  late TraceDatabase db;
  late LocalLibraryRepository repository;

  setUp(() {
    db = TraceDatabase(NativeDatabase.memory());
    repository = LocalLibraryRepository(db);
  });
  tearDown(() async => db.close());

  test('saved library survives a second repository read', () async {
    await repository.putEntry(
      const LibraryEntrySummary(id: 'book-1', title: 'Biology'),
    );
    final reopened = LocalLibraryRepository(db);
    final entries = await reopened.listEntries();
    expect(entries, hasLength(1));
    expect(entries.single.id, 'book-1');
    expect(entries.single.title, 'Biology');
  });

  test('replayed ID updates one row rather than making a duplicate', () async {
    await repository.putEntry(
      const LibraryEntrySummary(id: 'book-1', title: 'Draft'),
    );
    await repository.putEntry(
      const LibraryEntrySummary(id: 'book-1', title: 'Final'),
    );
    final entries = await repository.listEntries();
    expect(entries, hasLength(1));
    expect(entries.single.title, 'Final');
  });

  test('invalid row rolls back complete batch', () async {
    await expectLater(
      repository.putEntries([
        const LibraryEntrySummary(id: 'book-1', title: 'Valid'),
        const LibraryEntrySummary(id: 'book-2', title: ''),
      ]),
      throwsFormatException,
    );
    expect(await repository.listEntries(), isEmpty);
  });
}
