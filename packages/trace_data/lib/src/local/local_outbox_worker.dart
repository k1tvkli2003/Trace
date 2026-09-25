import 'package:trace_domain/trace_domain.dart' as domain;

import 'local_oplog_repository.dart';

/// Single-pass local outbox worker over the existing lifecycle.
///
/// Claims the queue head, runs one injected handler, then settles locally:
/// success acknowledges, failure records one attempt and requeues within
/// budget. Exhausted rows stay `failed` as a local dead-letter. Returns
/// `null` without calling the handler when no pending row exists.
///
/// Local-only: the handler stands in for future server transport. A handler
/// throw leaves the claim in `in_flight` for explicit [releaseClaim] by the
/// caller; this pass never catches, loops, sleeps, or waits.
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
}
