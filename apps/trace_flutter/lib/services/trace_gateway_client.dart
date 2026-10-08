/// Flutter-facing boundary for POST /api/trace-ai-run. No secret handling.
///
/// Client sends Supabase Auth JWT + bounded fields only. Upstream model
/// key and Supabase service role never enter this bundle.
library;

import 'dart:convert';

/// Stable, safe code only. Never carries prompt, image, or provider data.
final class TraceGatewayFailure implements Exception {
  const TraceGatewayFailure(this.code);
  final String code;
  @override
  String toString() => 'TraceGatewayFailure($code)';
}

final _keyChars = RegExp(r'^[A-Za-z0-9\-_.]{1,128}$');
final _sha = RegExp(r'^[a-f0-9]{64}$');

/// Eleven-field wire request. Validation mirrors server preflight.
final class TraceGatewayRequest {
  const TraceGatewayRequest({
    required this.operation,
    required this.capability,
    required this.pageRef,
    required this.sourceHash,
    required this.pixelHash,
    required this.renderProfile,
    required this.pagePngBase64,
    required this.reasoningEffort,
    required this.maxOutputTokens,
    required this.maxElapsedSeconds,
    required this.idempotencyKey,
  });

  final String operation;
  final String capability;
  final String pageRef;
  final String sourceHash;
  final String pixelHash;
  final String renderProfile;
  final String pagePngBase64;
  final String reasoningEffort;
  final int maxOutputTokens;
  final double maxElapsedSeconds;
  final String idempotencyKey;

  TraceGatewayRequest copyWith({
    String? reasoningEffort,
    int? maxOutputTokens,
  }) =>
      TraceGatewayRequest(
        operation: operation,
        capability: capability,
        pageRef: pageRef,
        sourceHash: sourceHash,
        pixelHash: pixelHash,
        renderProfile: renderProfile,
        pagePngBase64: pagePngBase64,
        reasoningEffort: reasoningEffort ?? this.reasoningEffort,
        maxOutputTokens: maxOutputTokens ?? this.maxOutputTokens,
        maxElapsedSeconds: maxElapsedSeconds,
        idempotencyKey: idempotencyKey,
      );

  Map<String, Object?> toWireJson() {
    if (operation.isEmpty ||
        operation.length > 128 ||
        capability != 'page_vision_extract' ||
        pageRef.isEmpty ||
        pageRef.length > 256 ||
        renderProfile.trim().isEmpty ||
        renderProfile.length > 128 ||
        !_sha.hasMatch(sourceHash) ||
        !_sha.hasMatch(pixelHash) ||
        (reasoningEffort != 'high' && reasoningEffort != 'xhigh') ||
        maxOutputTokens < 1 ||
        maxElapsedSeconds <= 0 ||
        maxElapsedSeconds > 600 ||
        !_keyChars.hasMatch(idempotencyKey) ||
        pagePngBase64.isEmpty ||
        pagePngBase64.length > 5592408) {
      throw const TraceGatewayFailure('AI_VISION_REQUEST_INVALID');
    }
    try {
      final bytes = base64.decode(pagePngBase64);
      if (bytes.length < 16 ||
          bytes.length > 3 * 1024 * 1024 ||
          base64.encode(bytes) != pagePngBase64) {
        throw const TraceGatewayFailure('AI_PAGE_IMAGE_INVALID');
      }
    } on FormatException {
      throw const TraceGatewayFailure('AI_PAGE_IMAGE_INVALID');
    }
    return {
      'operation': operation,
      'capability': capability,
      'page_ref': pageRef,
      'source_hash': sourceHash,
      'pixel_hash': pixelHash,
      'render_profile': renderProfile,
      'page_png': pagePngBase64,
      'reasoning_effort': reasoningEffort,
      'max_output_tokens': maxOutputTokens,
      'max_elapsed_seconds': maxElapsedSeconds,
      'idempotency_key': idempotencyKey,
    };
  }
}

/// Safe receipt subset. No prompt, image, secret, or raw provider data.
final class TraceGatewayReceipt {
  const TraceGatewayReceipt({
    required this.requestId,
    required this.status,
    required this.operation,
    required this.capability,
    required this.model,
    required this.reasoningEffort,
    required this.elapsedSeconds,
  });

  final String requestId;
  final String status;
  final String operation;
  final String capability;
  final String model;
  final String reasoningEffort;
  final double elapsedSeconds;

  factory TraceGatewayReceipt.fromJson(Map<String, Object?> json) {
    final requestId = json['requestId'];
    final status = json['status'];
    final operation = json['operation'];
    final capability = json['capability'];
    final model = json['model'];
    final effort = json['reasoningEffort'];
    final elapsed = json['elapsedSeconds'];
    if (requestId is! String ||
        requestId.length != 32 ||
        (status != 'completed' && status != 'failed') ||
        operation is! String ||
        operation.isEmpty ||
        capability != 'page_vision_extract' ||
        model is! String ||
        model.isEmpty ||
        (effort != 'high' && effort != 'xhigh') ||
        elapsed is! num ||
        elapsed < 0 ||
        elapsed > 600) {
      throw const TraceGatewayFailure('AI_SCHEMA_REJECTED');
    }
    return TraceGatewayReceipt(
      requestId: requestId,
      status: status as String,
      operation: operation,
      capability: capability as String,
      model: model,
      reasoningEffort: effort as String,
      elapsedSeconds: elapsed.toDouble(),
    );
  }
}

/// Minimal HTTP surface injected by caller (keeps client testable, no dep).
abstract interface class TraceHttpResponse {
  int get statusCode;
  String get body;
}

typedef TracePost = Future<TraceHttpResponse> Function(
    Uri uri, Map<String, String> headers, String body);

/// Thin client: JWT in Authorization header, bounded JSON out, code-only errors.
final class TraceGatewayClient {
  const TraceGatewayClient({required this.endpoint, required this.post});

  final Uri endpoint;
  final TracePost post;

  Future<TraceGatewayReceipt> run(TraceGatewayRequest request,
      {required String jwt}) async {
    if (jwt.isEmpty) throw const TraceGatewayFailure('AI_UNAUTHORIZED');
    final wire = request.toWireJson();
    final TraceHttpResponse response;
    try {
      response = await post(
        endpoint,
        {'Content-Type': 'application/json', 'Authorization': 'Bearer $jwt'},
        jsonEncode(wire),
      );
    } catch (_) {
      throw const TraceGatewayFailure('AI_PROVIDER_FAILURE');
    }
    Map<String, Object?> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, Object?>;
    } catch (_) {
      throw const TraceGatewayFailure('AI_SCHEMA_REJECTED');
    }
    if (response.statusCode == 200) {
      final receipt = decoded['receipt'];
      if (receipt is Map<String, Object?>) {
        return TraceGatewayReceipt.fromJson(receipt);
      }
      throw const TraceGatewayFailure('AI_SCHEMA_REJECTED');
    }
    final error = decoded['error'];
    final code = error is Map<String, Object?> ? error['code'] : null;
    if (code is String && code.startsWith('AI_')) {
      throw TraceGatewayFailure(code);
    }
    throw const TraceGatewayFailure('AI_PROVIDER_FAILURE');
  }
}
