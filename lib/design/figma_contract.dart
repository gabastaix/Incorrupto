import 'package:flutter/material.dart';

/// STEP 0: Figma Contract
/// Replace every TODO with the EXACT values from Figma (Inspect panel).
/// Once this is filled, we can build screens that match the prototype precisely.
class FigmaContract {
  // =========================
  // Colors (exact hex)
  // =========================
  static const Color bg = Color(0xFFFBF8F3); // TODO: background
  static const Color surface = Color(0xFFFFFFFF); // TODO
  static const Color primary = Color(0xFFC07A3A); // TODO
  static const Color textPrimary = Color(0xFF111111); // TODO
  static const Color textSecondary = Color(0xFF6E6E6E); // TODO
  static const Color border = Color(0xFFE9E5E0); // TODO
  static const Color danger = Color(0xFFB00020); // TODO (if used)
  static const Color success = Color(0xFF1E8E3E); // TODO (if used)

  // =========================
  // Typography (exact)
  // =========================
  // TODO: put the exact fontFamily name from Figma (e.g. "Inter", "Poppins")
  static const String fontFamily = 'TODO_FONT';

  // Font sizes should match Figma exactly (e.g. 12, 14, 16, 18, 24)
  static const double h1Size = 28; // TODO
  static const double h2Size = 20; // TODO
  static const double bodySize = 16; // TODO
  static const double captionSize = 12; // TODO

  // Font weights should match (e.g. w400, w500, w600, w700)
  static const FontWeight h1Weight = FontWeight.w700; // TODO
  static const FontWeight h2Weight = FontWeight.w600; // TODO
  static const FontWeight bodyWeight = FontWeight.w400; // TODO
  static const FontWeight captionWeight = FontWeight.w400; // TODO

  // Line heights: Flutter uses "height" as a multiplier (lineHeight / fontSize)
  static const double h1Height = 1.2; // TODO: (lineHeight / h1Size)
  static const double bodyHeight = 1.4; // TODO

  // =========================
  // Spacing & Radius (exact)
  // =========================
  static const double rSm = 12; // TODO
  static const double rMd = 16; // TODO
  static const double rLg = 24; // TODO

  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;

  // =========================
  // Shadows (if Figma uses them)
  // =========================
  static List<BoxShadow> cardShadow = const [
    // TODO: translate from Figma shadow (x, y, blur, spread, color+opacity)
    // BoxShadow(offset: Offset(0, 4), blurRadius: 12, spreadRadius: 0, color: Color(0x1A000000)),
  ];

  // =========================
  // Text styles derived from tokens
  // =========================
  static TextStyle h1() => const TextStyle(
        fontFamily: fontFamily,
        fontSize: h1Size,
        fontWeight: h1Weight,
        height: h1Height,
        color: textPrimary,
      );
      
  static TextStyle h2() => const TextStyle(
      fontFamily: fontFamily,
      fontSize: h2Size,
      fontWeight: h2Weight,
      color: textPrimary,
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
      );
}
