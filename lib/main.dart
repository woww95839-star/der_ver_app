import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app.dart';
import 'database_helper.dart';
import 'language_provider.dart';
import 'notification_service.dart';
import 'theme_provider.dart';
import 'models.dart';
import 'utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Configuration multi-plateforme sans Firebase
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguagePreference();

  final themeProvider = ThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class AppInitializer {
  static bool isInitialized = false;
  static final ValueNotifier<String> loadingStep = ValueNotifier<String>('Démarrage...');

  static Future<void> initialize(BuildContext context) async {
    if (isInitialized) return;
    
    try {
      _updateStep('Configuration système...');
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      _updateStep('Initialisation base de données...');
      // Ouverture de la base locale
      final db = await DatabaseHelper.instance.database;

      // ✅ CRUCIAL : Vérifier/Créer l'admin par défaut pour éviter les crashs null
      _updateStep('Vérification sécurité...');
      final admin = await DatabaseHelper.instance.getUserByPhone('admin');
      if (admin == null) {
        await DatabaseHelper.instance.createUser(User(
          phone: 'admin',
          nom: 'Admin',
          prenom: 'System',
          nationalCardNumber: '000',
          passwordHash: Utils.hashPassword('admin123'),
          role: 'admin',
          status: 'active',
        ));
      }

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        _updateStep('Services de notification...');
        try {
          await NotificationService.instance.initialize();
        } catch (e) {
          debugPrint('⚠️ NotificationService indisponible');
        }
      }

      _updateStep('Prêt 🚀');
      await Future.delayed(const Duration(milliseconds: 500));
      isInitialized = true;
    } catch (e) {
      debugPrint('❌ Erreur Initializer: $e');
      _updateStep('Mode secours activé');
      isInitialized = true;
    }
  }

  static void _updateStep(String step) {
    loadingStep.value = step;
  }
}
