import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service de gestion des notifications locales
/// ✅ Compatible avec flutter_local_notifications v17.1.2
class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationService._init();

  /// Initialiser les notifications
  Future<void> initialize() async {
    // Configuration Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration iOS/macOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configuration globale
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);

    // ✅ Demander les permissions iOS
    final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // ✅ Demander les permissions Android 13+
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  /// Afficher notification de nouvelle alerte
  Future<void> showNewAlertNotification(int alertId, String type, String userName) async {
    const androidDetails = AndroidNotificationDetails(
      'alerts_channel',
      'Alertes',
      channelDescription: 'Notifications des nouvelles alertes',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ✅ CORRECTION v17.1.2 : Utiliser les paramètres positionnels
    await _notifications.show(
      alertId,                              // id (positionnel)
      '🚨 تنبيه جديد',                      // title (positionnel)
      'تم استلام تنبيه $type من $userName', // body (positionnel)
      details,                              // notificationDetails (positionnel)
    );
  }

  /// Afficher notification de changement de statut
  Future<void> showStatusChangeNotification(int alertId, String newStatus, String type) async {
    String statusText;
    switch (newStatus) {
      case 'in_progress':
        statusText = 'قيد المعالجة';
        break;
      case 'resolved':
        statusText = 'تم الحل';
        break;
      default:
        statusText = newStatus;
    }

    const androidDetails = AndroidNotificationDetails(
      'status_channel',
      'تحديثات الحالة',
      channelDescription: 'إشعارات تغيير حالة التنبيهات',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ✅ CORRECTION v17.1.2 : Paramètres positionnels
    await _notifications.show(
      alertId + 10000,
      '✅ تحديث حالة التنبيه',
      'تنبيه $type الآن: $statusText',
      details,
    );
  }

  /// Afficher notification de nouveau message
  Future<void> showNewMessageNotification(int alertId, String senderRole, String message) async {
    final sender = senderRole == 'admin' ? 'المدير' : 'المستخدم';

    const androidDetails = AndroidNotificationDetails(
      'messages_channel',
      'الرسائل',
      channelDescription: 'إشعارات الرسائل الجديدة',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ✅ CORRECTION v17.1.2 : Paramètres positionnels
    await _notifications.show(
      alertId + 20000,
      '💬 رسالة جديدة من $sender',
      message.length > 50 ? '${message.substring(0, 50)}...' : message,
      details,
    );
  }

  /// Annuler toutes les notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Annuler une notification spécifique
  /// ✅ CORRECTION v17.1.2 : cancel prend un paramètre positionnel 'id'
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}