import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'app_theme.dart';
import 'semantic_colors.dart';

/// 🎨 EXTENSIONS CONTEXT - Helpers pour accéder facilement aux ressources
///
/// Ces extensions simplifient l'accès aux :
/// - SemanticColors (Design Tokens)
/// - Traductions (i18n)
/// - Espacements et radius
/// - Styles de texte
///
/// Usage:
/// ```dart
/// // Au lieu de :
/// Theme.of(context).extension<SemanticColorsExtension>()!.colors.brand
///
/// // Utilisez :
/// context.colors.brand
/// ```

extension BuildContextExtensions on BuildContext {
  // ============================================
  // 🎨 SEMANTIC COLORS (Design Tokens)
  // ============================================

  /// Accès direct aux couleurs sémantiques
  ///
  /// Example:
  /// ```dart
  /// Container(
  ///   color: context.colors.surface,
  ///   child: Text(
  ///     'Hello',
  ///     style: TextStyle(color: context.colors.textPrimary),
  ///   ),
  /// )
  /// ```
  SemanticColors get colors {
    return Theme.of(this).extension<SemanticColorsExtension>()!.colors;
  }

  // ============================================
  // 🌓 MODE CLAIR/SOMBRE
  // ============================================

  /// Vérifie si le mode sombre est activé
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Vérifie si le mode clair est activé
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // ============================================
  // 🌍 LOCALISATION (i18n)
  // ============================================

  /// Accès aux traductions
  ///
  /// Example:
  /// ```dart
  /// Text(context.l10n.appTitle)
  /// Text(context.l10n.login)
  /// ```
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Vérifie si la langue actuelle est l'arabe
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  // ============================================
  // 📐 ESPACEMENTS (Spacing)
  // ============================================

  double get spacingXS => 4.0;
  double get spacingSM => 8.0;
  double get spacingMD => 16.0;
  double get spacingLG => 24.0;
  double get spacingXL => 32.0;
  double get spacingXXL => 48.0;

  // ============================================
  // 📏 BORDER RADIUS
  // ============================================

  BorderRadius get radiusXS => BorderRadius.circular(4.0);
  BorderRadius get radiusSM => BorderRadius.circular(8.0);
  BorderRadius get radiusMD => BorderRadius.circular(12.0);
  BorderRadius get radiusLG => BorderRadius.circular(16.0);
  BorderRadius get radiusXL => BorderRadius.circular(24.0);
  BorderRadius get radiusFull => BorderRadius.circular(999.0);

  // ============================================
  // ✍️ TEXT STYLES
  // ============================================

  TextTheme get textStyles => Theme.of(this).textTheme;

  // Titres
  TextStyle? get displayLarge => textStyles.displayLarge;
  TextStyle? get displayMedium => textStyles.displayMedium;
  TextStyle? get displaySmall => textStyles.displaySmall;

  // Sous-titres
  TextStyle? get headlineLarge => textStyles.headlineLarge;
  TextStyle? get headlineMedium => textStyles.headlineMedium;
  TextStyle? get headlineSmall => textStyles.headlineSmall;

  // Titres de section
  TextStyle? get titleLarge => textStyles.titleLarge;
  TextStyle? get titleMedium => textStyles.titleMedium;
  TextStyle? get titleSmall => textStyles.titleSmall;

  // Corps de texte
  TextStyle? get bodyLarge => textStyles.bodyLarge;
  TextStyle? get bodyMedium => textStyles.bodyMedium;
  TextStyle? get bodySmall => textStyles.bodySmall;

  // Labels
  TextStyle? get labelLarge => textStyles.labelLarge;
  TextStyle? get labelMedium => textStyles.labelMedium;
  TextStyle? get labelSmall => textStyles.labelSmall;

  // ============================================
  // 📱 MEDIA QUERY
  // ============================================

  /// Taille de l'écran
  Size get screenSize => MediaQuery.of(this).size;

  /// Largeur de l'écran
  double get screenWidth => screenSize.width;

  /// Hauteur de l'écran
  double get screenHeight => screenSize.height;

  /// Padding du système (notch, navigation bar...)
  EdgeInsets get systemPadding => MediaQuery.of(this).padding;

  /// ViewInsets (keyboard...)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // ============================================
  // 📊 BREAKPOINTS RESPONSIVE
  // ============================================

  /// Écran mobile (< 600dp)
  bool get isMobile => screenWidth < 600;

  /// Écran tablette (600-1200dp)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Écran desktop (>= 1200dp)
  bool get isDesktop => screenWidth >= 1200;

  // ============================================
  // 🧭 NAVIGATION
  // ============================================

  /// Navigator raccourci
  NavigatorState get navigator => Navigator.of(this);

  /// Push une nouvelle route
  Future<T?> push<T>(Widget screen) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Pop la route actuelle
  void pop<T>([T? result]) {
    navigator.pop(result);
  }

  /// Replace la route actuelle
  Future<T?> pushReplacement<T, TO>(Widget screen) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Pop jusqu'à la première route
  void popUntilFirst() {
    navigator.popUntil((route) => route.isFirst);
  }

  // ============================================
  // 💬 SNACKBAR
  // ============================================

  /// Afficher un SnackBar de succès
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Afficher un SnackBar d'erreur
  void showError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Afficher un SnackBar d'info
  void showInfo(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.info,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Afficher un SnackBar d'avertissement
  void showWarning(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.warning,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ============================================
  // ⌨️ KEYBOARD
  // ============================================

  /// Masquer le clavier
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Vérifier si le clavier est visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;
}

/// 🎨 EXTENSIONS COLOR - Helpers pour manipuler les couleurs

extension ColorExtensions on Color {
  /// Assombrir une couleur
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Éclaircir une couleur
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// Convertir en String hex (#RRGGBB)
  String toHex() {
    return '#${value.toRadixString(16).substring(2, 8).toUpperCase()}';
  }
}

/// ✍️ EXTENSIONS TEXT STYLE - Helpers pour manipuler les styles

extension TextStyleExtensions on TextStyle {
  /// Changer la couleur
  TextStyle colored(Color color) => copyWith(color: color);

  /// Mettre en gras
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Mettre en semi-gras
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Mettre en italique
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Changer la taille
  TextStyle sized(double size) => copyWith(fontSize: size);
}
