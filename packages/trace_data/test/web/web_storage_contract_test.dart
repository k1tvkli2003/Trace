import 'dart:io';

import 'package:test/test.dart';

/// Stage 9 web-storage contract.
///
/// Pins the browser storage identity and requires a real-evidence matrix at
/// `docs/platform/web-storage-matrix.md`. This test runs on the VM and guards
/// the contract; the reload/OPFS/single-tab/stale-recovery proof itself must
/// come from a real Chrome run (tool/smoke_web_library.py), never from a mock.
void main() {
  group('web storage contract', () {
    test('web connection pins sharedIndexedDb and fails closed', () {
      final webConnection = File(
        '../../apps/trace_flutter/lib/local_connection_web.dart',
      );
      expect(
        webConnection.existsSync(),
        isTrue,
        reason: 'missing apps/trace_flutter/lib/local_connection_web.dart',
      );
      final source = webConnection.readAsStringSync();
      expect(
        source.contains('sharedIndexedDb'),
        isTrue,
        reason: 'web connection must pin sharedIndexedDb storage identity',
      );
      expect(
        source.contains('trace_local_v1'),
        isTrue,
        reason: 'web database name must stay trace_local_v1',
      );
      expect(
        source.contains('StateError') || source.contains('throw'),
        isTrue,
        reason: 'web connection must fail closed when storage unavailable',
      );
    });

    test('native and web share one database name', () {
      final nativeConnection = File(
        '../../apps/trace_flutter/lib/local_connection_native.dart',
      );
      final webConnection = File(
        '../../apps/trace_flutter/lib/local_connection_web.dart',
      );
      expect(nativeConnection.existsSync(), isTrue);
      expect(webConnection.existsSync(), isTrue);
      final native = nativeConnection.readAsStringSync();
      final web = webConnection.readAsStringSync();
      expect(native.contains('trace_local_v1'), isTrue);
      expect(web.contains('trace_local_v1'), isTrue);
    });

    test('web storage matrix documents real-evidence proof', () {
      final matrix = File('../../docs/platform/web-storage-matrix.md');
      expect(
        matrix.existsSync(),
        isTrue,
        reason: 'missing docs/platform/web-storage-matrix.md (Stage 9)',
      );
      final body = matrix.readAsStringSync();
      for (final required in <String>[
        'persistence after reload',
        'no OPFS',
        'single-tab',
        'stale storage recovery',
        'multi-tab',
        'trace_local_v1',
        'sharedIndexedDb',
      ]) {
        expect(
          body.toLowerCase().contains(required.toLowerCase()),
          isTrue,
          reason: 'matrix must cover: $required',
        );
      }
    });
  });
}
