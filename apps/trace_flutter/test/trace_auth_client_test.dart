import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/services/trace_auth_client.dart';
import 'package:trace_flutter/services/trace_auth_messages.dart';

class _FakeResponse implements TraceAuthHttpResponse {
  const _FakeResponse(this.statusCode, this.body);
  @override
  final int statusCode;
  @override
  final String body;
}

String _okBody() =>
    '{"access_token":"access-1","refresh_token":"refresh-1","expires_in":3600,'
    '"user":{"id":"user-1"}}';

TraceAuthClient _client({
  required Future<TraceAuthHttpResponse> Function(
    Uri uri,
    Map<String, String> headers,
    String body,
  )
  post,
}) => TraceAuthClient(
  supabaseUrl: Uri.parse('https://example.invalid'),
  anonKey: 'anon-1',
  post: post,
);

void main() {
  test('validation rejects bad email and short password locally', () {
    expect(
      () => TraceAuthClient.validateCredentials('not-an-email', 'longenough'),
      throwsA(
        isA<TraceAuthFailure>().having((e) => e.code, 'code', 'AUTH_INVALID_EMAIL'),
      ),
    );
    expect(
      () =>
          TraceAuthClient.validateCredentials('a@b.co', 'short'),
      throwsA(
        isA<TraceAuthFailure>().having(
          (e) => e.code,
          'code',
          'AUTH_WEAK_PASSWORD',
        ),
      ),
    );
  });

  test('sign-in success returns tokens without retry prompt', () async {
    final client = _client(
      post: (uri, headers, body) async {
        expect(uri.path, contains('token'));
        expect(headers['apikey'], 'anon-1');
        return const _FakeResponse(200, '').copyWith(body: _okBody());
      },
    );
    final tokens = await client.signInOrSignUp('User@Example.COM', 'secret12');
    expect(tokens.email, 'user@example.com');
    expect(tokens.accessToken, 'access-1');
    expect(tokens.userId, 'user-1');
    expect(tokens.expiresAtEpochSeconds, greaterThan(0));
  });

  test('invalid credentials fall through to signup once', () async {
    var calls = 0;
    final client = _client(
      post: (uri, headers, body) async {
        calls++;
        if (calls == 1) {
          expect(uri.path, contains('token'));
          return const _FakeResponse(
            400,
            '{"msg":"Invalid login credentials"}',
          );
        }
        expect(uri.path, contains('signup'));
        return _FakeResponse(200, _okBody());
      },
    );
    final tokens = await client.signInOrSignUp('new@example.com', 'secret12');
    expect(calls, 2);
    expect(tokens.email, 'new@example.com');
  });

  test('wrong password on existing account reports invalid credentials', () async {
    final client = _client(
      post: (uri, headers, body) async {
        if (uri.path.contains('token')) {
          return const _FakeResponse(
            400,
            '{"msg":"Invalid login credentials"}',
          );
        }
        return const _FakeResponse(400, '{"msg":"User already registered"}');
      },
    );
    await expectLater(
      client.signInOrSignUp('user@example.com', 'wrongpassword'),
      throwsA(
        isA<TraceAuthFailure>().having(
          (e) => e.code,
          'code',
          'AUTH_INVALID_CREDENTIALS',
        ),
      ),
    );
  });

  test('refresh success returns rotated tokens', () async {
    final client = _client(
      post: (uri, headers, body) async {
        expect(uri.queryParameters['grant_type'], 'refresh_token');
        expect(body, contains('refresh_token'));
        return _FakeResponse(200, _okBody());
      },
    );
    final tokens = await client.refreshSession('refresh-old');
    expect(tokens.accessToken, 'access-1');
    expect(tokens.refreshToken, 'refresh-1');
  });

  test('rejected refresh maps to session-expired', () async {
    final client = _client(
      post: (uri, headers, body) async => const _FakeResponse(
        400,
        '{"msg":"Refresh token is not valid"}',
      ),
    );
    await expectLater(
      client.refreshSession('bogus'),
      throwsA(
        isA<TraceAuthFailure>().having(
          (e) => e.code,
          'code',
          'AUTH_SESSION_EXPIRED',
        ),
      ),
    );
    await expectLater(
      client.refreshSession(''),
      throwsA(
        isA<TraceAuthFailure>().having(
          (e) => e.code,
          'code',
          'AUTH_SESSION_EXPIRED',
        ),
      ),
    );
  });

  test('no message leaks raw codes, statuses, or server text', () {
    const banned = ['AUTH_', '400', '429', '500', 'http', 'Invalid login'];
    for (final code in [
      'AUTH_INVALID_EMAIL',
      'AUTH_WEAK_PASSWORD',
      'AUTH_INVALID_CREDENTIALS',
      'AUTH_ACCOUNT_EXISTS_SIGN_IN',
      'AUTH_REQUEST_INVALID',
      'AUTH_NETWORK_UNAVAILABLE',
      'AUTH_RATE_LIMITED',
      'AUTH_SERVICE_UNAVAILABLE',
      '',
      'AUTH_SOMETHING_NEW',
    ]) {
      final message = traceAuthMessage(code).message;
      expect(message, isNotEmpty, reason: code);
      for (final marker in banned) {
        expect(message.contains(marker), isFalse,
            reason: '$code message contains $marker');
      }
    }
  });

  test('retryable mirrors the client contract exactly', () {
    const retryable = {
      'AUTH_NETWORK_UNAVAILABLE',
      'AUTH_RATE_LIMITED',
      'AUTH_SERVICE_UNAVAILABLE',
    };
    for (final code in [
      'AUTH_INVALID_EMAIL',
      'AUTH_WEAK_PASSWORD',
      'AUTH_INVALID_CREDENTIALS',
      'AUTH_ACCOUNT_EXISTS_SIGN_IN',
      'AUTH_REQUEST_INVALID',
      'AUTH_NETWORK_UNAVAILABLE',
      'AUTH_RATE_LIMITED',
      'AUTH_SERVICE_UNAVAILABLE',
    ]) {
      expect(traceAuthMessage(code).retryable, retryable.contains(code),
          reason: code);
    }
  });
}

extension on _FakeResponse {
  _FakeResponse copyWith({required String body}) =>
      _FakeResponse(statusCode, body);
}
