enum ChatMessageRole {
  user('user'),
  assistant('assistant'),
  tool('tool'),
  system('system'),
  unsupported('unsupported');

  const ChatMessageRole(this.wireName);

  final String wireName;

  static ChatMessageRole fromWire(String value) {
    for (final role in values) {
      if (role.wireName == value) return role;
    }
    return unsupported;
  }
}

/// Immutable chat record with explicit source and tool provenance.
final class ChatMessage {
  const ChatMessage._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.threadId,
    required this.role,
    required this.rawRole,
    required this.body,
    required this.sourceCitationIds,
    required this.toolInvocationId,
    required this.createdAt,
    required this.rawCreatedAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String threadId;
  final ChatMessageRole role;
  final String rawRole;
  final String body;
  final List<String> sourceCitationIds;
  final String? toolInvocationId;
  final DateTime createdAt;
  final String rawCreatedAt;

  factory ChatMessage.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be a non-empty string');
      }
      return value;
    }

    final id = text('id');
    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be a positive integer');
    }
    final contentHash = text('contentHash');
    if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be a SHA-256 hex string');
    }
    final rawRole = text('role');
    final rawCitations = json['sourceCitationIds'];
    if (rawCitations is! List || rawCitations.any((value) => value is! String || value.trim().isEmpty)) {
      throw const FormatException('sourceCitationIds must be an array of non-empty strings');
    }
    final citationIds = rawCitations.cast<String>().toList(growable: false);
    if (citationIds.toSet().length != citationIds.length) {
      throw const FormatException('sourceCitationIds must not contain duplicates');
    }
    final toolInvocationId = json['toolInvocationId'];
    if (toolInvocationId != null &&
        (toolInvocationId is! String || toolInvocationId.trim().isEmpty)) {
      throw const FormatException('toolInvocationId must be null or a non-empty string');
    }

    final rawCreatedAt = text('createdAt');
    return ChatMessage._(
      id: id,
      version: version,
      contentHash: contentHash,
      threadId: text('threadId'),
      role: ChatMessageRole.fromWire(rawRole),
      rawRole: rawRole,
      body: text('body'),
      sourceCitationIds: List.unmodifiable(citationIds),
      toolInvocationId: toolInvocationId as String?,
      createdAt: _messageUtc(rawCreatedAt, 'createdAt'),
      rawCreatedAt: rawCreatedAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'version': version,
        'contentHash': contentHash,
        'threadId': threadId,
        'role': rawRole,
        'body': body,
        'sourceCitationIds': sourceCitationIds.toList(),
        'toolInvocationId': toolInvocationId,
        'createdAt': rawCreatedAt,
      };
}

DateTime _messageUtc(Object? value, String field) {
  if (value is! String) {
    throw FormatException('$field must be an ISO-8601 string');
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null || !parsed.isUtc) {
    throw FormatException('$field must be UTC');
  }
  return parsed;
}
