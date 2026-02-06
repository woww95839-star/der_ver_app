import 'package:flutter/material.dart';
import 'semantic_colors.dart';

/// 🌙 PALETTE DARK MODE - Thème Sombre
///
/// Implémentation des Design Tokens pour le mode sombre
/// Optimisé pour réduire la fatigue oculaire en environnement sombre
/// Suit les guidelines Material Design 3 pour le dark mode
class DarkColors {
  // ============================================
  // 🎨 PALETTE DE BASE
  // ============================================

  // Rouge Balagh Amen (Brand) - Plus clair en dark mode
  static const Color _brandRed = Color(0xFFEF5350);
  static const Color _brandRedLight = Color(0xFFE57373);
  static const Color _brandRedDark = Color(0xFFD32F2F);

  // Bleus - Plus clairs en dark mode
  static const Color _blue = Color(0xFF42A5F5);
  static const Color _blueLight = Color(0xFF64B5F6);
  static const Color _blueDark = Color(0xFF2196F3);

  // Verts - Plus clairs en dark mode
  static const Color _green = Color(0xFF66BB6A);
  static const Color _greenLight = Color(0xFF81C784);
  static const Color _greenDark = Color(0xFF4CAF50);

  // Oranges - Plus clairs en dark mode
  static const Color _orange = Color(0xFFFFB74D);
  static const Color _orangeLight = Color(0xFFFFCC80);
  static const Color _orangeDark = Color(0xFFFF9800);

  // Neutres - Tons sombres
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);
  static const Color _grey50 = Color(0xFF0A0A0A);
  static const Color _grey100 = Color(0xFF121212);
  static const Color _grey200 = Color(0xFF1E1E1E);
  static const Color _grey300 = Color(0xFF2C2C2C);
  static const Color _grey400 = Color(0xFF3A3A3A);
  static const Color _grey500 = Color(0xFF666666);
  static const Color _grey600 = Color(0xFF999999);
  static const Color _grey700 = Color(0xFFB3B3B3);
  static const Color _grey800 = Color(0xFFCCCCCC);
  static const Color _grey900 = Color(0xFFE0E0E0);

  // ============================================
  // 🎯 SEMANTIC COLORS (Design Tokens)
  // ============================================

  static const SemanticColors semanticColors = SemanticColors(
    // Brand - Plus clair en dark mode pour visibilité
    brand: _brandRed,
    brandLight: _brandRedLight,
    brandDark: _brandRedDark,

    // Status - Couleurs plus lumineuses
    statusPending: _orange,
    statusInProgress: _blue,
    statusResolved: _green,

    // Feedback - Couleurs adaptées au fond sombre
    success: _green,
    warning: _orange,
    error: _brandRed,
    info: _blue,

    // Surfaces - OPTIMISÉ POUR DARK MODE (pas de noir pur)
    background: _grey100,       // Gris très sombre (meilleur que noir pur)
    surface: _grey200,          // Cartes légèrement plus claires
    surfaceVariant: _grey300,   // Cartes élevées
    surfaceContainer: _grey400, // Conteneurs interactifs

    // Text - INVERSÉ PAR RAPPORT AU LIGHT MODE
    textPrimary: _grey900,      // Blanc cassé (pas de blanc pur = moins fatiguant)
    textSecondary: _grey700,    // Gris clair
    textDisabled: _grey500,     // Gris moyen
    textOnColor: _grey100,      // Sombre sur couleurs claires

    // Borders - Plus clairs en dark mode
    border: _grey400,           // Bordure visible mais discrète
    borderStrong: _grey600,     // Bordure accentuée
    divider: _grey300,          // Séparateurs

    // Overlays
    overlayDark: Color(0xBB000000),  // 73% opacité (plus opaque en dark)
    overlayLight: Color(0x55FFFFFF), // 33% opacité blanche

    // Balagh Amen specific
    adminRole: Color(0xFFEF5350),    // Rouge admin lumineux
    userRole: _blue,                 // Bleu utilisateur
    unreadBadge: _brandRed,          // Badge rouge

    // GPS Accuracy - Couleurs lumineuses
    gpsExcellent: _green,
    gpsGood: _greenLight,
    gpsAverage: _orange,
    gpsPoor: _brandRed,
  );

  // ============================================
  // 📐 ESPACEMENTS (Identiques au Light Mode)
  // ============================================

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ============================================
  // 📏 BORDER RADIUS (Identiques au Light Mode)
  // ============================================

  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // ============================================
  // 🌑 SHADOWS (Plus subtiles en dark mode)
  // ============================================

  static List<BoxShadow> get shadowLight => [
    BoxShadow(
      color: _black.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: _black.withOpacity(0.4),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowHeavy => [
    BoxShadow(
      color: _black.withOpacity(0.5),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}