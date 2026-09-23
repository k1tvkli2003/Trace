import 'json_snapshot.dart';

/// Audit receipt for one proposed tool call; this model never executes it.
final class ToolInvocation {
  const ToolInvocation._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.toolName,
    required this.argsJson,
    required this.validationResult,
    required this.idempotencyKey,
    required this.mutationId,
    required this.resultJson,
    required this.createdAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String toolName;
  final Map<String, Object?> argsJson;
  final Map<String, Object?> validationResult;
  final String idempotencyKey;
  final String? mutationId;
  final Map<String, Object?>? resultJson;
  final String createdAt;

  factory ToolInvocation.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    Map<String, Object?> object(String key, {bool optional = false}) {
      final value = json[key];
      if (optional && value == null) return <String, Object?>{};
      return snapshotJsonObject(value, key);
    }

    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be positive');
    }
    final hash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final mutationId = json['mutationId'];
    if (mutationId != null &&
        (mutationId is! String || mutationId.trim().isEmpty)) {
      throw const FormatException('mutationId must be null or nonempty text');
    }
    final timestamp = text('createdAt');
    if (!timestamp.endsWith('Z') || DateTime.tryParse(timestamp)?.isUtc != true) {
      throw const FormatException('createdAt must be UTC ISO-8601');
    }
    final result = json['resultJson'];
    final resultJson = result == null ? null : object('resultJson');
    return ToolInvocation._(
      id: text('id'),
      version: version,
      contentHash: hash,
      toolName: text('toolName'),
      argsJson: object('argsJson'),
      validationResult: object('validationResult'),
      idempotencyKey: text('idempotencyKey'),
      mutationId: mutationId as String?,
      resultJson: resultJson,
      createdAt: timestamp,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'toolName': toolName,
    'argsJson': argsJson,
    'validationResult': validationResult,
    'idempotencyKey': idempotencyKey,
    'mutationId': mutationId,
    'resultJson': resultJson,
    'createdAt': createdAt,
  };
}
