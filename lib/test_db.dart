import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> testDatabase() async {
  try {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'test.db');

    final db = await openDatabase(path, version: 1);
    print('✅ Base de données ouverte avec succès');
    await db.close();
  } catch (e) {
    print('❌ Erreur: $e');
  }
}