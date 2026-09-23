import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'runId': 'run-1',
    'version': 1,
    'contentHash': 'c' * 64,
    'capability': 'page_vision_extract',
    'inputHashes': ['a' * 64, 'b' * 64],
    'modelProfile': 'opencode-go-personal',
    'promptVersion': 'page-v1',
    'inputTokens': 100,
    'outputTokens': 50,
    'costMicros': null,
    'latencyMs': 750,
    'retryCount': 0,
    'outcome': 'succeeded',
    'createdAt': '2026-09-23T11:20:00Z',
  };

  test('AiRunLedger round-trips metadata without raw source text', () {
    final run = AiRunLedger.fromJson(fixture);
    expect(run.outcome, AiRunOutcome.succeeded);
    expect(run.toJson(), fixture);
  });

  test('AiRunLedger preserves unsupported outcome without treating it as success', () {
    final run = AiRunLedger.fromJson({...fixture, 'outcome': 'future'});
    expect(run.outcome, AiRunOutcome.unsupported);
    expect(run.toJson()['outcome'], 'future');
  });

  test('AiRunLedger rejects duplicate input hashes', () {
    expect(
      () => AiRunLedger.fromJson({
        ...fixture,
        'inputHashes': ['a' * 64, 'a' * 64],
      }),
      throwsFormatException,
    );
  });

  test('AiRunLedger rejects negative token, latency, and cost metadata', () {
    for (final key in ['inputTokens', 'outputTokens', 'latencyMs', 'retryCount', 'costMicros']) {
      expect(
        () => AiRunLedger.fromJson({...fixture, key: -1}),
        throwsFormatException,
        reason: key,
      );
    }
  });
}
