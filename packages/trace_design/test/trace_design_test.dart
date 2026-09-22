import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('licensed Inter and Vazirmatn are bundled for offline use', () async {
    for (final asset in [
      'packages/trace_design/fonts/Inter-Variable.ttf',
      'packages/trace_design/fonts/Vazirmatn-Variable.ttf',
    ]) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0));
    }
  });
}
