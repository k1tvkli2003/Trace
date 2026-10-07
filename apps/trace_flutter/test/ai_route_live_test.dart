import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trace_flutter/services/ai_route.dart';
import 'package:trace_flutter/services/ai_route_live.dart';

void main() {
  // Lane-4 P1 / Lane-5 F48: default probe() must not let a dead 9Router leg
  // kill the local-runtime leg. Each leg closes only its own transport.
  test('live probe with 9Router down and local healthy returns localRuntime',
      () async {
    final fetchers = LiveAiRouteFetchers(
      nineRouterModelsUrl: 'http://127.0.0.1:9/v1/models',
      localHealthUrl: 'http://127.0.0.1:9/global/health',
      timeout: const Duration(milliseconds: 50),
    );
    final probe = fetchers.probe();
    // Exercise nineRouterModels leg alone: failure must leave a fresh
    // client available for the local leg inside detect().
    await expectLater(
      probe.nineRouterModels(),
      throwsA(isA<AiRouteFailure>()),
    );
    final status = await probe.detect();
    expect(status.kind, AiRouteKind.offline);
  });

  test('injected shared client is never closed by either leg', () async {
    var closed = false;
    final inner = MockClient((request) async {
      if (request.url.path == '/v1/models') {
        return http.Response(
            jsonEncode({'data': []}), 200,
            headers: {'content-type': 'application/json'});
      }
      return http.Response(
          jsonEncode({'healthy': true, 'version': 'test'}), 200,
          headers: {'content-type': 'application/json'});
    });
    final tracking = _TrackingClient(inner, onClose: () => closed = true);
    final status =
        await const LiveAiRouteFetchers().probe(client: tracking).detect();
    expect(status.kind, AiRouteKind.localRuntime);
    expect(closed, isFalse);
  });
}

final class _TrackingClient extends http.BaseClient {
  _TrackingClient(this._inner, {required this.onClose});
  final http.Client _inner;
  final void Function() onClose;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request);

  @override
  void close() {
    onClose();
    _inner.close();
    super.close();
  }
}
