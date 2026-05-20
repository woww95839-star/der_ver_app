import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

/// 📦 MODÈLES DE DONNÉES - Application Balagh Amen

// ==================== USER ====================

class User {
  final int? id;
  final String phone;
  final String nom;
  final String prenom;
  final String nationalCardNumber;
  final String passwordHash;
  final String role;
  final String status; // active, blocked

  User({
    this.id,
    required this.phone,
    required this.nom,
    required this.prenom,
    required this.nationalCardNumber,
    required this.passwordHash,
    this.role = 'user',
    this.status = 'active',
  });

  String get fullName => '$prenom $nom';
  bool get isAdmin => role == 'admin';
  bool get isBlocked => status == 'blocked';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'nom': nom,
      'prenom': prenom,
      'national_card_number': nationalCardNumber,
      'password_hash': passwordHash,
      'role': role,
      'status': status,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      phone: map['phone'],
      nom: map['nom'],
      prenom: map['prenom'],
      nationalCardNumber: map['national_card_number'] ?? '',
      passwordHash: map['password_hash'] ?? '',
      role: map['role'] ?? 'user',
      status: map['status'] ?? 'active',
    );
  }

  User copyWith({
    int? id,
    String? phone,
    String? nom,
    String? prenom,
    String? nationalCardNumber,
    String? passwordHash,
    String? role,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      nationalCardNumber: nationalCardNumber ?? this.nationalCardNumber,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}

// ==================== ALERT ====================

class Alert {
  final int? id; // ID Local (SQLite)
  final int userId;
  final String type;
  final String description;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String status;
  final DateTime createdAt;
  final int synced;

  Alert({
    this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.status = 'pending',
    DateTime? createdAt,
    this.synced = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'synced': synced,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['id'],
      userId: map['user_id'] ?? 0,
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      synced: map['synced'] ?? 0,
    );
  }

  Alert copyWith({
    int? id,
    int? userId,
    String? type,
    String? description,
    double? latitude,
    double? longitude,
    double? accuracy,
    String? status,
    DateTime? createdAt,
    int? synced,
  }) {
    return Alert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }

  // --- Helpers pour l'UI ---
  String getStatusLabel(AppLocalizations l10n) {
    switch (status) {
      case 'pending': return l10n.statusPending;
      case 'in_progress': return l10n.statusInProgress;
      case 'resolved': return l10n.statusResolved;
      default: return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'in_progress': return Colors.blue;
      case 'resolved': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'pending': return Icons.pending;
      case 'in_progress': return Icons.sync;
      case 'resolved': return Icons.check_circle;
      default: return Icons.info;
    }
  }
}

// ==================== MESSAGE ====================

class Message {
  final int? id;
  final int alertId; // Référence locale
  final String senderRole;
  final String message;
  final DateTime createdAt;
  final int synced;

  Message({
    this.id,
    required this.alertId,
    required this.senderRole,
    required this.message,
    DateTime? createdAt,
    this.synced = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isFromAdmin => senderRole == 'admin';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alert_id': alertId,
      'sender_role': senderRole,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'synced': synced,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      alertId: map['alert_id'] ?? 0,
      senderRole: map['sender_role'] ?? '',
      message: map['message'] ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      synced: map['synced'] ?? 0,
    );
  }
}

// ==================== SYSTEM NOTIFICATION ====================

class SystemNotification {
  final int? id;
  final int userId;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  SystemNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type = 'info',
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
    };
  }

  factory SystemNotification.fromMap(Map<String, dynamic> map) {
    return SystemNotification(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'] ?? '',
      message: map['message'] ?? map['body'] ?? '',
      type: map['type'] ?? 'info',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      isRead: (map['is_read'] ?? 0) == 1,
    );
  }
}

// ==================== AUTRES MODÈLES (Résumé) ====================

class AlertPhoto {
  final int? id;
  final int alertId;
  final String photoPath;
  AlertPhoto({this.id, required this.alertId, required this.photoPath});
  Map<String, dynamic> toMap() => {'id': id, 'alert_id': alertId, 'photo_path': photoPath};
  factory AlertPhoto.fromMap(Map<String, dynamic> map) => AlertPhoto(id: map['id'], alertId: map['alert_id'], photoPath: map['photo_path']);
}

class AlertFile {
  final int? id;
  final int alertId;
  final String filePath;
  final String fileName;

  AlertFile({this.id, required this.alertId, required this.filePath, required this.fileName});

  Map<String, dynamic> toMap() => {
    'id': id,
    'alert_id': alertId,
    'file_path': filePath,
    'file_name': fileName,
  };

  factory AlertFile.fromMap(Map<String, dynamic> map) => AlertFile(
    id: map['id'],
    alertId: map['alert_id'],
    filePath: map['file_path'],
    fileName: map['file_name'],
  );
}

class SecurityQuestion {
  final int? id;
  final int userId;
  final String question;
  final String answerHash;
  SecurityQuestion({this.id, required this.userId, required this.question, required this.answerHash});
  Map<String, dynamic> toMap() => {'id': id, 'user_id': userId, 'question': question, 'answer_hash': answerHash};
  factory SecurityQuestion.fromMap(Map<String, dynamic> map) => SecurityQuestion(id: map['id'], userId: map['user_id'], question: map['question'], answerHash: map['answer_hash']);
}

class AlertWithDetails {
  final Alert alert;
  final User user;
  final List<AlertPhoto> photos;
  final List<AlertFile> files;
  final int messageCount;

  AlertWithDetails({
    required this.alert,
    required this.user,
    required this.photos,
    this.files = const [],
    required this.messageCount
  });
}
