import 'package:flutter/material.dart';
import 'models.dart';
import 'admin_dashboard_screen.dart';
import 'admin_alerts_screen.dart';
import 'admin_users_screen.dart';
import 'admin_map_screen.dart';
import 'admin_feedback_screen.dart';
import 'settings_screen.dart';
import 'context_extensions.dart';

class AdminHomeScreen extends StatefulWidget {
  final User admin;

  const AdminHomeScreen({super.key, required this.admin});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminDashboardScreen(admin: widget.admin),
      const AdminAlertsScreen(),
      const AdminMapScreen(),
      const AdminUsersScreen(),
      const AdminFeedbackScreen(),
      SettingsScreen(user: widget.admin),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: context.colors.brand,
        unselectedItemColor: context.colors.textDisabled,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: context.l10n.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: context.l10n.navAlerts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: context.l10n.navMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: context.l10n.navUsers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.feedback),
            label: context.l10n.feedback,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
