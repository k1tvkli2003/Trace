import 'review_item.dart';

/// Requested platform capability behind one shared contract.
///
/// Real OS delivery (system schedules, background wake, secure enclave) is
/// NOT proven in this slice; the contract only gates decisions so callers
/// fail closed on unsupported targets instead of pretending success.
enum PlatformCapability {
  localNotifications,
  backgroundExecution,
  secureStorage,
  filePicker,
  windowIntegration,
}

/// Honest capability snapshot for the current target.
///
/// `true` means the caller may attempt the capability through the shared
/// adapter; `false` means the adapter must refuse with a [StateError] and
/// fall back to an in-app/foreground surface. No background delivery after
/// app or browser close is claimed here.
final class PlatformCapabilities {
  const PlatformCapabilities({
    required this.localNotifications,
    required this.backgroundExecution,
    required this.secureStorage,
    required this.filePicker,
    required this.windowIntegration,
  });

  final bool localNotifications;
  final bool backgroundExecution;
  final bool secureStorage;
  final bool filePicker;
  final bool windowIntegration;

  bool supports(PlatformCapability capability) {
    switch (capability) {
      case PlatformCapability.localNotifications:
        return localNotifications;
      case PlatformCapability.backgroundExecution:
        return backgroundExecution;
      case PlatformCapability.secureStorage:
        return secureStorage;
      case PlatformCapability.filePicker:
        return filePicker;
      case PlatformCapability.windowIntegration:
        return windowIntegration;
    }
  }

  /// Throws [StateError] when [capability] is not supported on this target.
  static void require(
    PlatformCapabilities capabilities,
    PlatformCapability capability,
  ) {
    if (!capabilities.supports(capability)) {
      throw StateError(
        'Platform capability ${capability.name} is not supported; '
        'use the foreground fallback',
      );
    }
  }
}

/// Pure due-notice admission over the proven local due query.
///
/// Candidates MUST already come from `listDueItems` (active, due <= now).
/// This policy only re-checks that boundary defensively and dedupes by id so
/// repeated ticks never spam one notice per duplicate row. Inbox stays the
/// source of truth; this never invents due items.
final class DueNoticePolicy {
  const DueNoticePolicy._();

  static List<ReviewItem> admit(
    List<ReviewItem> candidates, {
    required DateTime nowUtc,
  }) {
    if (!nowUtc.isUtc) {
      throw const FormatException('nowUtc must be a UTC instant');
    }
    final seen = <String>{};
    final admitted = <ReviewItem>[];
    for (final item in candidates) {
      if (item.state != ReviewItemState.active) continue;
      if (item.dueAt.isAfter(nowUtc)) continue;
      if (!seen.add(item.id)) continue;
      admitted.add(item);
    }
    admitted.sort((a, b) {
      final order = a.dueAt.compareTo(b.dueAt);
      return order != 0 ? order : a.id.compareTo(b.id);
    });
    return List.unmodifiable(admitted);
  }
}
