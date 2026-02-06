import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'models.dart';
import 'feedback_model.dart';
import 'utils.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('alerts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    debugPrint('📂 Chemin de la base de données: $path');

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final result = await db.rawQuery('PRAGMA table_info(users)');
      final columns = result.map((col) => col['name'] as String).toList();

      if (!columns.contains('national_card_number')) {
        await db.execute('ALTER TABLE users ADD COLUMN national_card_number TEXT DEFAULT ""');
      }
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS feedbacks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          message TEXT NOT NULL,
          status TEXT NOT NULL DEFAULT 'pending',
          admin_reply TEXT,
          created_at TEXT NOT NULL,
          replied_at TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 4) {
      // Vérifier si la table existe d'abord
      final tableCheck = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='feedbacks'");

      if (tableCheck.isEmpty) {
        // Si la table n'existe pas du tout, on la crée directement avec rating
        await db.execute('''
          CREATE TABLE feedbacks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            message TEXT NOT NULL,
            rating INTEGER,
            status TEXT NOT NULL DEFAULT 'pending',
            admin_reply TEXT,
            created_at TEXT NOT NULL,
            replied_at TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      } else {
        // Si elle existe, on vérifie la colonne rating
        final result = await db.rawQuery('PRAGMA table_info(feedbacks)');
        final columns = result.map((col) => col['name'] as String).toList();

        if (!columns.contains('rating')) {
          await db.execute('ALTER TABLE feedbacks ADD COLUMN rating INTEGER');
        }
      }
    }

    if (oldVersion < 5) {
      // Add status to users
      final userCols = await db.rawQuery('PRAGMA table_info(users)');
      final hasStatus = userCols.any((col) => col['name'] == 'status');
      if (!hasStatus) {
        await db.execute('ALTER TABLE users ADD COLUMN status TEXT DEFAULT "active"');
      }

      // Create system_notifications table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS system_notifications (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          message TEXT NOT NULL,
          type TEXT NOT NULL DEFAULT 'info',
          created_at TEXT NOT NULL,
          is_read INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS alert_files (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          alert_id INTEGER NOT NULL,
          file_path TEXT NOT NULL,
          file_name TEXT NOT NULL,
          FOREIGN KEY (alert_id) REFERENCES alerts(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT NOT NULL UNIQUE,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        national_card_number TEXT NOT NULL DEFAULT '',
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user',
        status TEXT NOT NULL DEFAULT 'active'
      )
    ''');

    await db.execute('''
      CREATE TABLE security_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer_hash TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        accuracy REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        created_at TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE alert_photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alert_id INTEGER NOT NULL,
        photo_path TEXT NOT NULL,
        FOREIGN KEY (alert_id) REFERENCES alerts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE alert_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alert_id INTEGER NOT NULL,
        file_path TEXT NOT NULL,
        file_name TEXT NOT NULL,
        FOREIGN KEY (alert_id) REFERENCES alerts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alert_id INTEGER NOT NULL,
        sender_role TEXT NOT NULL,
        message TEXT NOT NULL,
        created_at TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (alert_id) REFERENCES alerts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE feedbacks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        message TEXT NOT NULL,
        rating INTEGER,
        status TEXT NOT NULL DEFAULT 'pending',
        admin_reply TEXT,
        created_at TEXT NOT NULL,
        replied_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE system_notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'info',
        created_at TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Admin par défaut
    await db.insert('users', {
      'phone': 'admin',
      'nom': 'Admin',
      'prenom': 'System',
      'national_card_number': '000000000000000000',
      'password_hash': Utils.hashPassword('admin123'),
      'role': 'admin',
      'status': 'active',
    });
  }

  // ==================== USERS ====================

  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByPhone(String phone) async {
    final db = await database;
    final maps = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users', where: 'role = ?', whereArgs: ['user']);
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUserPassword(int userId, String newPasswordHash) async {
    final db = await database;
    return await db.update(
      'users',
      {'password_hash': newPasswordHash},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateUserStatus(int userId, String status) async {
    final db = await database;
    return await db.update(
      'users',
      {'status': status},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ==================== SECURITY QUESTIONS ====================

  Future<int> createSecurityQuestion(SecurityQuestion question) async {
    final db = await database;
    return await db.insert('security_questions', question.toMap());
  }

  Future<List<SecurityQuestion>> getSecurityQuestionsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query('security_questions', where: 'user_id = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) => SecurityQuestion.fromMap(maps[i]));
  }

  // ==================== ALERTS ====================

  Future<int> createAlert(Alert alert) async {
    final db = await database;
    return await db.insert('alerts', alert.toMap());
  }

  Future<List<Alert>> getAllAlerts() async {
    final db = await database;
    final maps = await db.query('alerts', orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => Alert.fromMap(maps[i]));
  }

  Future<List<Alert>> getAlertsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query('alerts', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => Alert.fromMap(maps[i]));
  }

  Future<List<Alert>> getAlertsByFilter({String? status}) async {
    final db = await database;
    if (status == null || status == 'all') {
      return await getAllAlerts();
    }
    final maps = await db.query('alerts', where: 'status = ?', whereArgs: [status], orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => Alert.fromMap(maps[i]));
  }

  Future<int> getUserAlertsCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM alerts WHERE user_id = ?', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> updateAlertStatus(int alertId, String status) async {
    final db = await database;
    return await db.update('alerts', {'status': status}, where: 'id = ?', whereArgs: [alertId]);
  }

  Future<AlertWithDetails?> getAlertWithDetails(int alertId) async {
    final db = await database;

    final alertMaps = await db.query('alerts', where: 'id = ?', whereArgs: [alertId]);
    if (alertMaps.isEmpty) return null;
    final alert = Alert.fromMap(alertMaps.first);

    final user = await getUserById(alert.userId);
    if (user == null) return null;

    final photos = await getPhotosByAlertId(alertId);
    final files = await getFilesByAlertId(alertId);
    final messageCount = await getMessageCountByAlertId(alertId);

    return AlertWithDetails(
      alert: alert,
      user: user,
      photos: photos,
      files: files,
      messageCount: messageCount,
    );
  }

  // ==================== ALERT PHOTOS ====================

  Future<int> createAlertPhoto(AlertPhoto photo) async {
    final db = await database;
    return await db.insert('alert_photos', photo.toMap());
  }

  Future<List<AlertPhoto>> getPhotosByAlertId(int alertId) async {
    final db = await database;
    final maps = await db.query('alert_photos', where: 'alert_id = ?', whereArgs: [alertId]);
    return List.generate(maps.length, (i) => AlertPhoto.fromMap(maps[i]));
  }

  // ==================== ALERT FILES ====================

  Future<int> createAlertFile(AlertFile file) async {
    final db = await database;
    return await db.insert('alert_files', file.toMap());
  }

  Future<List<AlertFile>> getFilesByAlertId(int alertId) async {
    final db = await database;
    final maps = await db.query('alert_files', where: 'alert_id = ?', whereArgs: [alertId]);
    return List.generate(maps.length, (i) => AlertFile.fromMap(maps[i]));
  }

  // ==================== MESSAGES ====================

  Future<int> createMessage(Message message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessagesByAlertId(int alertId) async {
    final db = await database;
    final maps = await db.query('messages', where: 'alert_id = ?', whereArgs: [alertId], orderBy: 'created_at ASC');
    return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
  }

  Future<int> getMessageCountByAlertId(int alertId) async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM messages WHERE alert_id = ?', [alertId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== FEEDBACKS ====================

  Future<int> createFeedback(UserFeedback feedback) async {
    final db = await database;
    return await db.insert('feedbacks', feedback.toMap());
  }

  Future<List<UserFeedback>> getFeedbacksByUserId(int userId) async {
    final db = await database;
    final maps = await db.query('feedbacks', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => UserFeedback.fromMap(maps[i]));
  }

  Future<List<UserFeedback>> getAllFeedbacks() async {
    final db = await database;
    final maps = await db.query('feedbacks', orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => UserFeedback.fromMap(maps[i]));
  }

  /// ✅ Répondre à un feedback
  Future<int> replyToFeedback(int feedbackId, String reply) async {
    final db = await database;
    return await db.update(
        'feedbacks',
        {
          'admin_reply': reply,
          'status': 'replied',
          'replied_at': DateTime.now().toIso8601String()
        },
        where: 'id = ?',
        whereArgs: [feedbackId]
    );
  }

  /// ✅ Changer le statut d'un feedback
  Future<int> updateFeedbackStatus(int feedbackId, String status) async {
    final db = await database;
    return await db.update(
      'feedbacks',
      {'status': status},
      where: 'id = ?',
      whereArgs: [feedbackId],
    );
  }

  // ==================== SYSTEM NOTIFICATIONS ====================

  Future<int> createSystemNotification(SystemNotification notification) async {
    final db = await database;
    return await db.insert('system_notifications', notification.toMap());
  }

  Future<List<SystemNotification>> getNotificationsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query('system_notifications', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => SystemNotification.fromMap(maps[i]));
  }

  Future<int> markNotificationAsRead(int notificationId) async {
    final db = await database;
    return await db.update('system_notifications', {'is_read': 1}, where: 'id = ?', whereArgs: [notificationId]);
  }

  Future<int> getUnreadNotificationsCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM system_notifications WHERE user_id = ? AND is_read = 0', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}