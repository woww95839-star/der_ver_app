import 'package:flutter/material.dart';
import 'semantic_colors.dart';

/// 🌙 PALETTE DARK MODE - Thème Sombre (Nouvelle Identité "Balagh Amen")
///
/// Implémentation des Design Tokens pour le mode sombre
/// Basée sur l'identité Indigo & Émeraude (adaptée)
class DarkColors {
  // ============================================
  // 🎨 PALETTE DE BASE
  // ============================================

  // Bleu Indigo (Brand - Plus lumineux pour le Dark Mode)
  static const Color _brandIndigo = Color(0xFF5C6BC0);
  static const Color _brandIndigoLight = Color(0xFF7986CB);
  static const Color _brandIndigoDark = Color(0xFF1A237E);

  // Vert Émeraude (Accent - Plus lumineux)
  static const Color _emeraldGreen = Color(0xFF66BB6A);
  static const Color _emeraldGreenLight = Color(0xFF81C784);

  // Bleus Info
  static const Color _blueInfo = Color(0xFF42A5F5);

  // Oranges Warning
  static const Color _orangeWarning = Color(0xFFFFB74D);

  // Rouges Error
  static const Color _redError = Color(0xFFEF5350);

  // Neutres - Tons sombres
  static const Color _black = Color(0xFF000000);
  static const Color _grey50 = Color(0xFF121212); // Background
  static const Color _grey100 = Color(0xFF1E1E1E); // Surface
  static const Color _grey200 = Color(0xFF2C2C2C); // Surface Variant
  static const Color _grey300 = Color(0xFF383838); // Container
  static const Color _grey400 = Color(0xFF4A4A4A); // Borders
  static const Color _grey500 = Color(0xFF757575); // Disabled
  static const Color _grey600 = Color(0xFF9E9E9E); // Text Secondary
  static const Color _grey700 = Color(0xFFBDBDBD); // Text Secondary High
  static const Color _grey800 = Color(0xFFE0E0E0); // Text Primary
  static const Color _grey900 = Color(0xFFFFFFFF); // Text Pure

  // ============================================
  // 🎯 SEMANTIC COLORS (Design Tokens)
  // ============================================

  static const SemanticColors semanticColors = SemanticColors(
    // Brand
    brand: _brandIndigo,
    brandLight: _brandIndigoLight,
    brandDark: _brandIndigoDark,

    // Status
    statusPending: _orangeWarning,
    statusInProgress: _blueInfo,
    statusResolved: _emeraldGreen,

    // Feedback
    success: _emeraldGreen,
    warning: _orangeWarning,
    error: _redError,
    info: _blueInfo,

    // Surfaces
    background: _grey50,
    surface: _grey100,
    surfaceVariant: _grey200,
    surfaceContainer: _grey300,

    // Text
    textPrimary: _grey800,
    textSecondary: _grey600,
    textDisabled: _grey500,
    textOnColor: _grey50,

    // Borders
    border: _grey400,
    borderStrong: _grey500,
    divider: _grey300,

    // Overlays
    overlayDark: Color(0xBB000000),
    overlayLight: Color(0x55FFFFFF),

    // Balagh Amen specific
    adminRole: _brandIndigoLight,
    userRole: _brandIndigo,
    unreadBadge: _redError,

    // GPS Accuracy
    gpsExcellent: _emeraldGreen,
    gpsGood: _emeraldGreenLight,
    gpsAverage: _orangeWarning,
    gpsPoor: _redError,
  );

  // ============================================
  // 📐 ESPACEMENTS & RADIUS
  // ============================================

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;
}
