/// Versioned resume pointer; advancing it requires a separate atomic write.
final class SliceCursor {
  const SliceCursor._({
    required this.id,
    required this.version,
    required this.stateHash,
    required this.libraryId,
    required this.nodeId,
    required this.currentSliceId,
    required this.nextBlockIndex,
    required this.nextPageNumber,
    required this.lookaheadState,
    required this.plannerVersion,
  });

  final String id;
  final int version;
  final String stateHash;
  final String libraryId;
  final String nodeId;
  final String? currentSliceId;
  final int nextBlockIndex;
  final int? nextPageNumber;
  final String lookaheadState;
  final String plannerVersion;

  factory SliceCursor.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be nonempty text');
      }
      return value;
    }

    final version = json['version'];
    final nextBlock = json['nextBlockIndex'];
    final nextPage = json['nextPageNumber'];
    final current = json['currentSliceId'];
    if (version is! int || version < 1 || nextBlock is! int || nextBlock < 0) {
      throw const FormatException('Invalid cursor version or block index');
    }
    if (nextPage != null && (nextPage is! int || nextPage < 1)) {
      throw const FormatException('nextPageNumber must be a positive integer');
    }
    if (current != null && (current is! String || current.trim().isEmpty)) {
      throw const FormatException(
        'currentSliceId must be null or nonempty text',
      );
    }
    final hash = text('stateHash');
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException('stateHash must be lowercase SHA-256 hex');
    }
    return SliceCursor._(
      id: text('id'),
      version: version,
      stateHash: hash,
      libraryId: text('libraryId'),
      nodeId: text('nodeId'),
      currentSliceId: current as String?,
      nextBlockIndex: nextBlock,
      nextPageNumber: nextPage as int?,
      lookaheadState: text('lookaheadState'),
      plannerVersion: text('plannerVersion'),
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'stateHash': stateHash,
    'libraryId': libraryId,
    'nodeId': nodeId,
    'currentSliceId': currentSliceId,
    'nextBlockIndex': nextBlockIndex,
    'nextPageNumber': nextPageNumber,
    'lookaheadState': lookaheadState,
    'plannerVersion': plannerVersion,
  };
}
