import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'database_helper.dart';
import 'models.dart';

/// Service de synchronisation Firebase pour les messages et alertes
/// Permet la communication en temps réel entre admin et utilisateurs
class FirebaseSyncService {
  static final FirebaseSyncService instance = FirebaseSyncService._init();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  FirebaseSyncService._init();

  /// Initialiser les listeners pour les messages
  void initializeMessageListeners(int userId, String userRole) {
    if (userRole == 'admin') {
      // Admin écoute tous les messages
      _listenToAllMessages();
    } else {
      // User écoute seulement ses propres alertes
      _listenToUserMessages(userId);
    }
  }

  /// Écouter tous les messages (pour admin)
  void _listenToAllMessages() {
    _database.child('messages').onChildAdded.listen((event) async {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        await _saveMessageLocally(data);
      }
    });
  }

  /// Écouter les messages de l'utilisateur spécifique
  void _listenToUserMessages(int userId) async {
    // Récupérer les alertes de l'utilisateur
    final alerts = await DatabaseHelper.instance.getAlertsByUserId(userId);

    for (var alert in alerts) {
      _database
          .child('messages')
          .orderByChild('alert_id')
          .equalTo(alert.id)
          .onChildAdded
          .listen((event) async {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          await _saveMessageLocally(data);
        }
      });
    }
  }

  /// Envoyer un message
  Future<void> sendMessage(Message message) async {
    try {
      // 1. Sauvegarder localement
      final localId = await DatabaseHelper.instance.createMessage(message);

      // 2. Envoyer à Firebase
      final messageRef = _database.child('messages').push();
      await messageRef.set({
        'local_id': localId,
        'alert_id': message.alertId,
        'sender_role': message.senderRole,
        'message': message.message,
        'created_at': message.createdAt.toIso8601String(),
        'timestamp': ServerValue.timestamp,
      });

      debugPrint('✅ Message envoyé à Firebase: ${messageRef.key}');
    } catch (e) {
      debugPrint('❌ Erreur envoi message Firebase: $e');
      rethrow;
    }
  }

  /// Sauvegarder un message Firebase localement
  Future<void> _saveMessageLocally(Map<String, dynamic> data) async {
    try {
      // Vérifier si le message existe déjà
      final existingMessages = await DatabaseHelper.instance
          .getMessagesByAlertId(data['alert_id']);

      final exists = existingMessages.any((msg) =>
      msg.message == data['message'] &&
          msg.senderRole == data['sender_role'] &&
          msg.createdAt.toIso8601String() == data['created_at']);

      if (!exists) {
        final message = Message(
          alertId: data['alert_id'],
          senderRole: data['sender_role'],
          message: data['message'],
          createdAt: DateTime.parse(data['created_at']),
          synced: 1,
        );

        await DatabaseHelper.instance.createMessage(message);
        debugPrint('✅ Message synchronisé localement');
      }
    } catch (e) {
      debugPrint('❌ Erreur sauvegarde message local: $e');
    }
  }

  /// Synchroniser une nouvelle alerte
  Future<void> syncAlert(Alert alert, List<AlertPhoto> photos) async {
    try {
      final alertRef = _database.child('alerts').push();

      await alertRef.set({
        'local_id': alert.id,
        'user_id': alert.userId,
        'type': alert.type,
        'description': alert.description,
        'latitude': alert.latitude,
        'longitude': alert.longitude,
        'accuracy': alert.accuracy,
        'status': alert.status,
        'created_at': alert.createdAt.toIso8601String(),
        'timestamp': ServerValue.timestamp,
      });

      // Synchroniser les photos
      for (var photo in photos) {
        final photoRef = _database.child('alert_photos').push();
        await photoRef.set({
          'alert_id': alert.id,
          'firebase_alert_key': alertRef.key,
          'photo_path': photo.photoPath,
        });
      }

      debugPrint('✅ Alerte synchronisée à Firebase');
    } catch (e) {
      debugPrint('❌ Erreur sync alerte Firebase: $e');
    }
  }

  /// Synchroniser le changement de statut d'une alerte
  Future<void> syncAlertStatus(int alertId, String newStatus) async {
    try {
      // Trouver l'alerte dans Firebase
      final snapshot = await _database
          .child('alerts')
          .orderByChild('local_id')
          .equalTo(alertId)
          .once();

      if (snapshot.snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        final firebaseKey = data.keys.first;

        await _database.child('alerts/$firebaseKey').update({
          'status': newStatus,
          'updated_at': ServerValue.timestamp,
        });

        debugPrint('✅ Statut synchronisé à Firebase');
      }
    } catch (e) {
      debugPrint('❌ Erreur sync statut Firebase: $e');
    }
  }

  /// Écouter les changements de statut des alertes
  void listenToAlertStatusChanges(Function(int alertId, String newStatus) onStatusChanged) {
    _database.child('alerts').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        if (data.containsKey('status') && data.containsKey('local_id')) {
          onStatusChanged(data['local_id'], data['status']);
        }
      }
    });
  }

  /// Nettoyer les listeners
  void dispose() {
    // Les listeners Firebase se nettoient automatiquement
  }
}