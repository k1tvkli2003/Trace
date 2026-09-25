import 'package:test/test.dart';
import 'package:trace_data/trace_data.dart';

void main() {
  test('first retry waits for base delay', () {
    expect(LocalOplogRepository.retryDelay(0), const Duration(seconds: 10));
  });

  test('delay grows exponentially with retry count', () {
    expect(LocalOplogRepository.retryDelay(1), const Duration(seconds: 20));
    expect(LocalOplogRepository.retryDelay(2), const Duration(seconds: 40));
  });

  test('delay caps at max instead of growing forever', () {
    expect(LocalOplogRepository.retryDelay(100), const Duration(minutes: 5));
  });

  test('negative retry count fails closed', () {
    expect(() => LocalOplogRepository.retryDelay(-1), throwsArgumentError);
  });
}
