import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🌍 LANGUAGE PROVIDER - Gestion de la langue (Arabe/Anglais)
class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('ar'); // Arabe par défaut

  Locale get locale => _locale;

  /// Direction du texte (RTL pour arabe, LTR pour anglais)
  TextDirection get textDirection {
    return _locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Est en arabe?
  bool get isArabic => _locale.languageCode == 'ar';

  /// Est en anglais?
  bool get isEnglish => _locale.languageCode == 'en';

  /// Charger la langue sauvegardée
  Future<void> loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'ar';
      _locale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur chargement langue: $e');
    }
  }

  /// Sauvegarder la langue
  Future<void> _saveLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, _locale.languageCode);
    } catch (e) {
      debugPrint('❌ Erreur sauvegarde langue: $e');
    }
  }

  /// Changer la langue
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();
    await _saveLanguagePreference();
  }

  /// Basculer entre arabe et anglais
  Future<void> toggleLanguage() async {
    final newLocale = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }

  /// Activer l'arabe
  Future<void> setArabic() async {
    await setLocale(const Locale('ar'));
  }

  /// Activer l'anglais
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }
}