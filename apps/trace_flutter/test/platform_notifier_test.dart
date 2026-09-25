import 'package:flutter_test/flutter_test.dart';
import 'package:trace_flutter/platform_notifier.dart';
import 'package:trace_flutter/render_resume.dart';

void main() {
  test('foreground notifier never claims background delivery', () {
    const notifier = TracePlatformNotifier(backgroundDelivery: false);
    final receipt = notifier.previewDueNotice(
      reviewId: 'r1',
      title: 'Review due',
      locator: 'p.1 · chapter.pdf',
    );
    expect(receipt.deliveredInBackground, isFalse);
    expect(receipt.fallbackToInbox, isTrue);
    expect(receipt.locator, 'p.1 · chapter.pdf');
  });

  test('resume helper returns only requested unfinished pages', () {
    expect(
      remainingRenderPages(requested: const [1, 2, 3], completed: const [1, 3]),
      [2],
    );
    expect(
      remainingRenderPages(requested: const [2, 1], completed: const []),
      isEmpty,
      reason: 'out-of-order request is not guessed',
    );
    expect(
      remainingRenderPages(requested: const [1, 2], completed: const [9]),
      isEmpty,
      reason: 'foreign checkpoint pages are ignored, never rendered',
    );
  });
}
