import 'package:flutter/material.dart';
import 'semantic_colors.dart';

/// 🌞 PALETTE LIGHT MODE - Thème Clair (Nouvelle Identité "Balagh Amen")
///
/// Implémentation des Design Tokens pour le mode clair
/// Basée sur l'identité Indigo & Émeraude
class LightColors {
  // ============================================
  // 🎨 PALETTE DE BASE
  // ============================================

  // Bleu Indigo (Brand - Confiance et Autorité)
  static const Color _brandIndigo = Color(0xFF1A237E);
  static const Color _brandIndigoLight = Color(0xFF3949AB);
  static const Color _brandIndigoDark = Color(0xFF0D1440);

  // Vert Émeraude (Accent - Identité Nationale et Sécurité)
  static const Color _emeraldGreen = Color(0xFF006233);
  static const Color _emeraldGreenLight = Color(0xFF2E7D32);

  // Bleus Info
  static const Color _blueInfo = Color(0xFF1976D2);

  // Oranges Warning
  static const Color _orangeWarning = Color(0xFFF57C00);

  // Rouges Error
  static const Color _redError = Color(0xFFD32F2F);

  // Neutres
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);
  static const Color _grey50 = Color(0xFFF8F9FA);
  static const Color _grey100 = Color(0xFFF1F3F5);
  static const Color _grey200 = Color(0xFFE9ECEF);
  static const Color _grey300 = Color(0xFFDEE2E6);
  static const Color _grey400 = Color(0xFFCED4DA);
  static const Color _grey500 = Color(0xFFADB5BD);
  static const Color _grey600 = Color(0xFF6C757D);
  static const Color _grey700 = Color(0xFF495057);
  static const Color _grey800 = Color(0xFF343A40);
  static const Color _grey900 = Color(0xFF212529);

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
    surface: _white,
    surfaceVariant: _grey100,
    surfaceContainer: _grey200,

    // Text
    textPrimary: _grey900,
    textSecondary: _grey700,
    textDisabled: _grey500,
    textOnColor: _white,

    // Borders
    border: _grey300,
    borderStrong: _grey500,
    divider: _grey200,

    // Overlays
    overlayDark: Color(0x77000000),
    overlayLight: Color(0x33000000),

    // Balagh Amen specific
    adminRole: _brandIndigoDark,
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
