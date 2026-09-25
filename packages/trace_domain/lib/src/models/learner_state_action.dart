import 'learner_state.dart';

/// Deterministic learner-state footer action contract.
///
/// Actions are local-first signals; the repository owns the projection.
/// Review scheduling is explicitly out of scope (Stage 24).
enum LearnerStateAction {
  inProgress('in_progress'),
  studied('studied'),
  notLearned('not_learned'),
  mastered('mastered'),
  skipped('skipped');

  const LearnerStateAction(this.wireName);
  final String wireName;
}

/// Caller-provided action request. [actionId] is the idempotency key.
final class LearnerStateActionRequest {
  const LearnerStateActionRequest({
    required this.actionId,
    required this.stateId,
    required this.sliceId,
    required this.lessonArtifactId,
    required this.action,
    required this.occurredAt,
    required this.deviceId,
  });

  final String actionId;
  final String stateId;
  final String sliceId;
  final String lessonArtifactId;
  final LearnerStateAction action;
  final String occurredAt;
  final String deviceId;
}

/// Result of applying one action. [replayed] is true when the same
/// action ID was already applied with identical intent.
final class LearnerStateActionReceipt {
  const LearnerStateActionReceipt({
    required this.state,
    required this.replayed,
  });

  final LearnerState state;
  final bool replayed;
}
