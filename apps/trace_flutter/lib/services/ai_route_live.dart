/// Live HTTP fetchers for the dual-route probe. No secret handling.
///
/// 9Router: unauthenticated `GET /v1/models` catalog read (ids only).
/// Local runtime: unauthenticated `GET /global/health` read.
/// No key, token, or prompt ever leaves this module.
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_route.dart';

final class LiveAiRouteFetchers {
  const LiveAiRouteFetchers({
    this.nineRouterModelsUrl = 'http://127.0.0.1:20128/v1/models',
    this.localHealthUrl = 'http://127.0.0.1:4096/global/health',
    this.timeout = const Duration(seconds: 4),
  });

  final String nineRouterModelsUrl;
  final String localHealthUrl;
  final Duration timeout;

  AiRouteProbe probe({http.Client? client}) {
    // Ownership: injected client is shared and never closed here (tests).
    // Owned path creates one client per leg so the 9Router leg can never
    // close the local-runtime leg's transport (lane-4 P1 / lane-5 F48).
    return AiRouteProbe(
      nineRouterModels: () async {
        final httpClient = client ?? http.Client();
        try {
          final response = await httpClient
              .get(Uri.parse(nineRouterModelsUrl))
              .timeout(timeout);
          if (response.statusCode != 200) {
            throw const AiRouteFailure('AI_PROVIDER_FAILURE');
          }
          final decoded = jsonDecode(response.body);
          final data = decoded is Map<String, Object?>
              ? decoded['data']
              : decoded;
          if (data is! List) throw const AiRouteFailure('AI_SCHEMA_REJECTED');
          return [
            for (final entry in data)
              if (entry is Map<String, Object?> && entry['id'] is String)
                entry['id']! as String,
          ];
        } catch (e) {
          if (e is AiRouteFailure) rethrow;
          throw const AiRouteFailure('AI_PROVIDER_FAILURE');
        } finally {
          if (client == null) httpClient.close();
        }
      },
      localHealth: () async {
        final httpClient = client ?? http.Client();
        try {
          final response = await httpClient
              .get(Uri.parse(localHealthUrl))
              .timeout(timeout);
          if (response.statusCode != 200) {
            throw const AiRouteFailure('AI_PROVIDER_FAILURE');
          }
          final decoded = jsonDecode(response.body);
          if (decoded is! Map<String, Object?> ||
              decoded['healthy'] != true) {
            throw const AiRouteFailure('AI_PROVIDER_FAILURE');
          }
          final version = decoded['version'];
          return (true, version is String ? version : 'unknown');
        } catch (e) {
          if (e is AiRouteFailure) rethrow;
          throw const AiRouteFailure('AI_PROVIDER_FAILURE');
        } finally {
          if (client == null) httpClient.close();
        }
      },
    );
  }
}
