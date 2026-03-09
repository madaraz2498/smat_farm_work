import 'package:flutter/material.dart';

/// Single source of truth for every colour used in Smart Farm AI.
/// Never write a raw Color(0xFF...) inside a widget — reference this class.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────

  /// Primary green — buttons, active sidebar item, logo bg, icon tint.
  /// Source: Color(0xFF4CAF50) throughout the original code.
  static const Color primary = Color(0xFF4CAF50);

  /// 10 % tinted primary — feature-card icon container background.
  /// Source: Color(0xFF4CAF50).withOpacity(0.1)  →  0x1A ≈ 10 %
  static const Color primaryLight = Color(0x1A4CAF50);

  // ── Backgrounds ────────────────────────────────────────────────────────────

  /// Page / Scaffold background.
  /// Source: Color(0xFFFAFBF7)
  static const Color background = Color(0xFFFAFBF7);

  /// Card, AppBar, Sidebar surface colour.
  static const Color surface = Color(0xFFFFFFFF);

  /// Input field fill colour.
  /// Source: Color(0xFFF9FAFB)
  static const Color inputFill = Color(0xFFF9FAFB);

  // ── Text ───────────────────────────────────────────────────────────────────

  /// Primary text — headings, body, labels.
  /// Source: Color(0xFF1F2937)
  static const Color textPrimary = Color(0xFF1F2937);

  /// Secondary / muted text — subtitles, helper copy, nav unselected.
  /// Source: Color(0xFF6B7280)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Hint / placeholder — 50 % opacity over textPrimary.
  /// Source: Color(0xFF1F2937).withOpacity(0.5)  →  0x80 = 50 %
  static const Color textHint = Color(0x801F2937);

  // ── Borders ────────────────────────────────────────────────────────────────

  /// Default border colour.
  /// Source: Colors.black.withOpacity(0.08)  →  0x14 ≈ 8 %
  static const Color border = Color(0x14000000);

  // ── Shadows ────────────────────────────────────────────────────────────────

  /// Standard drop-shadow colour.
  /// Source: Colors.black.withOpacity(0.1)  →  0x1A ≈ 10 %
  static const Color shadow = Color(0x1A000000);

  // ── Semantic ───────────────────────────────────────────────────────────────

  /// Notification / error indicator dot.
  /// Source: Color(0xFFFB2C36)
  static const Color danger = Color(0xFFFB2C36);
}
