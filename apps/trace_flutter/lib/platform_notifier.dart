/// Stage 29 thin platform adapter. Foreground-only, no native plugin.
///
/// The real OS surface (system notification center, background wake) is NOT
/// called here. [TracePlatformNotifier] only builds an honest in-app notice
/// decision: when [backgroundDelivery] is false the caller must route the
/// user to the Review Inbox instead of claiming a system delivery.
final class TracePlatformNotifier {
  const TracePlatformNotifier({required this.backgroundDelivery});

  /// False on every target in this slice: no proven background path exists.
  final bool backgroundDelivery;

  DueNoticeReceipt previewDueNotice({
    required String reviewId,
    required String title,
    required String locator,
  }) {
    if (reviewId.trim().isEmpty) {
      throw const FormatException('reviewId must be nonempty text');
    }
    return DueNoticeReceipt(
      reviewId: reviewId,
      title: title,
      locator: locator,
      deliveredInBackground: backgroundDelivery,
      fallbackToInbox: !backgroundDelivery,
    );
  }
}

/// Display-only notice decision. The [locator] is presentation text only and
/// never an identity input to any repository.
final class DueNoticeReceipt {
  const DueNoticeReceipt({
    required this.reviewId,
    required this.title,
    required this.locator,
    required this.deliveredInBackground,
    required this.fallbackToInbox,
  });

  final String reviewId;
  final String title;
  final String locator;
  final bool deliveredInBackground;
  final bool fallbackToInbox;
}
