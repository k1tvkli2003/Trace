import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_design/trace_design.dart';

void main() {
  test('Signal Console uses matte graphite with accessible warm accents', () {
    expect(TraceColors.ink, const Color(0xff151a1d));
    expect(TraceColors.canvas, const Color(0xff1d2326));
    expect(TraceColors.muted, const Color(0xffaab4b2));
    expect(TraceColors.accent, const Color(0xffe9bc72));
    expect(TraceColors.navigation, const Color(0xff151a1d));
    expect(TraceColors.navigationSelected, const Color(0xff303a3c));
    expect(TraceColors.onCanvas, const Color(0xfff1f0e9));
    expect(TraceColors.seaGlass, const Color(0xff9ed8c0));
    expect(TraceColors.panel, const Color(0xff252c2f));
    expect(TraceColors.edge, const Color(0xff3e484a));
    expect(TraceTheme.dark().colorScheme.surface, TraceColors.canvas);
    expect(TraceTheme.dark().colorScheme.onSurface, TraceColors.onCanvas);
    expect(TraceTheme.light().colorScheme.onSurface, TraceColors.ink);
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

  test('app theme uses the dark console surface and English font', () {
    final theme = TraceTheme.dark();
    expect(theme.scaffoldBackgroundColor, TraceColors.canvas);
    expect(theme.colorScheme.primary, TraceColors.accent);
    expect(
      theme.textTheme.bodyMedium?.fontFamily,
      TraceTypography.english.fontFamily,
    );
  });
}
