import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'light_colors.dart';
import 'dark_colors.dart';
import 'semantic_colors.dart';

/// 🎨 APP THEME - Configuration Globale des Thèmes
///
/// Architecture Professionnelle :
/// 1. Définit les thèmes Light et Dark
/// 2. Utilise les Design Tokens (pas de couleurs en dur)
/// 3. Extension Flutter ThemeData avec nos SemanticColors
/// 4. Configuration complète : textes, boutons, inputs, cards...
///
/// Utilisé par : MyApp dans main.dart
class AppTheme {
  // ============================================
  // 🌞 LIGHT THEME
  // ============================================

  static ThemeData get lightTheme {
    final colors = LightColors.semanticColors;

    return ThemeData(
      // ========== CONFIGURATION DE BASE ==========
      useMaterial3: true,
      brightness: Brightness.light,

      // ========== COLOR SCHEME ==========
      colorScheme: ColorScheme.light(
        primary: colors.brand,
        onPrimary: colors.textOnColor,
        primaryContainer: colors.brandLight,
        onPrimaryContainer: colors.brandDark,

        secondary: colors.info,
        onSecondary: colors.textOnColor,
        secondaryContainer: colors.info.withOpacity(0.1),
        onSecondaryContainer: colors.info,

        tertiary: colors.success,
        onTertiary: colors.textOnColor,

        error: colors.error,
        onError: colors.textOnColor,
        errorContainer: colors.error.withOpacity(0.1),
        onErrorContainer: colors.error,

        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surfaceVariant,

        outline: colors.border,
        outlineVariant: colors.divider,

        shadow: Colors.black.withOpacity(0.1),
      ),

      // ========== SCAFFOLD ==========
      scaffoldBackgroundColor: colors.background,

      // ========== APP BAR ==========
      appBarTheme: AppBarTheme(
        backgroundColor: colors.brand,
        foregroundColor: colors.textOnColor,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: colors.textOnColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colors.textOnColor),
      ),

      // ========== CARD ==========
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusMD),
        ),
        margin: EdgeInsets.zero,
      ),

      // ========== TEXT THEME ==========
      textTheme: TextTheme(
        // Titres
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.textPrimary),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textPrimary),

        // Sous-titres
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colors.textPrimary),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colors.textPrimary),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),

        // Titres de section
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.textPrimary),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textPrimary),

        // Corps de texte
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: colors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: colors.textSecondary),

        // Labels
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textPrimary),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.textSecondary),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: colors.textDisabled),
      ),

      // ========== ELEVATED BUTTON ==========
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.textOnColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LightColors.radiusMD),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ========== TEXT BUTTON ==========
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.brand,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // ========== OUTLINED BUTTON ==========
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.brand,
          side: BorderSide(color: colors.brand, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LightColors.radiusMD),
          ),
        ),
      ),

      // ========== INPUT DECORATION ==========
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        // Bordure normale
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusMD),
          borderSide: BorderSide(color: colors.border, width: 1),
        ),

        // Bordure activée
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusMD),
          borderSide: BorderSide(color: colors.border, width: 1),
        ),

        // Bordure focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusMD),
          borderSide: BorderSide(color: colors.brand, width: 2),
        ),

        // Bordure erreur
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusMD),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),

        // Bordure erreur focus
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusMD),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),

        // Styles de texte
        labelStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
        hintStyle: TextStyle(color: colors.textDisabled, fontSize: 14),
        errorStyle: TextStyle(color: colors.error, fontSize: 12),

        // Icônes
        prefixIconColor: colors.textSecondary,
        suffixIconColor: colors.textSecondary,
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.brand,
        foregroundColor: colors.textOnColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusLG),
        ),
      ),

      // ========== BOTTOM NAVIGATION BAR ==========
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.brand,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),

      // ========== DIVIDER ==========
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),

      // ========== DIALOG ==========
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusLG),
        ),
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 14,
        ),
      ),

      // ========== SNACKBAR ==========
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: TextStyle(color: colors.textOnColor, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusSM),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ========== CHIP ==========
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceVariant,
        selectedColor: colors.brand.withOpacity(0.2),
        labelStyle: TextStyle(color: colors.textPrimary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LightColors.radiusFull),
        ),
      ),

      // ========== SWITCH ==========
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.brand;
          return colors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.brand.withOpacity(0.5);
          return colors.divider;
        }),
      ),

      // ========== EXTENSION PERSONNALISÉE ==========
      extensions: <ThemeExtension<dynamic>>[
        SemanticColorsExtension(colors: LightColors.semanticColors),
      ],
    );
  }

  // ============================================
  // 🌙 DARK THEME
  // ============================================

  static ThemeData get darkTheme {
    final colors = DarkColors.semanticColors;

    return ThemeData(
      // ========== CONFIGURATION DE BASE ==========
      useMaterial3: true,
      brightness: Brightness.dark,

      // ========== COLOR SCHEME ==========
      colorScheme: ColorScheme.dark(
        primary: colors.brand,
        onPrimary: colors.textOnColor,
        primaryContainer: colors.brandDark,
        onPrimaryContainer: colors.brandLight,

        secondary: colors.info,
        onSecondary: colors.textOnColor,
        secondaryContainer: colors.info.withOpacity(0.2),
        onSecondaryContainer: colors.info,

        tertiary: colors.success,
        onTertiary: colors.textOnColor,

        error: colors.error,
        onError: colors.textOnColor,
        errorContainer: colors.error.withOpacity(0.2),
        onErrorContainer: colors.error,

        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surfaceVariant,

        outline: colors.border,
        outlineVariant: colors.divider,

        shadow: Colors.black.withOpacity(0.3),
      ),

      // ========== SCAFFOLD ==========
      scaffoldBackgroundColor: colors.background,

      // ========== APP BAR ==========
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),

      // ========== CARD ==========
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusMD),
        ),
        margin: EdgeInsets.zero,
      ),

      // ========== TEXT THEME ==========
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.textPrimary),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textPrimary),

        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colors.textPrimary),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colors.textPrimary),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),

        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.textPrimary),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textPrimary),

        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: colors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: colors.textSecondary),

        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textPrimary),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.textSecondary),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: colors.textDisabled),
      ),

      // ========== ELEVATED BUTTON ==========
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.brand,
          foregroundColor: colors.textOnColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ========== TEXT BUTTON ==========
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.brand,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // ========== OUTLINED BUTTON ==========
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.brand,
          side: BorderSide(color: colors.brand, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          ),
        ),
      ),

      // ========== INPUT DECORATION ==========
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          borderSide: BorderSide(color: colors.border, width: 1),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          borderSide: BorderSide(color: colors.border, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          borderSide: BorderSide(color: colors.brand, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusMD),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),

        labelStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
        hintStyle: TextStyle(color: colors.textDisabled, fontSize: 14),
        errorStyle: TextStyle(color: colors.error, fontSize: 12),

        prefixIconColor: colors.textSecondary,
        suffixIconColor: colors.textSecondary,
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.brand,
        foregroundColor: colors.textOnColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusLG),
        ),
      ),

      // ========== BOTTOM NAVIGATION BAR ==========
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.brand,
        unselectedItemColor: colors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),

      // ========== DIVIDER ==========
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),

      // ========== DIALOG ==========
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusLG),
        ),
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 14,
        ),
      ),

      // ========== SNACKBAR ==========
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceVariant,
        contentTextStyle: TextStyle(color: colors.textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusSM),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ========== CHIP ==========
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceVariant,
        selectedColor: colors.brand.withOpacity(0.3),
        labelStyle: TextStyle(color: colors.textPrimary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DarkColors.radiusFull),
        ),
      ),

      // ========== SWITCH ==========
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.brand;
          return colors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.brand.withOpacity(0.5);
          return colors.divider;
        }),
      ),

      // ========== EXTENSION PERSONNALISÉE ==========
      extensions: <ThemeExtension<dynamic>>[
        SemanticColorsExtension(colors: DarkColors.semanticColors),
      ],
    );
  }
}

// ============================================
// 🎨 EXTENSION POUR ACCÉDER AUX SEMANTIC COLORS
// ============================================

/// Extension ThemeData pour accéder facilement aux SemanticColors
/// Usage: Theme.of(context).extension<SemanticColorsExtension>()!.colors
class SemanticColorsExtension extends ThemeExtension<SemanticColorsExtension> {
  final SemanticColors colors;

  const SemanticColorsExtension({required this.colors});

  @override
  SemanticColorsExtension copyWith({SemanticColors? colors}) {
    return SemanticColorsExtension(colors: colors ?? this.colors);
  }

  @override
  SemanticColorsExtension lerp(ThemeExtension<SemanticColorsExtension>? other, double t) {
    if (other is! SemanticColorsExtension) return this;
    return this; // Pour la simplicité, pas d'interpolation
  }
}
