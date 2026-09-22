import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

void main() {
  test('page cache key round-trips without ambiguous concatenation', () {
    final json = <String, Object>{
      'sourceHash': 'a' * 64,
      'pageNumber': 2,
      'renderProfile': 'r/1',
      'visionModelProfile': 'model/1',
      'promptVersion': 'extract-v1',
    };
    final key = PageVisionCacheKey.fromJson(json);
    expect(key.toJson(), json);
    expect(PageVisionCacheKey.fromJson(key.toJson()).value, key.value);
    expect(
      key.value,
      isNot(
        PageVisionCacheKey.fromJson({...json, 'renderProfile': 'r/2'}).value,
      ),
    );
  });

  test('each extraction input changes cache identity', () {
    final input = <String, Object?>{
      'sourceHash': 'a' * 64,
      'pageNumber': 1,
      'renderProfile': 'render-v1',
      'visionModelProfile': 'own-model-v1',
      'promptVersion': 'extract-v1',
    };
    final original = PageVisionCacheKey.fromJson(input).value;
    for (final changed in <(String, Object)>[
      ('sourceHash', 'b' * 64),
      ('pageNumber', 2),
      ('renderProfile', 'render-v2'),
      ('visionModelProfile', 'own-model-v2'),
      ('promptVersion', 'extract-v2'),
    ]) {
      expect(
        PageVisionCacheKey.fromJson({...input, changed.$1: changed.$2}).value,
        isNot(original),
        reason: changed.$1,
      );
    }
    for (final invalid in <(String, Object?)>[
      ('sourceHash', 'bad'),
      ('pageNumber', 0),
      ('renderProfile', ' '),
      ('visionModelProfile', null),
      ('promptVersion', ''),
    ]) {
      expect(
        () => PageVisionCacheKey.fromJson({...input, invalid.$1: invalid.$2}),
        throwsFormatException,
        reason: invalid.$1,
      );
    }
  });

  test('structured key cannot collide when delimiters move', () {
    final input = <String, Object?>{
      'sourceHash': 'a' * 64,
      'pageNumber': 1,
      'renderProfile': 'a/b',
      'visionModelProfile': 'c',
      'promptVersion': 'v1',
    };
    final other = <String, Object?>{
      ...input,
      'renderProfile': 'a',
      'visionModelProfile': 'b/c',
    };
    expect(
      PageVisionCacheKey.fromJson(input).value,
      isNot(PageVisionCacheKey.fromJson(other).value),
    );
  });
}
