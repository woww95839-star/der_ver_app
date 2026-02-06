import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'context_extensions.dart';
import 'package:intl/intl.dart';

class UserNotificationsScreen extends StatefulWidget {
  final User user;

  const UserNotificationsScreen({super.key, required this.user});

  @override
  State<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  List<SystemNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final notifications = await DatabaseHelper.instance.getNotificationsByUserId(widget.user.id!);
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });

      // Marquer tout comme lu quand on ouvre l'écran
      for (var notification in notifications) {
        if (notification.isRead == 0) {
          await DatabaseHelper.instance.markNotificationAsRead(notification.id!);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showError('Error loading notifications: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        context.isArabic ? 'لا توجد إشعارات' : 'No notifications',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];

                    Color iconColor;
                    IconData iconData;

                    switch (notification.type) {
                      case 'warning':
                        iconColor = Colors.orange;
                        iconData = Icons.warning_amber_rounded;
                        break;
                      case 'block':
                        iconColor = Colors.red;
                        iconData = Icons.block;
                        break;
                      default:
                        iconColor = Colors.blue;
                        iconData = Icons.info_outline;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: notification.isRead == 0
                            ? BorderSide(color: context.colors.brand, width: 1)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: iconColor.withOpacity(0.1),
                          child: Icon(iconData, color: iconColor),
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(notification.message),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt),
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
