import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/services/ai_route.dart';

void main() {
  AiRouteProbe probe({
    required List<String> nineRouterModels,
    required bool localHealthy,
    required String localVersion,
  }) =>
      AiRouteProbe(
        nineRouterModels: () async => nineRouterModels,
        localHealth: () async => (localHealthy, localVersion),
      );

  test('9Router AMuse present selects nine-router route', () async {
    final status = await probe(
      nineRouterModels: ['Code', 'AMuse', 'EasyGO'],
      localHealthy: false,
      localVersion: '',
    ).detect();
    expect(status.kind, AiRouteKind.nineRouter);
    expect(status.model, 'AMuse');
    expect(status.detail, contains('AMuse'));
  });

  test('no 9Router but healthy local runtime selects local route', () async {
    final status = await probe(
      nineRouterModels: const [],
      localHealthy: true,
      localVersion: '1.18.34',
    ).detect();
    expect(status.kind, AiRouteKind.localRuntime);
    expect(status.model, 'muse-spark-1.3-contributor-free');
    expect(status.detail, contains('1.18.34'));
  });

  test('neither route available reports offline closed', () async {
    final status = await probe(
      nineRouterModels: const [],
      localHealthy: false,
      localVersion: '',
    ).detect();
    expect(status.kind, AiRouteKind.offline);
    expect(status.model, isEmpty);
  });

  test('9Router error falls back to healthy local runtime', () async {
    final status = await AiRouteProbe(
      nineRouterModels: () async => throw const AiRouteFailure('AI_PROVIDER_FAILURE'),
      localHealth: () async => (true, '1.18.34'),
    ).detect();
    expect(status.kind, AiRouteKind.localRuntime);
  });

  test('both routes failing reports offline, never throws', () async {
    final status = await AiRouteProbe(
      nineRouterModels: () async => throw const AiRouteFailure('AI_PROVIDER_FAILURE'),
      localHealth: () async => throw const AiRouteFailure('AI_PROVIDER_FAILURE'),
    ).detect();
    expect(status.kind, AiRouteKind.offline);
  });

  test('label is user-facing and secret-free', () async {
    final status = await probe(
      nineRouterModels: ['AMuse'],
      localHealthy: true,
      localVersion: '1.18.34',
    ).detect();
    expect(status.kind, AiRouteKind.nineRouter);
    expect(status.label, isNotEmpty);
    expect(status.label.toLowerCase(), isNot(contains('key')));
    expect(status.label.toLowerCase(), isNot(contains('token')));
  });
}
