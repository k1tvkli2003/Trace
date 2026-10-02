import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/services/trace_gateway_client.dart';

void main() {
  TraceGatewayRequest valid() => TraceGatewayRequest(
        operation: 'op-1',
        capability: 'page_vision_extract',
        pageRef: 'page-1',
        sourceHash: 'a' * 64,
        pixelHash: 'b' * 64,
        renderProfile: 'test-v1',
        pagePngBase64: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
            'hKmMIQAAAABJRU5ErkJggg==',
        reasoningEffort: 'high',
        maxOutputTokens: 64,
        maxElapsedSeconds: 5,
        idempotencyKey: 'key-1',
      );

  test('valid request serializes eleven fields, no secret', () {
    final wire = valid().toWireJson();
    expect(wire.keys.length, 11);
    expect(wire['operation'], 'op-1');
    const bannedKeys = {'secret', 'service_role', 'api_key', 'token', 'jwt'};
    expect(bannedKeys.intersection(wire.keys.toSet()), isEmpty);
  });

  test('invalid request fails closed before send', () {
    expect(
      () => valid().copyWith(reasoningEffort: 'low').toWireJson(),
      throwsA(isA<TraceGatewayFailure>().having(
          (e) => e.code, 'code', 'AI_VISION_REQUEST_INVALID')),
    );
    expect(
      () => valid().copyWith(maxOutputTokens: 0).toWireJson(),
      throwsA(isA<TraceGatewayFailure>()),
    );
  });

  test('receipt parses safe fields; error maps to code only', () {
    final receipt = TraceGatewayReceipt.fromJson({
      'requestId': 'a' * 32,
      'status': 'completed',
      'operation': 'op-1',
      'capability': 'page_vision_extract',
      'model': 'user-route',
      'reasoningEffort': 'high',
      'usage': {'input_tokens': 10},
      'elapsedSeconds': 1.0,
      'providerRequestId': 'req_123',
    });
    expect(receipt.requestId, 'a' * 32);
    expect(receipt.status, 'completed');
    expect(
      () => TraceGatewayReceipt.fromJson({'requestId': 'x'}),
      throwsA(isA<TraceGatewayFailure>()),
    );
  });

  test('client posts JWT, never secret; maps transport failure closed', () async {
    String? seenAuth;
    final client = TraceGatewayClient(
      endpoint: Uri.parse('https://example.invalid/api/trace-ai-run'),
      post: (uri, headers, body) async {
        seenAuth = headers['Authorization'];
        return FakeHttpResponse(401, '{"error":{"code":"AI_UNAUTHORIZED"}}');
      },
    );
    await expectLater(
      client.run(valid(), jwt: 'jwt-1'),
      throwsA(isA<TraceGatewayFailure>().having(
          (e) => e.code, 'code', 'AI_UNAUTHORIZED')),
    );
    expect(seenAuth, 'Bearer jwt-1');
  });
}

class FakeHttpResponse implements TraceHttpResponse {
  FakeHttpResponse(this.statusCode, this.body);
  @override
  final int statusCode;
  @override
  final String body;
}
