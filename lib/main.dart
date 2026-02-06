import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'app.dart';
import 'database_helper.dart';
import 'language_provider.dart';
import 'notification_service.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguagePreference();
  
  final themeProvider = ThemeProvider();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Activé uniquement en mode debug
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: languageProvider),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

// ============== INITIALISATION GLOBAL ==============

class AppInitializer {
  static bool isInitialized = false;
  static String currentStep = 'Démarrage...';
  static String? errorMessage;

  static Future<void> initialize(BuildContext context) async {
    if (isInitialized) return;

    try {
      _updateStep('Configuration...');
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      _updateStep('Initialisation Firebase...');
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAZ-QBEepfSxeOUc3ilbdo1W5QGQmvxF9U',
          appId: '1:502944480018:android:139e4d4ca8abef73f8d1cb',
          messagingSenderId: '502944480018',
          projectId: 'alerts-f5d7a',
          storageBucket: 'alerts-f5d7a.firebasestorage.app',
          databaseURL: 'https://alerts-f5d7a-default-rtdb.firebaseio.com',
        ),
      );

      _updateStep('Initialisation base de données...');
      if (!kIsWeb) { // ✅ NE PAS INITIALISER SQLITE SUR LE WEB
        await DatabaseHelper.instance.database;
      }

      _updateStep('Initialisation notifications...');
      if (!kIsWeb) { // ✅ Les notifications locales ne sont pas non plus supportées sur le web
          await NotificationService.instance.initialize();
      }

      _updateStep('Terminé !');
      await Future.delayed(const Duration(milliseconds: 500));

      isInitialized = true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('❌ Erreur d\'initialisation: $e');
    }
  }

  static void _updateStep(String step) {
    currentStep = step;
    debugPrint('📍 $step');
  }
}
