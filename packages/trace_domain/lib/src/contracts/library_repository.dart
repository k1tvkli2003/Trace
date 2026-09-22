/// Small read contract for the library workbench. Persistence stays behind it.
final class LibraryEntrySummary {
  const LibraryEntrySummary({required this.id, required this.title});

  final String id;
  final String title;
}

abstract interface class LibraryRepository {
  Future<List<LibraryEntrySummary>> listEntries();
}
