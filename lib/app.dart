import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'app_theme.dart';
import 'theme_provider.dart';
import 'language_provider.dart';
import 'login_screen.dart';
import 'main.dart'; // Pour AppInitializer

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          // Intégration de DevicePreview
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          title: 'بلاغ آمن - Balagh Amen',
          debugShowCheckedModeBanner: false,

          // Localisation
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          // locale: languageProvider.locale, // Géré par DevicePreview maintenant

          // Thème
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // Écran de chargement unifié
          home: const GlobalLoader(),
        );
      },
    );
  }
}

class GlobalLoader extends StatefulWidget {
  const GlobalLoader({super.key});

  @override
  State<GlobalLoader> createState() => _GlobalLoaderState();
}

class _GlobalLoaderState extends State<GlobalLoader> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AppInitializer.initialize(context);
    if (mounted) {
      if (AppInitializer.errorMessage == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(() {}); // Pour afficher l'erreur
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppInitializer.errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 80, color: Colors.white),
                const SizedBox(height: 24),
                const Text('Erreur', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(AppInitializer.errorMessage!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    AppInitializer.errorMessage = null;
                    AppInitializer.isInitialized = false;
                    _init();
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.notifications_active, size: 80, color: Color(0xFFD32F2F)),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            const SizedBox(height: 24),
            Text(AppInitializer.currentStep, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
