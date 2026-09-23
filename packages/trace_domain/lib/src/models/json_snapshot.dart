/// Copies untrusted JSON into deeply immutable maps and lists.
/// Rejects objects with a custom `toJson` to keep tool/oplog data inert.
Map<String, Object?> snapshotJsonObject(Object? value, String field) {
  if (value is! Map<String, Object?>) {
    throw FormatException('$field must be a JSON object');
  }
  return Map.unmodifiable(
    value.map((key, item) => MapEntry(key, _freeze(item))),
  );
}

Object? _freeze(Object? value) {
  if (value == null || value is String || value is bool || value is int) {
    return value;
  }
  if (value is double && value.isFinite) return value;
  if (value is Map<String, Object?>) {
    return Map<String, Object?>.unmodifiable(
      value.map((key, item) => MapEntry(key, _freeze(item))),
    );
  }
  if (value is List) {
    return List<Object?>.unmodifiable(value.map(_freeze));
  }
  throw const FormatException('JSON value contains unsupported data');
}
