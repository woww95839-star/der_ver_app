import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'context_extensions.dart';

class AdminDashboardScreen extends StatefulWidget {
  final User admin;

  const AdminDashboardScreen({super.key, required this.admin});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _totalAlerts = 0;
  int _pendingAlerts = 0;
  int _inProgressAlerts = 0;
  int _resolvedAlerts = 0;
  int _totalUsers = 0;
  int _totalFeedbacks = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final alerts = await DatabaseHelper.instance.getAllAlerts();
      final users = await DatabaseHelper.instance.getAllUsers();
      final feedbacks = await DatabaseHelper.instance.getAllFeedbacks();

      if (mounted) {
        setState(() {
          _totalAlerts = alerts.length;
          _pendingAlerts = alerts.where((a) => a.status == 'pending').length;
          _inProgressAlerts = alerts.where((a) => a.status == 'in_progress').length;
          _resolvedAlerts = alerts.where((a) => a.status == 'resolved').length;
          _totalUsers = users.length;
          _totalFeedbacks = feedbacks.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showError('${context.l10n.error}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navDashboard),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Carte de bienvenue
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [context.colors.brand, context.colors.brand.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.admin.prenom.isNotEmpty ? widget.admin.prenom[0].toUpperCase() : 'A',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: context.colors.brand),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.isArabic ? 'مرحباً' : 'Welcome', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          Text(
                            widget.admin.fullName,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              context.l10n.admin,
                              style: TextStyle(color: context.colors.brand, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(context.l10n.statistics, style: context.titleLarge?.bold),
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
            else ...[
              Row(
                children: [
                  Expanded(child: _StatCard(title: context.l10n.totalAlerts, value: _totalAlerts, icon: Icons.list_alt, color: Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(title: context.l10n.navUsers, value: _totalUsers, icon: Icons.people, color: Colors.purple)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(title: context.l10n.statusPending, value: _pendingAlerts, icon: Icons.pending, color: Colors.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(title: context.l10n.feedback, value: _totalFeedbacks, icon: Icons.feedback, color: Colors.teal)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(title: context.l10n.statusInProgress, value: _inProgressAlerts, icon: Icons.sync, color: Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(title: context.l10n.statusResolved, value: _resolvedAlerts, icon: Icons.check_circle, color: Colors.green)),
                ],
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [color.withOpacity(0.1), color.withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value.toString(), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700]), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
