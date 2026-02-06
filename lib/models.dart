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

  /// Nom complet
  String get fullName => '$prenom $nom';

  /// Est admin?
  bool get isAdmin => role == 'admin';

  /// Est bloqué?
  bool get isBlocked => status == 'blocked';

  /// Convertir en Map pour SQLite
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

  /// Créer depuis Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      phone: map['phone'],
      nom: map['nom'],
      prenom: map['prenom'],
      nationalCardNumber: map['national_card_number'] ?? '',
      passwordHash: map['password_hash'],
      role: map['role'] ?? 'user',
      status: map['status'] ?? 'active',
    );
  }

  /// Copier avec modifications
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

// ==================== SECURITY QUESTION ====================

class SecurityQuestion {
  final int? id;
  final int userId;
  final String question;
  final String answerHash;

  SecurityQuestion({
    this.id,
    required this.userId,
    required this.question,
    required this.answerHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'question': question,
      'answer_hash': answerHash,
    };
  }

  factory SecurityQuestion.fromMap(Map<String, dynamic> map) {
    return SecurityQuestion(
      id: map['id'],
      userId: map['user_id'],
      question: map['question'],
      answerHash: map['answer_hash'],
    );
  }
}

// ==================== ALERT ====================

class Alert {
  final int? id;
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

  /// Texte du statut (non localisé pour compatibilité)
  String get statusText {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'in_progress':
        return 'En cours';
      case 'resolved':
        return 'Résolu';
      default:
        return status;
    }
  }

  /// Texte du statut localisé
  String getStatusLabel(AppLocalizations l10n) {
    switch (status) {
      case 'pending':
        return l10n.statusPending;
      case 'in_progress':
        return l10n.statusInProgress;
      case 'resolved':
        return l10n.statusResolved;
      default:
        return status;
    }
  }

  /// Couleur du statut
  Color get statusColor {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'in_progress':
        return const Color(0xFF2196F3); // Bleu
      case 'resolved':
        return const Color(0xFF4CAF50); // Vert
      default:
        return const Color(0xFF9E9E9E); // Gris
    }
  }

  /// Icône du statut
  IconData get statusIcon {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'in_progress':
        return Icons.sync;
      case 'resolved':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  /// Est synchronisé?
  bool get isSynced => synced == 1;

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
      userId: map['user_id'],
      type: map['type'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      accuracy: map['accuracy'],
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['created_at']),
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
}

// ==================== ALERT PHOTO ====================

class AlertPhoto {
  final int? id;
  final int alertId;
  final String photoPath;

  AlertPhoto({
    this.id,
    required this.alertId,
    required this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alert_id': alertId,
      'photo_path': photoPath,
    };
  }

  factory AlertPhoto.fromMap(Map<String, dynamic> map) {
    return AlertPhoto(
      id: map['id'],
      alertId: map['alert_id'],
      photoPath: map['photo_path'],
    );
  }
}

// ==================== ALERT FILE ====================

class AlertFile {
  final int? id;
  final int alertId;
  final String filePath;
  final String fileName;

  AlertFile({
    this.id,
    required this.alertId,
    required this.filePath,
    required this.fileName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alert_id': alertId,
      'file_path': filePath,
      'file_name': fileName,
    };
  }

  factory AlertFile.fromMap(Map<String, dynamic> map) {
    return AlertFile(
      id: map['id'],
      alertId: map['alert_id'],
      filePath: map['file_path'],
      fileName: map['file_name'],
    );
  }
}

// ==================== MESSAGE ====================

class Message {
  final int? id;
  final int alertId;
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

  /// Est envoyé par un admin?
  bool get isFromAdmin => senderRole == 'admin';

  /// Est synchronisé?
  bool get isSynced => synced == 1;

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
      alertId: map['alert_id'],
      senderRole: map['sender_role'],
      message: map['message'],
      createdAt: DateTime.parse(map['created_at']),
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
  final String type; // warning, info, block
  final DateTime createdAt;
  final int isRead;

  SystemNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type = 'info',
    DateTime? createdAt,
    this.isRead = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  factory SystemNotification.fromMap(Map<String, dynamic> map) {
    return SystemNotification(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      message: map['message'],
      type: map['type'] ?? 'info',
      createdAt: DateTime.parse(map['created_at']),
      isRead: map['is_read'] ?? 0,
    );
  }
}

// ==================== ALERT WITH DETAILS ====================

/// Alerte avec toutes ses informations liées
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
    required this.files,
    required this.messageCount,
  });
}

// ==================== TYPES D'ALERTES ====================

class AlertType {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const AlertType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  /// Types d'alertes prédéfinis
  static List<AlertType> getTypes(AppLocalizations l10n) {
    return [
      AlertType(
        id: 'theft',
        name: l10n.alertTypeTheft,
        icon: Icons.work_off,
        color: const Color(0xFFF44336),
      ),
      AlertType(
        id: 'assault',
        name: l10n.alertTypeAssault,
        icon: Icons.warning,
        color: const Color(0xFFFF9800),
      ),
      AlertType(
        id: 'accident',
        name: l10n.alertTypeAccident,
        icon: Icons.car_crash,
        color: const Color(0xFFFF5722),
      ),
      AlertType(
        id: 'drug',
        name: l10n.alertTypeDrugs,
        icon: Icons.healing,
        color: const Color(0xFF4CAF50),
      ),
      AlertType(
        id: 'violence',
        name: l10n.alertTypeViolence,
        icon: Icons.local_fire_department,
        color: const Color(0xFFE91E63),
      ),
      AlertType(
        id: 'fraud',
        name: l10n.alertTypeFraud,
        icon: Icons.credit_card_off,
        color: const Color(0xFF673AB7),
      ),
      AlertType(
        id: 'other',
        name: l10n.alertTypeOther,
        icon: Icons.more_horiz,
        color: const Color(0xFF607D8B),
      ),
    ];
  }
}
