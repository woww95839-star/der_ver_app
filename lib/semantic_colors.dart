import 'package:flutter/material.dart';

/// 🎨 DESIGN TOKENS - Couleurs Sémantiques
///
/// Ce fichier définit les RÔLES des couleurs, pas les couleurs elles-mêmes.
/// Chaque rôle a une signification métier claire.
///
/// Architecture utilisée par : Google, Airbnb, Uber, Netflix
class SemanticColors {
  // ============================================
  // 🎯 COULEURS MÉTIER (Business Colors)
  // ============================================

  /// Couleur principale de la marque Balagh Amen
  final Color brand;

  /// Variante plus claire de la couleur principale
  final Color brandLight;

  /// Variante plus sombre de la couleur principale
  final Color brandDark;

  // ============================================
  // 📋 ÉTATS DES ALERTES (Alert Status)
  // ============================================

  /// Alerte en attente
  final Color statusPending;

  /// Alerte en cours de traitement
  final Color statusInProgress;

  /// Alerte résolue
  final Color statusResolved;

  // ============================================
  // 💬 FEEDBACK UTILISATEUR (User Feedback)
  // ============================================

  /// Succès, validation, confirmation
  final Color success;

  /// Avertissement, attention
  final Color warning;

  /// Erreur, danger, échec
  final Color error;

  /// Information, aide
  final Color info;

  // ============================================
  // 🎨 SURFACES (Backgrounds)
  // ============================================

  /// Fond principal de l'application
  final Color background;

  /// Fond des cartes, conteneurs élevés
  final Color surface;

  /// Fond des cartes légèrement élevées
  final Color surfaceVariant;

  /// Fond des conteneurs interactifs (hover, pressed)
  final Color surfaceContainer;

  // ============================================
  // ✍️ TEXTES (Text Colors)
  // ============================================

  /// Texte principal, titres
  final Color textPrimary;

  /// Texte secondaire, descriptions
  final Color textSecondary;

  /// Texte désactivé, placeholders
  final Color textDisabled;

  /// Texte sur surfaces colorées (brand, success, error...)
  final Color textOnColor;

  // ============================================
  // 🔲 BORDURES ET DIVIDERS
  // ============================================

  /// Bordures légères
  final Color border;

  /// Bordures accentuées
  final Color borderStrong;

  /// Séparateurs, dividers
  final Color divider;

  // ============================================
  // 🌑 OVERLAYS (Couches semi-transparentes)
  // ============================================

  /// Overlay sombre (modals, dialogs)
  final Color overlayDark;

  /// Overlay clair
  final Color overlayLight;

  // ============================================
  // 🎭 RÔLES SPÉCIFIQUES BALAGH AMEN
  // ============================================

  /// Couleur admin (rouge plus foncé)
  final Color adminRole;

  /// Couleur utilisateur (bleu)
  final Color userRole;

  /// Indicateur de messages non lus
  final Color unreadBadge;

  /// Précision GPS excellente
  final Color gpsExcellent;

  /// Précision GPS bonne
  final Color gpsGood;

  /// Précision GPS moyenne
  final Color gpsAverage;

  /// Précision GPS faible
  final Color gpsPoor;

  const SemanticColors({
    // Brand
    required this.brand,
    required this.brandLight,
    required this.brandDark,

    // Status
    required this.statusPending,
    required this.statusInProgress,
    required this.statusResolved,

    // Feedback
    required this.success,
    required this.warning,
    required this.error,
    required this.info,

    // Surfaces
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceContainer,

    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnColor,

    // Borders
    required this.border,
    required this.borderStrong,
    required this.divider,

    // Overlays
    required this.overlayDark,
    required this.overlayLight,

    // Balagh Amen specific
    required this.adminRole,
    required this.userRole,
    required this.unreadBadge,
    required this.gpsExcellent,
    required this.gpsGood,
    required this.gpsAverage,
    required this.gpsPoor,
  });
}