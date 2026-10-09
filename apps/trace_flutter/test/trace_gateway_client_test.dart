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

  test('receipt with validated extract exposes payload; mismatch rejects',
      () {
    Map<String, Object?> extract() => {
      'schemaVersion': 'page-extract-v1',
      'sourceHash': 'a' * 64,
      'pixelHash': 'b' * 64,
      'renderProfile': 'test-v1',
      'pageRef': 'page-1',
      'extractionVersion': 'page-vision-extract-v1',
      'coverage': 'complete',
      'blocks': [
        {
          'id': 'b1',
          'order': 0,
          'kind': 'paragraph',
          'text': 'T.',
          'bbox': {'x': 0.1, 'y': 0.2, 'w': 0.5, 'h': 0.1},
          'confidence': 0.9,
          'uncertain': false,
        },
      ],
      'figures': <Object?>[],
    };
    Map<String, Object?> receiptJson([Map<String, Object?>? override]) => {
      'requestId': 'a' * 32,
      'status': 'completed',
      'operation': 'op-1',
      'capability': 'page_vision_extract',
      'model': 'user-route',
      'reasoningEffort': 'high',
      'elapsedSeconds': 1.0,
      'extract': override ?? extract(),
    };
    // Direct parse enforces shape; identity binding happens in boundTo.
    final receipt = TraceGatewayReceipt.fromJson(
      receiptJson(),
    ).boundTo(valid());
    expect(receipt.extract['pageRef'], 'page-1');
    expect(
      () => TraceGatewayReceipt.fromJson(
        receiptJson({...extract(), 'pixelHash': 'c' * 64}),
      ).boundTo(valid()),
      throwsA(isA<TraceGatewayFailure>().having(
          (e) => e.code, 'code', 'AI_SCHEMA_REJECTED')),
    );
    expect(
      () => TraceGatewayReceipt.fromJson(receiptJson()),
      returnsNormally,
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
