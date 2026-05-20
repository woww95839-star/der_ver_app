import 'package:flutter/material.dart';
import 'models.dart';
import 'l10n/app_localizations.dart';

/// Modèle pour les retours/feedbacks utilisateur
class UserFeedback {
  final int? id;
  final int userId;
  final String message;
  final int? rating; // Note sur 5 étoiles
  final String status; // 'pending', 'read', 'replied'
  final String? adminReply;
  final DateTime createdAt;
  final DateTime? repliedAt;

  UserFeedback({
    this.id,
    required this.userId,
    required this.message,
    this.rating,
    this.status = 'pending',
    this.adminReply,
    DateTime? createdAt,
    this.repliedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'rating': rating,
      'status': status,
      'admin_reply': adminReply,
      'created_at': createdAt.toIso8601String(),
      'replied_at': repliedAt?.toIso8601String(),
    };
  }

  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      id: map['id'],
      userId: map['user_id'],
      message: map['message'],
      rating: map['rating'],
      status: map['status'] ?? 'pending',
      adminReply: map['admin_reply'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      repliedAt: map['replied_at'] != null ? DateTime.parse(map['replied_at']) : null,
    );
  }

  UserFeedback copyWith({
    int? id,
    int? userId,
    String? message,
    int? rating,
    String? status,
    String? adminReply,
    DateTime? createdAt,
    DateTime? repliedAt,
  }) {
    return UserFeedback(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      adminReply: adminReply ?? this.adminReply,
      createdAt: createdAt ?? this.createdAt,
      repliedAt: repliedAt ?? this.repliedAt,
    );
  }

  /// Retourne le libellé du statut localisé
  String getStatusLabel(AppLocalizations l10n) {
    switch (status) {
      case 'pending':
        return l10n.feedbackStatusPending;
      case 'read':
        return l10n.feedbackStatusRead;
      case 'replied':
        return l10n.feedbackStatusReplied;
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'read':
        return const Color(0xFF2196F3); // Blue
      case 'replied':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}

/// Modèle pour les feedbacks avec détails utilisateur
class FeedbackWithDetails {
  final UserFeedback feedback;
  final User user;

  FeedbackWithDetails({
    required this.feedback,
    required this.user,
  });
}
