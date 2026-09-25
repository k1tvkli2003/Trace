import 'package:test/test.dart';
import 'package:trace_domain/trace_domain.dart';

ReviewItem reviewItem({
  String id = 'r1',
  String dueAt = '2026-09-25T10:00:00Z',
  String state = 'active',
}) => ReviewItem.fromJson({
  'id': id,
  'version': 1,
  'contentHash': 'a' * 64,
  'targetType': 'lesson_box',
  'targetId': 'lesson-1',
  'dueAt': dueAt,
  'intervalDays': 1,
  'ease': 2.5,
  'lapses': 0,
  'state': state,
  'schedulerVersion': 'fixed-offset-v2',
});

void main() {
  test('unsupported platform capability request fails closed', () {
    expect(
      () => PlatformCapabilities.require(
        const PlatformCapabilities(
          localNotifications: false,
          backgroundExecution: false,
          secureStorage: false,
          filePicker: true,
          windowIntegration: true,
        ),
        PlatformCapability.localNotifications,
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('due notice policy admits only active due items and dedupes', () {
    final admitted = DueNoticePolicy.admit([
      reviewItem(),
      reviewItem(),
      reviewItem(id: 'future', dueAt: '2026-09-26T10:00:00Z'),
      reviewItem(id: 'suspended', state: 'suspended'),
    ], nowUtc: DateTime.parse('2026-09-25T10:00:01Z'));
    expect(admitted.map((item) => item.id), ['r1']);
  });
}
