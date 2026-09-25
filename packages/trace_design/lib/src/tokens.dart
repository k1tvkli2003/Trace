import 'package:flutter/material.dart';

import 'typography.dart';

/// Signal Console semantic color roles. Matte graphite console with warm
/// paper text, amber markers, and sea-glass reserved for real source state.
abstract final class TraceColors {
  static const ink = Color(0xff151a1d);
  static const canvas = Color(0xff1d2326);
  static const onCanvas = Color(0xfff1f0e9);
  static const muted = Color(0xffaab4b2);
  static const accent = Color(0xffe9bc72);
  static const seaGlass = Color(0xff9ed8c0);
  static const panel = Color(0xff252c2f);
  static const navigation = ink;
  static const navigationText = onCanvas;
  static const navigationMuted = muted;
  static const navigationSelected = Color(0xff303a3c);
  static const navigationMarker = accent;
  static const edge = Color(0xff3e484a);
  static const context = Color(0xff22292c);
  static const rail = Color(0xff191f22);
  static const paper = Color(0xfff6f1e7);
  static const paperInk = Color(0xff1f2422);
  static const deepMoss = Color(0xff27423c);
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
  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: TraceTypography.english.fontFamily,
    scaffoldBackgroundColor: TraceColors.canvas,
    colorScheme: const ColorScheme.dark(
      primary: TraceColors.accent,
      onPrimary: TraceColors.ink,
      secondary: TraceColors.seaGlass,
      onSecondary: TraceColors.ink,
      surface: TraceColors.canvas,
      onSurface: TraceColors.onCanvas,
      outline: TraceColors.edge,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: 'packages/trace_design/Inter',
        color: TraceColors.onCanvas,
      ),
    ),
  );

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: TraceColors.accent,
          surface: TraceColors.paper,
        ).copyWith(
          primary: TraceColors.deepMoss,
          onPrimary: TraceColors.paper,
          surface: TraceColors.paper,
          onSurface: TraceColors.ink,
        );
    return ThemeData(
      useMaterial3: true,
      fontFamily: TraceTypography.english.fontFamily,
      scaffoldBackgroundColor: TraceColors.paper,
      colorScheme: colorScheme,
      textTheme: TextTheme(bodyMedium: TraceTypography.english),
    );
  }
}
