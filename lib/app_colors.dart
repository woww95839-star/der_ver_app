import 'package:flutter/material.dart';

/// Palette de couleurs centralisée pour l'application Balagh Amen
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ========== COULEURS PRINCIPALES ==========

  /// Couleur primaire (Rouge pour Balagh Amen)
  static const Color primary = Color(0xFFD32F2F);
  static const Color primaryLight = Color(0xFFE57373);
  static const Color primaryDark = Color(0xFFC62828);

  /// Couleur secondaire
  static const Color secondary = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF42A5F5);
  static const Color secondaryDark = Color(0xFF1565C0);

  /// Couleur d'accent
  static const Color accent = Color(0xFFFF9800);

  // ========== COULEURS D'ÉTAT ==========

  /// Succès (vert)
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  /// Avertissement (orange)
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  /// Erreur (rouge)
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  /// Information (bleu)
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // ========== STATUTS DES ALERTES ==========

  /// En attente
  static const Color statusPending = Color(0xFFFF9800);

  /// En cours
  static const Color statusInProgress = Color(0xFF2196F3);

  /// Résolu
  static const Color statusResolved = Color(0xFF4CAF50);

  // ========== THÈME CLAIR ==========

  /// Couleurs de fond - Thème clair
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  /// Couleurs de texte - Thème clair
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextDisabled = Color(0xFFBDBDBD);

  /// Couleurs de bordure - Thème clair
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // ========== THÈME SOMBRE ==========

  /// Couleurs de fond - Thème sombre
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  /// Couleurs de texte - Thème sombre
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextDisabled = Color(0xFF666666);

  /// Couleurs de bordure - Thème sombre
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkBorder = Color(0xFF3A3A3A);

  // ========== COULEURS NEUTRES ==========

  /// Blanc
  static const Color white = Color(0xFFFFFFFF);

  /// Noir
  static const Color black = Color(0xFF000000);

  /// Gris
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ========== COULEURS TRANSPARENTES ==========

  /// Overlay sombre
  static const Color overlayDark = Color(0x77000000);

  /// Overlay clair
  static const Color overlayLight = Color(0x33000000);

  // ========== GRADIENTS ==========

  /// Gradient primaire
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient secondaire
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient de succès
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========== SHADOWS ==========

  /// Ombre légère
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Ombre moyenne
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: black.withOpacity(0.15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Ombre forte
  static List<BoxShadow> get heavyShadow => [
    BoxShadow(
      color: black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}