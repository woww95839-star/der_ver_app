import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'l10n/app_localizations.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<User> _users = [];
  List<int> _userAlertCounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);

    try {
      final users = await DatabaseHelper.instance.getAllUsers();
      final alertCounts = <int>[];

      for (var user in users) {
        final count = await DatabaseHelper.instance.getUserAlertsCount(user.id!);
        alertCounts.add(count);
      }

      setState(() {
        _users = users;
        _userAlertCounts = alertCounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading users: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleUserBlock(User user) async {
    final l10n = AppLocalizations.of(context)!;
    final newStatus = user.isBlocked ? 'active' : 'blocked';
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.isBlocked ? l10n.unblockUser : l10n.blockUser),
        content: Text(user.isBlocked ? l10n.unblockConfirm : l10n.blockConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: user.isBlocked ? Colors.green : Colors.red),
            child: Text(user.isBlocked ? l10n.unblockUser : l10n.blockUser),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.updateUserStatus(user.id!, newStatus);
      
      // Notify user via system notification
      await DatabaseHelper.instance.createSystemNotification(
        SystemNotification(
          userId: user.id!,
          title: newStatus == 'blocked' ? l10n.errorBlockedAccount : l10n.success,
          message: newStatus == 'blocked' ? l10n.blockConfirm : l10n.userUnblocked,
          type: newStatus == 'blocked' ? 'block' : 'info',
        ),
      );

      _loadUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(newStatus == 'blocked' ? l10n.userBlocked : l10n.userUnblocked)),
        );
      }
    }
  }

  void _showWarningDialog(User user) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sendWarning),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.warningHint,
            labelText: l10n.warningMessage,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await DatabaseHelper.instance.createSystemNotification(
                  SystemNotification(
                    userId: user.id!,
                    title: l10n.warningTitle,
                    message: controller.text.trim(),
                    type: 'warning',
                  ),
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.warningSent)),
                  );
                }
              }
            },
            child: Text(l10n.submit),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(User user, int alertCount) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.fullName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(icon: Icons.person, label: l10n.userFullName, value: user.fullName),
              const SizedBox(height: 12),
              _DetailRow(icon: Icons.phone, label: l10n.userPhone, value: user.phone),
              const SizedBox(height: 12),
              _DetailRow(icon: Icons.badge, label: l10n.userNationalCard, value: user.nationalCardNumber),
              const SizedBox(height: 12),
              _DetailRow(icon: Icons.notifications, label: l10n.userAlertsCount, value: alertCount.toString()),
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.info_outline, 
                label: l10n.alertStatus, 
                value: user.isBlocked ? l10n.statusBlocked : l10n.statusActive,
                valueColor: user.isBlocked ? Colors.red : Colors.green,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navUsers),
            if (_users.isNotEmpty)
              Text(
                '${_users.length} ${l10n.user}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.noData,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadUsers,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            final alertCount = _userAlertCounts[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: user.isBlocked 
                    ? const BorderSide(color: Colors.red, width: 1)
                    : BorderSide.none,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: user.isBlocked ? Colors.grey : const Color(0xFFD32F2F),
                  child: Text(
                    user.prenom.isNotEmpty ? user.prenom[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  user.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: user.isBlocked ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(user.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      onPressed: () => _showWarningDialog(user),
                      tooltip: l10n.sendWarning,
                    ),
                    IconButton(
                      icon: Icon(
                        user.isBlocked ? Icons.lock_open : Icons.lock_outline,
                        color: user.isBlocked ? Colors.green : Colors.red,
                      ),
                      onPressed: () => _toggleUserBlock(user),
                      tooltip: user.isBlocked ? l10n.unblockUser : l10n.blockUser,
                    ),
                  ],
                ),
                onTap: () => _showUserDetails(user, alertCount),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}