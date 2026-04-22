import 'package:flutter/material.dart';

/// Design tokens — "Encre & Ambre"
class FigmaContract {
  // ═══════════════════════════════════════════════════════
  // Colors
  // ═══════════════════════════════════════════════════════

  static const Color bg          = Color(0xFFF7F3EC);
  static const Color surface     = Color(0xFFFEFCF8);
  static const Color primary     = Color(0xFFB8622A);

  /// Fond très doux — quasi invisible, juste un souffle d'ambre
  static const Color primaryLight = Color(0xFFFBF6F1);

  static const Color primaryDark  = Color(0xFF8C4718);
  static const Color textPrimary  = Color(0xFF1A1410);
  static const Color textSecondary = Color(0xFF726560);
  static const Color border       = Color(0xFFE8DDD2);
  static const Color danger       = Color(0xFFB5290A);
  static const Color success      = Color(0xFF2E7D52);

  // ═══════════════════════════════════════════════════════
  // Typography
  // ═══════════════════════════════════════════════════════

  static const String fontFamily   = 'Georgia';
  static const double h1Size       = 28;
  static const double h2Size       = 20;
  static const double bodySize     = 15;
  static const double captionSize  = 12;

  static const FontWeight h1Weight      = FontWeight.w700;
  static const FontWeight h2Weight      = FontWeight.w700;
  static const FontWeight bodyWeight    = FontWeight.w400;
  static const FontWeight captionWeight = FontWeight.w500;

  static const double h1Height   = 1.25;
  static const double bodyHeight = 1.55;

  // ═══════════════════════════════════════════════════════
  // Spacing & Radius
  // ═══════════════════════════════════════════════════════

  static const double rSm = 10;
  static const double rMd = 16;
  static const double rLg = 22;

  static const double s2  = 2;
  static const double s4  = 4;
  static const double s8  = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;

  // ═══════════════════════════════════════════════════════
  // Shadows
  // ═══════════════════════════════════════════════════════

  static List<BoxShadow> cardShadow = const [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
      color: Color(0x12B8622A),
    ),
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -4,
      color: Color(0x0A7A3A10),
    ),
  ];

  // ═══════════════════════════════════════════════════════
  // Text styles
  // ═══════════════════════════════════════════════════════

  static TextStyle h1() => const TextStyle(
        fontFamily: fontFamily,
        fontSize: h1Size,
        fontWeight: h1Weight,
        height: h1Height,
        color: textPrimary,
        letterSpacing: -0.4,
      );

  static TextStyle h2() => const TextStyle(
        fontFamily: fontFamily,
        fontSize: h2Size,
        fontWeight: h2Weight,
        color: textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle body() => const TextStyle(
        fontFamily: fontFamily,
        fontSize: bodySize,
        fontWeight: bodyWeight,
        height: bodyHeight,
        color: textPrimary,
      );

  static TextStyle caption() => const TextStyle(
        fontFamily: fontFamily,
        fontSize: captionSize,
        fontWeight: captionWeight,
        color: textSecondary,
        letterSpacing: 0.1,
      );
}
