import 'package:flutter/material.dart';
import 'semantic_colors.dart';

/// 🌞 PALETTE LIGHT MODE - Thème Clair
///
/// Implémentation des Design Tokens pour le mode clair
/// Optimisé pour la lisibilité en plein jour
class LightColors {
  // ============================================
  // 🎨 PALETTE DE BASE
  // ============================================

  // Rouge Balagh Amen (Brand)
  static const Color _brandRed = Color(0xFFD32F2F);
  static const Color _brandRedLight = Color(0xFFE57373);
  static const Color _brandRedDark = Color(0xFFC62828);

  // Bleus
  static const Color _blue = Color(0xFF2196F3);
  static const Color _blueLight = Color(0xFF64B5F6);
  static const Color _blueDark = Color(0xFF1976D2);

  // Verts
  static const Color _green = Color(0xFF4CAF50);
  static const Color _greenLight = Color(0xFF81C784);
  static const Color _greenDark = Color(0xFF388E3C);

  // Oranges
  static const Color _orange = Color(0xFFFF9800);
  static const Color _orangeLight = Color(0xFFFFB74D);
  static const Color _orangeDark = Color(0xFFF57C00);

  // Neutres
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);
  static const Color _grey50 = Color(0xFFFAFAFA);
  static const Color _grey100 = Color(0xFFF5F5F5);
  static const Color _grey200 = Color(0xFFEEEEEE);
  static const Color _grey300 = Color(0xFFE0E0E0);
  static const Color _grey400 = Color(0xFFBDBDBD);
  static const Color _grey500 = Color(0xFF9E9E9E);
  static const Color _grey600 = Color(0xFF757575);
  static const Color _grey700 = Color(0xFF616161);
  static const Color _grey800 = Color(0xFF424242);
  static const Color _grey900 = Color(0xFF212121);

  // ============================================
  // 🎯 SEMANTIC COLORS (Design Tokens)
  // ============================================

  static const SemanticColors semanticColors = SemanticColors(
    // Brand
    brand: _brandRed,
    brandLight: _brandRedLight,
    brandDark: _brandRedDark,

    // Status
    statusPending: _orange,
    statusInProgress: _blue,
    statusResolved: _green,

    // Feedback
    success: _green,
    warning: _orange,
    error: _brandRed,
    info: _blue,

    // Surfaces - OPTIMISÉ POUR LISIBILITÉ LIGHT MODE
    background: _grey50,        // Fond très légèrement gris (repose les yeux)
    surface: _white,            // Cartes blanches (contraste maximal)
    surfaceVariant: _grey100,   // Cartes légèrement grises
    surfaceContainer: _grey200, // Conteneurs interactifs

    // Text - CONTRASTE MAXIMUM POUR LIGHT MODE
    textPrimary: _grey900,      // Noir profond (excellent contraste)
    textSecondary: _grey600,    // Gris moyen (lisible mais discret)
    textDisabled: _grey400,     // Gris clair (désactivé)
    textOnColor: _white,        // Blanc sur couleurs (brand, success...)

    // Borders
    border: _grey300,           // Bordure légère
    borderStrong: _grey500,     // Bordure accentuée
    divider: _grey200,          // Séparateurs

    // Overlays
    overlayDark: Color(0x77000000),  // 47% opacité
    overlayLight: Color(0x33000000), // 20% opacité

    // Balagh Amen specific
    adminRole: Color(0xFFB71C1C),    // Rouge admin foncé
    userRole: _blueDark,             // Bleu utilisateur
    unreadBadge: _brandRed,          // Badge rouge

    // GPS Accuracy
    gpsExcellent: _green,
    gpsGood: _greenLight,
    gpsAverage: _orange,
    gpsPoor: _brandRed,
  );

  // ============================================
  // 📐 ESPACEMENTS (Design Tokens)
  // ============================================

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ============================================
  // 📏 BORDER RADIUS (Design Tokens)
  // ============================================

  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // ============================================
  // 🌑 SHADOWS (Élévations)
  // ============================================

  static List<BoxShadow> get shadowLight => [
    BoxShadow(
      color: _black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: _black.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowHeavy => [
    BoxShadow(
      color: _black.withOpacity(0.16),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}