import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  final fixture = <String, Object?>{
    'id': 'tool-call-1',
    'version': 1,
    'contentHash': 'a' * 64,
    'toolName': 'mark_lesson_state',
    'argsJson': {'sliceId': 'slice-1', 'status': 'studied'},
    'validationResult': {'ok': true, 'errors': <Object?>[]},
    'idempotencyKey': 'op-123',
    'mutationId': 'mutation-123',
    'resultJson': {'status': 'accepted'},
    'createdAt': '2026-09-23T11:00:00Z',
  };

  test('ToolInvocation round-trips validated typed tool evidence', () {
    final invocation = ToolInvocation.fromJson(fixture);
    expect(invocation.toolName, 'mark_lesson_state');
    expect(invocation.toJson(), fixture);
  });

  test('ToolInvocation snapshots nested args and exposes immutable evidence', () {
    final args = <String, Object?>{'scope': <String, Object?>{'ids': <String>['slice-1']}};
    final input = {...fixture, 'argsJson': args};
    final invocation = ToolInvocation.fromJson(input);
    (args['scope'] as Map<String, Object?>)['ids'] = ['forged'];
    expect(
      ((invocation.argsJson['scope'] as Map<String, Object?>)['ids'] as List).single,
      'slice-1',
    );
    expect(
      () => ((invocation.argsJson['scope'] as Map<String, Object?>)['ids'] as List).add('forged'),
      throwsUnsupportedError,
    );
  });

  test('ToolInvocation keeps a read-only invocation without mutation ID', () {
    final json = {...fixture, 'mutationId': null, 'resultJson': null};
    expect(ToolInvocation.fromJson(json).toJson(), json);
  });

  test('ToolInvocation rejects empty tool or idempotency identity', () {
    for (final key in ['toolName', 'idempotencyKey']) {
      expect(
        () => ToolInvocation.fromJson({...fixture, key: ''}),
        throwsFormatException,
        reason: key,
      );
    }
  });
}
