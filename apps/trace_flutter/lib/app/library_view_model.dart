import 'package:flutter/foundation.dart';
import 'package:trace_domain/trace_domain.dart';

enum LibraryLoadStatus { idle, loading, ready, failed }

/// UI state owner; storage/network details remain behind [LibraryRepository].
final class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel(this._repository);

  final LibraryRepository _repository;
  LibraryLoadStatus status = LibraryLoadStatus.idle;
  List<LibraryEntrySummary> entries = const [];
  String? errorMessage;

  Future<void> load() async {
    status = LibraryLoadStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      entries = List.unmodifiable(await _repository.listEntries());
      status = LibraryLoadStatus.ready;
    } catch (_) {
      // Never expose storage paths or provider errors in presentation state.
      errorMessage = 'Library could not load. Retry.';
      status = LibraryLoadStatus.failed;
    }
    notifyListeners();
  }
}
