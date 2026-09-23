import 'package:flutter/material.dart';

import 'typography.dart';

/// Quiet Index semantic color roles.
abstract final class TraceColors {
  static const ink = Color(0xff202b2b);
  static const canvas = Color(0xfffaf9f4);
  static const muted = Color(0xff606d69);
  static const accent = Color(0xff2f6b60);
  static const accentSoft = Color(0xffdfede7);
  static const navigation = ink;
  static const navigationText = Colors.white;
  static const navigationMuted = Color(0xffa9c1bc);
  static const navigationSelected = Color(0xff304a49);
  static const navigationMarker = Color(0xffe5a27a);
  static const edge = Color(0xffdbe5e0);
  static const context = Color(0xffeef4ef);
  static const rail = Color(0xfff5f5f1);
}

/// Shared 4/8-based spacing ramp. Repeated layout values use these roles.
abstract final class TraceSpace {
  static const zero = 0.0;
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s7 = 32.0;
  static const s8 = 40.0;
  static const s9 = 48.0;
  static const s10 = 64.0;
}

abstract final class TraceRadius {
  static const control = 8.0;
  static const panel = 12.0;
  static const stage = 16.0;
}

abstract final class TraceMotion {
  static const quick = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 240);
}

/// Constraint-derived shell geometry. Values are semantic layout bounds, not
/// device-specific coordinates.
abstract final class TraceGeometry {
  static const navigationWidth = 264.0;
  static const compactBreakpoint = 700.0;
  static const evidenceRailBreakpoint = 1180.0;
  static const evidenceRailRatio = 0.28;
  static const evidenceRailMinWidth = 270.0;
  static const evidenceRailMaxWidth = 360.0;
  static const minTeachingWidth = 560.0;
  static const lessonMaxWidth = 780.0;
  static const touchTarget = 48.0;

  static bool isCompact(double viewportWidth) =>
      viewportWidth < compactBreakpoint;

  static bool canShowEvidenceRail(double viewportWidth) =>
      viewportWidth >= evidenceRailBreakpoint;

  static double evidenceWidth(double viewportWidth) =>
      (viewportWidth * evidenceRailRatio)
          .clamp(evidenceRailMinWidth, evidenceRailMaxWidth)
          .toDouble();
}

abstract final class TraceTheme {
  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: TraceColors.accent,
          surface: TraceColors.canvas,
        ).copyWith(
          primary: TraceColors.accent,
          onPrimary: Colors.white,
          surface: TraceColors.canvas,
          onSurface: TraceColors.ink,
        );
    return ThemeData(
      useMaterial3: true,
      fontFamily: TraceTypography.english.fontFamily,
      scaffoldBackgroundColor: TraceColors.canvas,
      colorScheme: colorScheme,
      textTheme: TextTheme(bodyMedium: TraceTypography.english),
    );
  }
}
