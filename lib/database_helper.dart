import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform, Directory;
import 'models.dart';
import 'feedback_model.dart';
import 'utils.dart';

/// Gère l'accès aux données locales avec support multi-plateforme (SQLite/IndexedDB).
/// 100% SANS FIREBASE.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  bool _isSimulationMode = false;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    try {
      _database = await _initDB('alerts_local_v7.db');
      return _database!;
    } catch (e) {
      debugPrint('⚠️ Erreur Database: $e. Tentative de repli...');
      
      try {
        if (kIsWeb) {
          debugPrint('🌐 Mode Web détecté, tentative in-memory...');
          _database = await databaseFactoryFfiWeb.openDatabase(inMemoryDatabasePath);
        } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          debugPrint('💻 Mode Desktop détecté, tentative de chemin local forcé...');
          final directory = await getApplicationSupportDirectory();
          final path = join(directory.path, 'alerts_fallback.db');
          _database = await databaseFactoryFfi.openDatabase(path);
        } else {
          _database = await openDatabase(inMemoryDatabasePath);
        }
        await _createDB(_database!, 7);
        return _database!;
      } catch (e2) {
        debugPrint('❌ Échec total: $e2. Mode simulation activé.');
        _isSimulationMode = true;
        rethrow;
      }
    }
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // Stockage persistant sur le Web via IndexedDB
      return await databaseFactoryFfiWeb.openDatabase(
        filePath,
        options: OpenDatabaseOptions(
          version: 7,
          onCreate: _createDB,
          onUpgrade: _onUpgrade,
        ),
      );
    }
    
    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      final directory = await getApplicationSupportDirectory();
      path = join(directory.path, filePath);
      if (!await Directory(directory.path).exists()) {
        await Directory(directory.path).create(recursive: true);
      }
      return await databaseFactoryFfi.openDatabase(path, options: OpenDatabaseOptions(
        version: 7,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      ));
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
      return await openDatabase(
        path, 
        version: 7, 
        onCreate: _createDB, 
        onUpgrade: _onUpgrade
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, phone TEXT NOT NULL UNIQUE, nom TEXT NOT NULL, prenom TEXT NOT NULL, national_card_number TEXT NOT NULL DEFAULT '', password_hash TEXT NOT NULL, role TEXT NOT NULL DEFAULT 'user', status TEXT NOT NULL DEFAULT 'active')''');
    await db.execute('''CREATE TABLE security_questions (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, question TEXT NOT NULL, answer_hash TEXT NOT NULL)''');
    await db.execute('''CREATE TABLE alerts (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, type TEXT NOT NULL, description TEXT NOT NULL, latitude REAL NOT NULL, longitude REAL NOT NULL, accuracy REAL NOT NULL, status TEXT NOT NULL DEFAULT 'pending', created_at TEXT NOT NULL, synced INTEGER NOT NULL DEFAULT 0)''');
    await db.execute('''CREATE TABLE alert_photos (id INTEGER PRIMARY KEY AUTOINCREMENT, alert_id INTEGER NOT NULL, photo_path TEXT NOT NULL)''');
    await db.execute('''CREATE TABLE alert_files (id INTEGER PRIMARY KEY AUTOINCREMENT, alert_id INTEGER NOT NULL, file_path TEXT NOT NULL, file_name TEXT NOT NULL)''');
    await db.execute('''CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT, alert_id INTEGER NOT NULL, sender_role TEXT NOT NULL, message TEXT NOT NULL, created_at TEXT NOT NULL, synced INTEGER NOT NULL DEFAULT 0)''');
    await db.execute('''CREATE TABLE feedbacks (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, message TEXT NOT NULL, rating INTEGER, status TEXT NOT NULL DEFAULT 'pending', admin_reply TEXT, created_at TEXT NOT NULL, replied_at TEXT)''');
    await db.execute('''CREATE TABLE system_notifications (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, title TEXT NOT NULL, message TEXT NOT NULL, type TEXT NOT NULL DEFAULT 'info', created_at TEXT NOT NULL, is_read INTEGER NOT NULL DEFAULT 0)''');
    
    // Compte Admin par défaut
    await db.insert('users', {
      'phone': 'admin', 'nom': 'Admin', 'prenom': 'System', 'national_card_number': '000',
      'password_hash': Utils.hashPassword('admin123'), 'role': 'admin', 'status': 'active',
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // --- MÉTHODES UTILISATEURS ---

  Future<User?> searchUserByIdentifier(String identifier) async {
    if (_isSimulationMode) return null;
    final db = await database;
    final term = identifier.trim().toLowerCase();
    final phoneMaps = await db.query('users', where: 'phone = ?', whereArgs: [identifier.trim()]);
    if (phoneMaps.isNotEmpty) return User.fromMap(phoneMaps.first);
    final nameMaps = await db.query('users', where: 'LOWER(nom) LIKE ? OR LOWER(prenom) LIKE ?', whereArgs: ['%$term%', '%$term%']);
    if (nameMaps.isNotEmpty) return User.fromMap(nameMaps.first);
    return null;
  }

  Future<User?> getUserByPhone(String phone) async {
    if (_isSimulationMode) return null;
    final db = await database;
    final maps = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
    return maps.isNotEmpty ? User.fromMap(maps.first) : null;
  }

  Future<User?> getUserById(int id) async {
    if (_isSimulationMode) return null;
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? User.fromMap(maps.first) : null;
  }

  Future<int> createUser(User user) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateUserStatus(int userId, String status) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.update('users', {'status': status}, where: 'id = ?', whereArgs: [userId]);
  }

  Future<int> updateUserPassword(int userId, String newHash) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.update('users', {'password_hash': newHash}, where: 'id = ?', whereArgs: [userId]);
  }

  Future<List<User>> getAllUsers() async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('users', where: 'role = ?', whereArgs: ['user']);
    return maps.map((m) => User.fromMap(m)).toList();
  }

  // --- QUESTIONS DE SÉCURITÉ ---

  Future<int> createSecurityQuestion(SecurityQuestion q) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('security_questions', q.toMap());
  }

  Future<List<SecurityQuestion>> getSecurityQuestionsByUserId(int userId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('security_questions', where: 'user_id = ?', whereArgs: [userId]);
    return maps.map((m) => SecurityQuestion.fromMap(m)).toList();
  }

  // --- MÉTHODES ALERTES ---

  Future<int> createAlert(Alert alert) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('alerts', alert.toMap());
  }

  Future<int> updateAlertStatus(int alertId, String status) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.update('alerts', {'status': status}, where: 'id = ?', whereArgs: [alertId]);
  }

  Future<List<Alert>> getAlertsByUserId(int userId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('alerts', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return maps.map((m) => Alert.fromMap(m)).toList();
  }

  Future<List<Alert>> getAllAlerts() async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('alerts', orderBy: 'created_at DESC');
    return maps.map((m) => Alert.fromMap(m)).toList();
  }

  Future<List<Alert>> getAlertsByFilter({String? status}) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('alerts', 
      where: status != null ? 'status = ?' : null, 
      whereArgs: status != null ? [status] : null, 
      orderBy: 'created_at DESC'
    );
    return maps.map((m) => Alert.fromMap(m)).toList();
  }

  Future<int> getUserAlertsCount(int userId) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM alerts WHERE user_id = ?', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<AlertWithDetails?> getAlertWithDetails(int alertId) async {
    if (_isSimulationMode) return null;
    final db = await database;
    final alertMap = await db.query('alerts', where: 'id = ?', whereArgs: [alertId]);
    if (alertMap.isEmpty) return null;
    final alert = Alert.fromMap(alertMap.first);
    final user = await getUserById(alert.userId);
    if (user == null) return null;
    final photos = await getPhotosByAlertId(alertId);
    final files = await getFilesByAlertId(alertId);
    final messageCount = await getMessageCountByAlertId(alertId);
    return AlertWithDetails(alert: alert, user: user, photos: photos, files: files, messageCount: messageCount);
  }

  // --- PHOTOS ET FICHIERS ---

  Future<int> createAlertPhoto(AlertPhoto photo) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('alert_photos', photo.toMap());
  }

  Future<List<AlertPhoto>> getPhotosByAlertId(int alertId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('alert_photos', where: 'alert_id = ?', whereArgs: [alertId]);
    return maps.map((m) => AlertPhoto.fromMap(m)).toList();
  }

  Future<int> createAlertFile(AlertFile file) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('alert_files', file.toMap());
  }

  Future<List<AlertFile>> getFilesByAlertId(int alertId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('alert_files', where: 'alert_id = ?', whereArgs: [alertId]);
    return maps.map((m) => AlertFile.fromMap(m)).toList();
  }

  // --- MESSAGES ET DISCUSSIONS ---

  Future<int> createMessage(Message message) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessagesByAlertId(int alertId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('messages', where: 'alert_id = ?', whereArgs: [alertId], orderBy: 'created_at ASC');
    return maps.map((m) => Message.fromMap(m)).toList();
  }

  Future<int> getMessageCountByAlertId(int alertId) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM messages WHERE alert_id = ?', [alertId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // --- FEEDBACKS ---

  Future<int> createFeedback(UserFeedback feedback) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('feedbacks', feedback.toMap());
  }

  Future<List<UserFeedback>> getFeedbacksByUserId(int userId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('feedbacks', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return maps.map((m) => UserFeedback.fromMap(m)).toList();
  }

  Future<List<UserFeedback>> getAllFeedbacks() async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('feedbacks', orderBy: 'created_at DESC');
    return maps.map((m) => UserFeedback.fromMap(m)).toList();
  }

  Future<int> updateFeedbackStatus(int id, String status) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.update('feedbacks', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> replyToFeedback(int id, String reply) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.update('feedbacks', {
      'admin_reply': reply,
      'replied_at': DateTime.now().toIso8601String(),
      'status': 'replied'
    }, where: 'id = ?', whereArgs: [id]);
  }

  // --- NOTIFICATIONS SYSTÈME ---

  Future<int> createSystemNotification(SystemNotification notification) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.insert('system_notifications', notification.toMap());
  }

  Future<List<SystemNotification>> getNotificationsByUserId(int userId) async {
    if (_isSimulationMode) return [];
    final db = await database;
    final maps = await db.query('system_notifications', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return maps.map((m) => SystemNotification.fromMap(m)).toList();
  }

  Future<int> markNotificationAsRead(int id) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    return await db.update('system_notifications', {'is_read': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getUnreadNotificationsCount(int userId) async {
    if (_isSimulationMode) return 0;
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM system_notifications WHERE user_id = ? AND is_read = 0', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
