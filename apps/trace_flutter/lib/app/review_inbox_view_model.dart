import 'package:flutter/foundation.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_domain/trace_domain.dart';

enum ReviewInboxStatus { idle, loading, ready, failed, opening, opened }

/// Minimal UI presenter for offline due reviews. Repository owns evidence.
final class ReviewInboxViewModel extends ChangeNotifier {
  ReviewInboxViewModel(this._inbox, {DateTime Function()? nowUtc})
    : _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  final LocalReviewInboxRepository _inbox;
  final DateTime Function() _nowUtc;
  ReviewInboxStatus status = ReviewInboxStatus.idle;
  List<ReviewItem> items = const [];
  CachedReviewLesson? opened;
  String? errorMessage;

  static String _clock(DateTime value) => value.toUtc().toIso8601String();

  Future<void> load() async {
    status = ReviewInboxStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      items = List.unmodifiable(await _inbox.listDue(_clock(_nowUtc())));
      opened = null;
      status = ReviewInboxStatus.ready;
    } catch (_) {
      items = const [];
      errorMessage = 'Due reviews could not load. Retry offline.';
      status = ReviewInboxStatus.failed;
    }
    notifyListeners();
  }

  Future<void> open(String itemId) async {
    status = ReviewInboxStatus.opening;
    errorMessage = null;
    notifyListeners();
    try {
      opened = await _inbox.openDue(itemId, _clock(_nowUtc()));
      status = ReviewInboxStatus.opened;
    } catch (_) {
      opened = null;
      errorMessage = 'Cached lesson cannot be verified. Stay offline.';
      status = ReviewInboxStatus.failed;
    }
    notifyListeners();
  }
}
