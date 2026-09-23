import 'json_snapshot.dart';

enum SyncMutationType {
  insert('insert'),
  update('update'),
  delete('delete'),
  unsupported('unsupported');

  const SyncMutationType(this.wireName);
  final String wireName;

  static SyncMutationType fromWire(String value) => values.firstWhere(
        (candidate) => candidate.wireName == value,
        orElse: () => SyncMutationType.unsupported,
      );
}

enum SyncState {
  pending('pending'),
  inFlight('in_flight'),
  synced('synced'),
  failed('failed'),
  tombstone('tombstone'),
  unsupported('unsupported');

  const SyncState(this.wireName);
  final String wireName;

  static SyncState fromWire(String value) => values.firstWhere(
        (candidate) => candidate.wireName == value,
        orElse: () => SyncState.unsupported,
      );
}

/// Local-first mutation queued for idempotent server replay.
final class SyncOperation {
  const SyncOperation._({
    required this.operationId,
    required this.version,
    required this.contentHash,
    required this.entityType,
    required this.entityId,
    required this.mutationType,
    required this.rawMutationType,
    required this.payload,
    required this.localVersion,
    required this.syncState,
    required this.rawSyncState,
    required this.retryCount,
    required this.createdAt,
  });

  final String operationId;
  final int version;
  final String contentHash;
  final String entityType;
  final String entityId;
  final SyncMutationType mutationType;
  final String rawMutationType;
  final Map<String, Object?> payload;
  final int localVersion;
  final SyncState syncState;
  final String rawSyncState;
  final int retryCount;
  final String createdAt;

  factory SyncOperation.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final version = json['version'];
    final localVersion = json['localVersion'];
    final retryCount = json['retryCount'];
    if (version is! int || version < 1 ||
        localVersion is! int || localVersion < 0 ||
        retryCount is! int || retryCount < 0) {
      throw const FormatException('invalid sync version or retry numbers');
    }
    final contentHash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    final payload = snapshotJsonObject(json['payload'], 'payload');
    final createdAt = text('createdAt');
    if (!createdAt.endsWith('Z') || DateTime.tryParse(createdAt)?.isUtc != true) {
      throw const FormatException('createdAt must be UTC ISO-8601');
    }
    final rawMutationType = text('mutationType');
    final rawSyncState = text('syncState');
    return SyncOperation._(
      operationId: text('operationId'),
      version: version,
      contentHash: contentHash,
      entityType: text('entityType'),
      entityId: text('entityId'),
      mutationType: SyncMutationType.fromWire(rawMutationType),
      rawMutationType: rawMutationType,
      payload: payload,
      localVersion: localVersion,
      syncState: SyncState.fromWire(rawSyncState),
      rawSyncState: rawSyncState,
      retryCount: retryCount,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
        'operationId': operationId,
        'version': version,
        'contentHash': contentHash,
        'entityType': entityType,
        'entityId': entityId,
        'mutationType': rawMutationType,
        'payload': payload,
        'localVersion': localVersion,
        'syncState': rawSyncState,
        'retryCount': retryCount,
        'createdAt': createdAt,
      };
}
