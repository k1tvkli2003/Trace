enum ChatThreadStatus {
  active('active'),
  archived('archived'),
  unsupported('unsupported');

  const ChatThreadStatus(this.wireName);

  final String wireName;

  static ChatThreadStatus fromWire(String value) {
    for (final status in values) {
      if (status.wireName == value) return status;
    }
    return unsupported;
  }
}

/// Context anchor for one user conversation.
final class ChatThread {
  const ChatThread._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.libraryId,
    required this.targetNodeId,
    required this.targetSliceId,
    required this.title,
    required this.status,
    required this.rawStatus,
    required this.createdAt,
    required this.rawCreatedAt,
    required this.updatedAt,
    required this.rawUpdatedAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String libraryId;
  final String? targetNodeId;
  final String? targetSliceId;
  final String title;
  final ChatThreadStatus status;
  final String rawStatus;
  final DateTime createdAt;
  final String rawCreatedAt;
  final DateTime updatedAt;
  final String rawUpdatedAt;

  factory ChatThread.fromJson(Map<String, Object?> json) {
    String requiredText(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be a non-empty string');
      }
      return value;
    }

    String? optionalId(String key) {
      final value = json[key];
      if (value == null) return null;
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be null or a non-empty string');
      }
      return value;
    }

    final id = requiredText('id');
    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be a positive integer');
    }
    final contentHash = requiredText('contentHash');
    if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be a SHA-256 hex string');
    }
    final libraryId = requiredText('libraryId');
    final title = requiredText('title');
    if (title.length > 500) {
      throw const FormatException('title is too long');
    }
    final rawStatus = requiredText('status');
    final status = ChatThreadStatus.fromWire(rawStatus);
    final rawCreatedAt = requiredText('createdAt');
    final rawUpdatedAt = requiredText('updatedAt');
    final createdAt = _utc(rawCreatedAt, 'createdAt');
    final updatedAt = _utc(rawUpdatedAt, 'updatedAt');
    if (updatedAt.isBefore(createdAt)) {
      throw const FormatException('updatedAt cannot precede createdAt');
    }

    return ChatThread._(
      id: id,
      version: version,
      contentHash: contentHash,
      libraryId: libraryId,
      targetNodeId: optionalId('targetNodeId'),
      targetSliceId: optionalId('targetSliceId'),
      title: title,
      status: status,
      rawStatus: rawStatus,
      createdAt: createdAt,
      rawCreatedAt: rawCreatedAt,
      updatedAt: updatedAt,
      rawUpdatedAt: rawUpdatedAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'version': version,
        'contentHash': contentHash,
        'libraryId': libraryId,
        'targetNodeId': targetNodeId,
        'targetSliceId': targetSliceId,
        'title': title,
        'status': rawStatus,
        'createdAt': rawCreatedAt,
        'updatedAt': rawUpdatedAt,
      };
}

DateTime _utc(Object? value, String field) {
  if (value is! String) {
    throw FormatException('$field must be an ISO-8601 string');
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null || !parsed.isUtc) {
    throw FormatException('$field must be UTC');
  }
  return parsed;
}
