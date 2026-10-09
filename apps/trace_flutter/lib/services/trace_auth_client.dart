/// Flutter-facing boundary for Supabase Auth email/password.
/// Unified sign-in-or-sign-up: tries sign-in first; on invalid credentials
/// tries sign-up once (unique email enforced server-side).
///
/// Sends email/password only to the project's Supabase Auth endpoint.
/// No secret handling: anon key travels as an `apikey` header only,
/// service role never enters this bundle. Errors are stable safe codes.
library;

import 'dart:convert';

/// Stable, safe code only. Never carries email, password, or server text.
final class TraceAuthFailure implements Exception {
  const TraceAuthFailure(this.code);
  final String code;
  @override
  String toString() => 'TraceAuthFailure($code)';
}

/// Minimal HTTP surface injected by caller (keeps client testable, no dep).
abstract interface class TraceAuthHttpResponse {
  int get statusCode;
  String get body;
}

typedef TraceAuthPost = Future<TraceAuthHttpResponse> Function(
  Uri uri,
  Map<String, String> headers,
  String body,
);

/// Signed-in session. Tokens only — never password.
final class TraceAuthTokens {
  const TraceAuthTokens({
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAtEpochSeconds,
    required this.userId,
  });

  final String email;
  final String accessToken;
  final String refreshToken;
  final int expiresAtEpochSeconds;
  final String userId;
}

final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Thin client: email/password in, tokens out, code-only errors.
final class TraceAuthClient {
  const TraceAuthClient({
    required this.supabaseUrl,
    required this.anonKey,
    required this.post,
  });

  final Uri supabaseUrl;
  final String anonKey;
  final TraceAuthPost post;

  static ({String email, String password}) validateCredentials(
    String email,
    String password,
  ) {
    final cleanEmail = email.trim().toLowerCase();
    if (!_email.hasMatch(cleanEmail) || cleanEmail.length > 254) {
      throw const TraceAuthFailure('AUTH_INVALID_EMAIL');
    }
    if (password.length < 6 || password.length > 128) {
      throw const TraceAuthFailure('AUTH_WEAK_PASSWORD');
    }
    return (email: cleanEmail, password: password);
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'apikey': anonKey,
  };

  /// Server sign-out: revokes the refresh token server-side (best effort —
  /// local state clears regardless so the user is never stuck signed in).
  Future<void> signOut(String accessToken) async {
    if (accessToken.isEmpty) return;
    try {
      await post(
        Uri.parse(
          '${supabaseUrl.toString().replaceAll(RegExp(r'/$'), '')}/auth/v1/logout',
        ),
        {'Content-Type': 'application/json', 'apikey': anonKey, 'Authorization': 'Bearer $accessToken'},
        '{}',
      );
    } catch (_) {
      // Offline or transient: local session still clears below.
    }
  }

  /// Refreshes an expired access token with a stored refresh token.
  /// Throws AUTH_SESSION_EXPIRED when the refresh token is rejected so the
  /// caller signs out instead of looping.
  Future<TraceAuthTokens> refreshSession(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw const TraceAuthFailure('AUTH_SESSION_EXPIRED');
    }
    final TraceAuthHttpResponse response;
    try {
      response = await post(
        _tokenUri('token', grantType: 'refresh_token'),
        _headers,
        jsonEncode({'refresh_token': refreshToken}),
      );
    } catch (_) {
      throw const TraceAuthFailure('AUTH_NETWORK_UNAVAILABLE');
    }
    Map<String, Object?> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, Object?>;
    } catch (_) {
      throw const TraceAuthFailure('AUTH_SERVICE_UNAVAILABLE');
    }
    if (response.statusCode == 200) {
      final access = decoded['access_token'];
      final refresh = decoded['refresh_token'];
      final expires = decoded['expires_in'];
      final user = decoded['user'];
      final userId = user is Map<String, Object?> ? user['id'] : null;
      // Email is not returned on refresh; keep the stored one.
      if (access is! String ||
          access.isEmpty ||
          refresh is! String ||
          refresh.isEmpty ||
          expires is! num ||
          userId is! String ||
          userId.isEmpty) {
        throw const TraceAuthFailure('AUTH_SERVICE_UNAVAILABLE');
      }
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      return TraceAuthTokens(
        email: '',
        accessToken: access,
        refreshToken: refresh,
        expiresAtEpochSeconds: now + expires.toInt(),
        userId: userId,
      );
    }
    throw TraceAuthFailure(_codeFor(response.statusCode, decoded));
  }

  Uri _authUri(String action) => _tokenUri(action, grantType: 'password');

  Uri _tokenUri(String action, {required String grantType}) => Uri.parse(
    '${supabaseUrl.toString().replaceAll(RegExp(r'/$'), '')}/auth/v1/$action?grant_type=$grantType',
  );

  /// Unified entry: sign in, else sign up once when no account exists.
  /// Unique email is enforced server-side; a wrong password on an existing
  /// account surfaces AUTH_INVALID_CREDENTIALS (server answers both cases
  /// identically, so an "already registered" signup answer after a failed
  /// sign-in means the password was wrong, not that the user should retry
  /// sign-in blindly).
  Future<TraceAuthTokens> signInOrSignUp(
    String email,
    String password,
  ) async {
    final credentials = validateCredentials(email, password);
    try {
      return await _token('token', credentials);
    } on TraceAuthFailure catch (failure) {
      if (failure.code != 'AUTH_INVALID_CREDENTIALS') rethrow;
      try {
        return await _token('signup', credentials);
      } on TraceAuthFailure catch (signupFailure) {
        if (signupFailure.code == 'AUTH_ACCOUNT_EXISTS_SIGN_IN') {
          throw const TraceAuthFailure('AUTH_INVALID_CREDENTIALS');
        }
        rethrow;
      }
    }
  }

  Future<TraceAuthTokens> _token(
    String action,
    ({String email, String password}) credentials,
  ) async {
    final TraceAuthHttpResponse response;
    try {
      response = await post(
        _authUri(action),
        _headers,
        jsonEncode({
          'email': credentials.email,
          'password': credentials.password,
        }),
      );
    } catch (_) {
      throw const TraceAuthFailure('AUTH_NETWORK_UNAVAILABLE');
    }
    Map<String, Object?> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, Object?>;
    } catch (_) {
      throw const TraceAuthFailure('AUTH_SERVICE_UNAVAILABLE');
    }
    if (response.statusCode == 200) {
      return _tokens(credentials.email, decoded);
    }
    throw TraceAuthFailure(_codeFor(response.statusCode, decoded));
  }

  TraceAuthTokens _tokens(String email, Map<String, Object?> json) {
    final access = json['access_token'];
    final refresh = json['refresh_token'];
    final expires = json['expires_in'];
    final user = json['user'];
    final userId = user is Map<String, Object?> ? user['id'] : null;
    if (access is! String ||
        access.isEmpty ||
        refresh is! String ||
        refresh.isEmpty ||
        expires is! num ||
        userId is! String ||
        userId.isEmpty) {
      throw const TraceAuthFailure('AUTH_SERVICE_UNAVAILABLE');
    }
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return TraceAuthTokens(
      email: email,
      accessToken: access,
      refreshToken: refresh,
      expiresAtEpochSeconds: now + expires.toInt(),
      userId: userId,
    );
  }

  String _codeFor(int status, Map<String, Object?> json) {
    final raw = _serverMessage(json).toLowerCase();
    if (status == 400) {
      if (raw.contains('invalid login credentials') ||
          raw.contains('invalid_grant')) {
        return 'AUTH_INVALID_CREDENTIALS';
      }
      if (raw.contains('refresh token') && raw.contains('not valid')) {
        return 'AUTH_SESSION_EXPIRED';
      }
      if (raw.contains('user already registered') ||
          raw.contains('already registered') ||
          raw.contains('already exists')) {
        return 'AUTH_ACCOUNT_EXISTS_SIGN_IN';
      }
      if (raw.contains('password')) return 'AUTH_WEAK_PASSWORD';
      if (raw.contains('email')) return 'AUTH_INVALID_EMAIL';
      return 'AUTH_REQUEST_INVALID';
    }
    if (status == 422) {
      if (raw.contains('password')) return 'AUTH_WEAK_PASSWORD';
      if (raw.contains('email')) return 'AUTH_INVALID_EMAIL';
      if (raw.contains('already registered') ||
          raw.contains('already exists')) {
        return 'AUTH_ACCOUNT_EXISTS_SIGN_IN';
      }
      return 'AUTH_REQUEST_INVALID';
    }
    if (status == 429) return 'AUTH_RATE_LIMITED';
    if (status >= 500) return 'AUTH_SERVICE_UNAVAILABLE';
    return 'AUTH_SERVICE_UNAVAILABLE';
  }

  String _serverMessage(Map<String, Object?> json) {
    final message = json['msg'];
    if (message is String) return message;
    final error = json['error_description'];
    if (error is String) return error;
    final code = json['error'];
    if (code is String) return code;
    return '';
  }
}
