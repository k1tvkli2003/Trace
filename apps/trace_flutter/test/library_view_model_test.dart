import 'package:flutter_test/flutter_test.dart';
import 'package:trace_domain/trace_domain.dart';
import 'package:trace_flutter/app/library_view_model.dart';

class FakeLibraryRepository implements LibraryRepository {
  FakeLibraryRepository(this.entries);
  final List<LibraryEntrySummary> entries;
  int calls = 0;

  @override
  Future<List<LibraryEntrySummary>> listEntries() async {
    calls++;
    return entries;
  }
}

void main() {
  test(
    'library view model reads repository and exposes ready entries',
    () async {
      final repository = FakeLibraryRepository([
        const LibraryEntrySummary(id: 'book-1', title: 'Foundations'),
      ]);
      final viewModel = LibraryViewModel(repository);
      addTearDown(viewModel.dispose);

      await viewModel.load();

      expect(viewModel.status, LibraryLoadStatus.ready);
      expect(viewModel.entries.single.title, 'Foundations');
      expect(repository.calls, 1);
    },
  );

  test(
    'failed read exposes a safe retryable state without raw error',
    () async {
      final viewModel = LibraryViewModel(FailingLibraryRepository());
      addTearDown(viewModel.dispose);

      await viewModel.load();

      expect(viewModel.status, LibraryLoadStatus.failed);
      expect(viewModel.errorMessage, 'Library could not load. Retry.');
      expect(viewModel.entries, isEmpty);
    },
  );
}

class FailingLibraryRepository implements LibraryRepository {
  @override
  Future<List<LibraryEntrySummary>> listEntries() =>
      Future.error(StateError('private source path must not leak'));
}
