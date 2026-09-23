enum LibraryLanguage {
  fa('fa'),
  en('en'),
  mixed('mixed'),
  unsupported('unsupported');

  const LibraryLanguage(this.wireName);

  final String wireName;
}

/// User-owned learning library identity; source bytes live in documents.
final class LibraryItem {
  const LibraryItem._({
    required this.id,
    required this.version,
    required this.contentHash,
    required this.title,
    required this.language,
    required this.rawLanguage,
    required this.ownerId,
    required this.defaultNodeId,
    required this.createdAt,
    required this.rawCreatedAt,
  });

  final String id;
  final int version;
  final String contentHash;
  final String title;
  final LibraryLanguage language;
  final String rawLanguage;
  final String ownerId;
  final String? defaultNodeId;
  final DateTime createdAt;
  final String rawCreatedAt;

  factory LibraryItem.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final version = json['version'];
    if (version is! int || version < 1) {
      throw const FormatException('version must be a positive integer');
    }

    final contentHash = text('contentHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }

    final rawDefaultNodeId = json['defaultNodeId'];
    if (rawDefaultNodeId != null &&
        (rawDefaultNodeId is! String || rawDefaultNodeId.trim().isEmpty)) {
      throw const FormatException(
        'defaultNodeId must be null or nonempty text',
      );
    }

    final rawCreatedAt = text('createdAt');
    final createdAt = DateTime.tryParse(rawCreatedAt);
    if (createdAt == null || !createdAt.isUtc || !rawCreatedAt.endsWith('Z')) {
      throw const FormatException(
        'createdAt must be an ISO-8601 UTC timestamp',
      );
    }

    final rawLanguage = text('language');
    final language = LibraryLanguage.values
        .where((candidate) => candidate.wireName == rawLanguage)
        .firstOrNull;

    return LibraryItem._(
      id: text('id'),
      version: version,
      contentHash: contentHash,
      title: text('title'),
      language: language ?? LibraryLanguage.unsupported,
      rawLanguage: rawLanguage,
      ownerId: text('ownerId'),
      defaultNodeId: rawDefaultNodeId as String?,
      createdAt: createdAt,
      rawCreatedAt: rawCreatedAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'contentHash': contentHash,
    'title': title,
    'language': rawLanguage,
    'ownerId': ownerId,
    'defaultNodeId': defaultNodeId,
    'createdAt': rawCreatedAt,
  };
}
