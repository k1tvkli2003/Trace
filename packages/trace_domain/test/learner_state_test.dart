import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'state-slice-1',
    'version': 1,
    'contentHash': 'b' * 64,
    'sliceId': 'slice-1',
    'lessonArtifactId': 'artifact-1',
    'status': 'in_progress',
    'confidence': 0.55,
    'lastReadAt': '2026-09-23T10:30:00Z',
    'lastActionAt': '2026-09-23T10:35:00Z',
  };

  test('LearnerState round-trips status and UTC learner timestamps', () {
    final state = LearnerState.fromJson(fixture);
    expect(state.status, LearnerStateStatus.inProgress);
    expect(state.lastActionAt!.isUtc, isTrue);
    expect(state.toJson(), fixture);
  });

  test('unknown learner status remains unsupported and round-trips', () {
    final json = {...fixture, 'status': 'future_status'};
    final state = LearnerState.fromJson(json);
    expect(state.status, LearnerStateStatus.unsupported);
    expect(state.toJson(), json);
  });

  test('LearnerState accepts not-started state without timestamps', () {
    final json = {
      ...fixture,
      'status': 'not_started',
      'confidence': 0,
      'lastReadAt': null,
      'lastActionAt': null,
    };
    expect(LearnerState.fromJson(json).toJson(), json);
  });

  test('LearnerState rejects invalid confidence and timestamps', () {
    for (final value in [-0.1, 1.1, double.nan, double.infinity]) {
      expect(
        () => LearnerState.fromJson({...fixture, 'confidence': value}),
        throwsFormatException,
        reason: '$value',
      );
    }
    expect(
      () => LearnerState.fromJson({...fixture, 'lastReadAt': 'local-time'}),
      throwsFormatException,
    );
  });
}
