/// Session-bound gateway handoff. No secret handling.
///
/// Reads the current local [TraceAuthSession] and runs exactly one
/// authenticated gateway call with the session access token. Missing or
/// expired sessions fail closed before any HTTP happens. Endpoint comes only
/// from --dart-define TRACE_GATEWAY_URL.
library;

import 'package:trace_data/trace_data.dart';

import 'trace_gateway_client.dart';

/// One narrow seam: session storage + gateway client -> authorized receipt.
final class SessionGatewayRunner {
  const SessionGatewayRunner({required this.sessions, required this.client});

  final LocalAuthSessionRepository sessions;
  final TraceGatewayClient client;

  Future<TraceGatewayReceipt> run(
    TraceGatewayRequest request, {
    String? gatewayLabelForLog,
  }) async {
    assert(
      gatewayLabelForLog == null,
      'logs keep labels only, never tokens or payloads',
    );
    final session = await sessions.current();
    if (session == null || session.isExpired) {
      throw const TraceGatewayFailure('AI_UNAUTHORIZED');
    }
    return client.run(request, jwt: session.accessToken);
  }
}

/// Production endpoint wiring: compile-time URL, injected HTTP post.
/// Throws the same stable not-configured code the server uses so the UI can
/// explain instead of crashing.
TraceGatewayClient productionGatewayClient({required TracePost post}) {
  const url = String.fromEnvironment('TRACE_GATEWAY_URL');
  if (url.isEmpty) {
    throw const TraceGatewayFailure('AI_GATEWAY_NOT_CONFIGURED');
  }
  return TraceGatewayClient(endpoint: Uri.parse(url), post: post);
}
