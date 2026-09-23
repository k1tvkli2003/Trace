enum AiRunOutcome {
  succeeded('succeeded'),
  failed('failed'),
  cancelled('cancelled'),
  cacheHit('cache_hit'),
  unsupported('unsupported');

  const AiRunOutcome(this.wireName);
  final String wireName;

  static AiRunOutcome fromWire(String value) => values.firstWhere(
    (candidate) => candidate.wireName == value,
    orElse: () => AiRunOutcome.unsupported,
  );
}

/// Private AI usage metadata. Source text and credentials have no field here.
final class AiRunLedger {
  const AiRunLedger._({
    required this.runId,
    required this.version,
    required this.contentHash,
    required this.capability,
    required this.inputHashes,
    required this.modelProfile,
    required this.promptVersion,
    required this.inputTokens,
    required this.outputTokens,
    required this.costMicros,
    required this.latencyMs,
    required this.retryCount,
    required this.outcome,
    required this.rawOutcome,
    required this.createdAt,
  });

  final String runId;
  final int version;
  final String contentHash;
  final String capability;
  final List<String> inputHashes;
  final String modelProfile;
  final String promptVersion;
  final int inputTokens;
  final int outputTokens;
  final int? costMicros;
  final int latencyMs;
  final int retryCount;
  final AiRunOutcome outcome;
  final String rawOutcome;
  final String createdAt;

  factory AiRunLedger.fromJson(Map<String, Object?> json) {
    const allowedKeys = <String>{
      'runId',
      'version',
      'contentHash',
      'capability',
      'inputHashes',
      'modelProfile',
      'promptVersion',
      'inputTokens',
      'outputTokens',
      'costMicros',
      'latencyMs',
      'retryCount',
      'outcome',
      'createdAt',
    };
    if (json.keys.any((key) => !allowedKeys.contains(key))) {
      throw const FormatException('Unexpected AiRunLedger field');
    }

    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    int nonnegative(String key, {bool positive = false}) {
      final value = json[key];
      if (value is! int || value < (positive ? 1 : 0)) {
        throw FormatException(
          '$key must be ${positive ? 'positive' : 'nonnegative'}',
        );
      }
      return value;
    }

    final hashPattern = RegExp(r'^[a-f0-9]{64}$');
    final hash = text('contentHash');
    if (!hashPattern.hasMatch(hash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final inputHashes = json['inputHashes'];
    if (inputHashes is! List ||
        inputHashes.any(
          (value) => value is! String || !hashPattern.hasMatch(value),
        )) {
      throw const FormatException('inputHashes must be SHA-256 hex strings');
    }
    final typedInputHashes = inputHashes.cast<String>();
    if (typedInputHashes.toSet().length != typedInputHashes.length) {
      throw const FormatException('inputHashes must not contain duplicates');
    }
    final cost = json['costMicros'];
    if (cost != null && (cost is! int || cost < 0)) {
      throw const FormatException('costMicros must be null or nonnegative');
    }
    final createdAt = text('createdAt');
    if (!createdAt.endsWith('Z') ||
        DateTime.tryParse(createdAt)?.isUtc != true) {
      throw const FormatException('createdAt must be UTC ISO-8601');
    }
    final rawOutcome = text('outcome');
    return AiRunLedger._(
      runId: text('runId'),
      version: nonnegative('version', positive: true),
      contentHash: hash,
      capability: text('capability'),
      inputHashes: List.unmodifiable(inputHashes.cast<String>()),
      modelProfile: text('modelProfile'),
      promptVersion: text('promptVersion'),
      inputTokens: nonnegative('inputTokens'),
      outputTokens: nonnegative('outputTokens'),
      costMicros: cost as int?,
      latencyMs: nonnegative('latencyMs'),
      retryCount: nonnegative('retryCount'),
      outcome: AiRunOutcome.fromWire(rawOutcome),
      rawOutcome: rawOutcome,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'runId': runId,
    'version': version,
    'contentHash': contentHash,
    'capability': capability,
    'inputHashes': inputHashes.toList(),
    'modelProfile': modelProfile,
    'promptVersion': promptVersion,
    'inputTokens': inputTokens,
    'outputTokens': outputTokens,
    'costMicros': costMicros,
    'latencyMs': latencyMs,
    'retryCount': retryCount,
    'outcome': rawOutcome,
    'createdAt': createdAt,
  };
}
