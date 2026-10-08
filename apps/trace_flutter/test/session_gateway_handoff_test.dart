import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_data/trace_data.dart';
import 'package:trace_flutter/services/session_gateway.dart';
import 'package:trace_flutter/services/trace_gateway_client.dart';

class _FakeHttpResponse implements TraceHttpResponse {
  const _FakeHttpResponse(this.statusCode, this.body);
  @override
  final int statusCode;
  @override
  final String body;
}

TraceGatewayRequest _validRequest() => TraceGatewayRequest(
  operation: 'op-1',
  capability: 'page_vision_extract',
  pageRef: 'page-1',
  sourceHash: 'a' * 64,
  pixelHash: 'b' * 64,
  renderProfile: 'test-v1',
  pagePngBase64:
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
      'hKmMIQAAAABJRU5ErkJggg==',
  reasoningEffort: 'high',
  maxOutputTokens: 64,
  maxElapsedSeconds: 5,
  idempotencyKey: 'key-1',
);

String _completedBody() =>
    '{"receipt":{"requestId":"${'a' * 32}","status":"completed",'
    '"operation":"op-1","capability":"page_vision_extract",'
    '"model":"user-route","reasoningEffort":"high","elapsedSeconds":1.0}}';

int _futureEpoch() =>
    DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 + 3600;

void main() {
  test('signed-in session posts Bearer JWT and returns receipt', () async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final sessions = LocalAuthSessionRepository(database);
    await sessions.save(
      TraceAuthSession(
        email: 'live@example.com',
        accessToken: 'jwt-live',
        refreshToken: 'refresh-1',
        expiresAtEpochSeconds: _futureEpoch(),
        userId: 'user-1',
      ),
    );
    String? seenAuth;
    final client = TraceGatewayClient(
      endpoint: Uri.parse('https://example.invalid/api/trace-ai-run'),
      post: (uri, headers, body) async {
        seenAuth = headers['Authorization'];
        return _FakeHttpResponse(200, _completedBody());
      },
    );
    final receipt = await SessionGatewayRunner(
      sessions: sessions,
      client: client,
    ).run(_validRequest());
    expect(seenAuth, 'Bearer jwt-live');
    expect(receipt.status, 'completed');
  });

  test('missing session fails AI_UNAUTHORIZED without HTTP', () async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    var calls = 0;
    final client = TraceGatewayClient(
      endpoint: Uri.parse('https://example.invalid/api/trace-ai-run'),
      post: (uri, headers, body) async {
        calls++;
        return _FakeHttpResponse(200, _completedBody());
      },
    );
    await expectLater(
      SessionGatewayRunner(
        sessions: LocalAuthSessionRepository(database),
        client: client,
      ).run(_validRequest()),
      throwsA(
        isA<TraceGatewayFailure>().having(
          (e) => e.code,
          'code',
          'AI_UNAUTHORIZED',
        ),
      ),
    );
    expect(calls, 0);
  });

  test('expired session fails AI_UNAUTHORIZED without HTTP', () async {
    final database = TraceDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final sessions = LocalAuthSessionRepository(database);
    await sessions.save(
      TraceAuthSession(
        email: 'old@example.com',
        accessToken: 'jwt-stale',
        refreshToken: 'refresh-1',
        expiresAtEpochSeconds: 1,
        userId: 'user-1',
      ),
    );
    var calls = 0;
    final client = TraceGatewayClient(
      endpoint: Uri.parse('https://example.invalid/api/trace-ai-run'),
      post: (uri, headers, body) async {
        calls++;
        return _FakeHttpResponse(200, _completedBody());
      },
    );
    await expectLater(
      SessionGatewayRunner(sessions: sessions, client: client).run(
        _validRequest(),
      ),
      throwsA(
        isA<TraceGatewayFailure>().having(
          (e) => e.code,
          'code',
          'AI_UNAUTHORIZED',
        ),
      ),
    );
    expect(calls, 0);
  });

  test('production builder without TRACE_GATEWAY_URL fails closed', () {
    expect(
      () => productionGatewayClient(
        post: (uri, headers, body) async =>
            const _FakeHttpResponse(200, '{}'),
      ),
      throwsA(
        isA<TraceGatewayFailure>().having(
          (e) => e.code,
          'code',
          'AI_GATEWAY_NOT_CONFIGURED',
        ),
      ),
    );
  });
}
