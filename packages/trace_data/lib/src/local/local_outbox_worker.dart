import 'package:trace_domain/trace_domain.dart' as domain;

import 'local_oplog_repository.dart';

/// Local outbox worker over the existing lifecycle.
///
/// [runNext] claims one queue head per call; [drain] repeats [runNext] up to
/// a bounded number of passes. Success acknowledges, failure records one
/// attempt and requeues within budget. Exhausted rows stay `failed` as a
/// local dead-letter. Empty queue settles nothing.
///
/// Local-only: the handler stands in for future server transport. A handler
/// throw propagates without catch; the claim stays `in_flight` for explicit
/// [releaseClaim] by the caller, and rows settled before the throw stay
/// settled in the database even though the throw discards the in-memory
/// prefix. Neither method loops unboundedly, sleeps, waits, or touches the
/// network.
final class LocalOutboxWorker {
  const LocalOutboxWorker(this.oplog);

  final LocalOplogRepository oplog;

  Future<domain.SyncOperation?> runNext({
    required Future<bool> Function(domain.SyncOperation claimed) handler,
    int maxRetries = 5,
  }) async {
    final claimed = await oplog.claimNext();
    if (claimed == null) {
      return null;
    }
    final ok = await handler(claimed);
    if (ok) {
      return oplog.acknowledge(claimed.operationId);
    }
    final failed = await oplog.recordFailure(claimed.operationId);
    if (LocalOplogRepository.canRequeue(failed, maxRetries: maxRetries)) {
      return oplog.requeueFailed(claimed.operationId, maxRetries: maxRetries);
    }
    return failed;
  }

  /// Settles up to [maxPasses] queue heads by repeating [runNext] in order.
  ///
  /// Stops early when the queue empties and returns the settled rows in
  /// settle order. Queue order itself is owned by [LocalOplogRepository]:
  /// both `claimNext` and `listReadyToClaim` sort `createdAt` ascending
  /// then the row id ascending, where the row id is the `operationId`
  /// (`SyncOperationsCompanion.insert(id: operation.operationId, ...)` and
  /// `putBatch` looks rows up by `row.id.equals(operation.operationId)`).
  /// A handler throw propagates like [runNext]: the claim stays `in_flight`
  /// and rows settled before the throw stay settled in the database, while
  /// the in-memory prefix built so far is discarded with the throw (it is
  /// not swallowed into a partial list).
  Future<List<domain.SyncOperation>> drain({
    required Future<bool> Function(domain.SyncOperation claimed) handler,
    int maxRetries = 5,
    int maxPasses = 10,
  }) async {
    if (maxPasses < 1) {
      throw ArgumentError.value(maxPasses, 'maxPasses', 'must be at least 1');
    }
    final settled = <domain.SyncOperation>[];
    for (var pass = 0; pass < maxPasses; pass++) {
      final next = await runNext(handler: handler, maxRetries: maxRetries);
      if (next == null) {
        break;
      }
      settled.add(next);
    }
    return settled;
  }
}
