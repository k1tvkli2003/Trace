import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_design/trace_design.dart';

void main() {
  test('Quiet Index palette and geometry remain one shared contract', () {
    expect(TraceColors.ink, const Color(0xff202b2b));
    expect(TraceColors.canvas, const Color(0xfffaf9f4));
    expect(TraceColors.muted, const Color(0xff606d69));
    expect(TraceColors.accent, const Color(0xff2f6b60));
    expect(TraceSpace.s1, 4);
    expect(TraceSpace.s6, 24);
    expect(TraceGeometry.navigationWidth, 264);
    expect(TraceGeometry.evidenceWidth(1180), closeTo(330.4, 0.001));
    expect(TraceGeometry.evidenceWidth(1440), 360);
  });

  test('rail only fits when teaching area keeps a readable minimum', () {
    expect(TraceGeometry.isCompact(699), isTrue);
    expect(TraceGeometry.isCompact(700), isFalse);
    expect(TraceGeometry.canShowEvidenceRail(1179), isFalse);
    expect(TraceGeometry.canShowEvidenceRail(1180), isTrue);
    expect(
      1180 - TraceGeometry.navigationWidth - TraceGeometry.evidenceWidth(1180),
      greaterThanOrEqualTo(TraceGeometry.minTeachingWidth),
    );
  });

  test('app theme uses the shared surface and English font', () {
    final theme = TraceTheme.light();
    expect(theme.scaffoldBackgroundColor, TraceColors.canvas);
    expect(theme.colorScheme.primary, TraceColors.accent);
    expect(
      theme.textTheme.bodyMedium?.fontFamily,
      TraceTypography.english.fontFamily,
    );
  });
}
