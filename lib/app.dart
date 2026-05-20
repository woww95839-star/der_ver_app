import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'theme_provider.dart';
import 'language_provider.dart';
import 'splash_screen.dart';
import 'app_theme.dart'; // ✅ Import de AppTheme

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Balagh Amen',
      
      // Thème
      theme: AppTheme.lightTheme, // ✅ Utilisation directe de AppTheme
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      
      // Localisation
      locale: languageProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // ✅ Utilisation du SplashScreen comme point d'entrée
      home: const SplashScreen(),
    );
  }
}
